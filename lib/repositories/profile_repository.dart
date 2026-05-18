import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gems_core/gems_core.dart';
import 'package:gems_data_layer/gems_data_layer.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:path/path.dart' as p;

import '../models/profile/profile_update_request.dart';
import '../services/profile_avatar_service.dart';
import '../utils/api_endpoints.dart';
import '../utils/avatar_url_resolver.dart';

/// Result of `PUT /profile`.
class UpdateProfileOutcome {
  const UpdateProfileOutcome({
    required this.success,
    required this.message,
    this.errors,
    this.isNetworkError = false,
  });

  final bool success;
  final String message;
  final Map<String, dynamic>? errors;
  final bool isNetworkError;
}

class ProfileRepository {
  ProfileRepository({
    required this.apiService,
    required this.authService,
  });

  final ApiService apiService;
  final AuthService authService;

  Future<UpdateProfileOutcome> updateProfile(ProfileUpdateRequest request) async {
    final hasAvatarFile = request.avatarFile != null;
    final headers = const {'Accept': 'application/json'};
    final url = '${Environment.instance.apiBaseUrl}${ApiEndpoints.profile}';

    try {
      final ApiResponse<dynamic> response;
      if (hasAvatarFile) {
        final file = request.avatarFile!;
        final filename = p.basename(file.path);
        final contentType = _imageDioMediaType(file.path);
        final form = FormData.fromMap({
          ...request.toFormFields(),
          'avatar': await MultipartFile.fromFile(
            file.path,
            filename: filename,
            contentType: contentType,
          ),
        });
        _logPutProfileRequest(
          url: url,
          headers: headers,
          body: form,
          sourceFile: file,
        );
        response = await apiService.put<dynamic>(
          ApiEndpoints.profile,
          data: form,
          options: Options(headers: headers),
        );
      } else {
        final body = request.toJson();
        _logPutProfileRequest(
          url: url,
          headers: headers,
          body: body,
        );
        response = await apiService.put<dynamic>(
          ApiEndpoints.profile,
          data: body,
        );
      }

      _logPutProfileResponse(response);

      if (response.success) {
        await _mergeStoredUser(request.toFormFields(), response.data);
        return UpdateProfileOutcome(
          success: true,
          message: (response.message ?? '').trim(),
        );
      }

      return UpdateProfileOutcome(
        success: false,
        message: _messageFromResponse(response),
        errors: response.errors,
      );
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('[ProfileRepository] exception: $e\n$st');
      }
      return UpdateProfileOutcome(
        success: false,
        message: e.toString(),
        isNetworkError: true,
      );
    }
  }

  void _logPutProfileRequest({
    required String url,
    required Map<String, dynamic> headers,
    required dynamic body,
    File? sourceFile,
  }) {
    if (!kDebugMode) return;

    final buffer = StringBuffer()
      ..writeln('[ProfileRepository] >>> PUT $url')
      ..writeln('  method: PUT')
      ..writeln('  requestHeaders: $headers');

    if (body is FormData) {
      final form = body;
      buffer
        ..writeln(
          '  contentType: multipart/form-data; boundary=${form.boundary}',
        )
        ..writeln('  bodySummary: ${form.fields.length} text part(s), '
            '${form.files.length} file part(s)')
        ..writeln('  --- multipart text parts (form-data / Text) ---');
      if (form.fields.isEmpty) {
        buffer.writeln('    (none)');
      } else {
        for (final part in form.fields) {
          final value = part.value;
          final display = value.isEmpty ? '(empty string)' : value;
          buffer.writeln('    ${part.key}: $display');
        }
      }
      buffer.writeln('  --- multipart file parts (form-data / File) ---');
      if (form.files.isEmpty) {
        buffer.writeln('    (none)');
      } else {
        for (final part in form.files) {
          final file = part.value;
          buffer
            ..writeln('    ${part.key}:')
            ..writeln('      type: MultipartFile')
            ..writeln('      filename: ${file.filename ?? '(null)'}')
            ..writeln(
              '      contentType: ${file.contentType?.mimeType ?? '(null)'}',
            )
            ..writeln('      length: ${file.length} bytes');
          if (sourceFile != null && part.key == 'avatar') {
            final exists = sourceFile.existsSync();
            buffer
              ..writeln('      sourcePath: ${sourceFile.path}')
              ..writeln('      sourceExistsOnDisk: $exists');
            if (exists) {
              buffer.writeln(
                '      sourceSizeOnDisk: ${sourceFile.lengthSync()} bytes',
              );
            }
          }
        }
      }
      buffer.writeln(
        '  note: API returns avatar_url (string) in JSON response; '
        'upload uses file part key "avatar" (Postman).',
      );
    } else if (body is Map) {
      buffer
        ..writeln('  contentType: application/json')
        ..writeln('  --- JSON body ---');
      try {
        buffer.writeln(
          const JsonEncoder.withIndent('    ').convert(body),
        );
      } catch (_) {
        buffer.writeln('    $body');
      }
    } else {
      buffer.writeln('  body: $body');
    }

    debugPrint(buffer.toString());
  }

  void _logPutProfileResponse(ApiResponse<dynamic> response) {
    if (!kDebugMode) return;

    final buffer = StringBuffer()
      ..writeln('[ProfileRepository] <<< PUT ${ApiEndpoints.profile} response')
      ..writeln('  success: ${response.success}')
      ..writeln('  statusCode: ${response.statusCode}')
      ..writeln('  message: ${response.message ?? '(null)'}')
      ..writeln('  errors: ${response.errors ?? '(null)'}')
      ..writeln('  --- response body ---');

    final data = response.data;
    if (data == null) {
      buffer.writeln('    (null)');
    } else if (data is Map || data is List) {
      try {
        buffer.writeln(const JsonEncoder.withIndent('    ').convert(data));
      } catch (_) {
        buffer.writeln('    $data');
      }
    } else {
      buffer.writeln('    $data');
    }

    debugPrint(buffer.toString());
  }

  DioMediaType _imageDioMediaType(String path) {
    final ext = p.extension(path).toLowerCase();
    switch (ext) {
      case '.png':
        return DioMediaType('image', 'png');
      case '.webp':
        return DioMediaType('image', 'webp');
      case '.gif':
        return DioMediaType('image', 'gif');
      default:
        return DioMediaType('image', 'jpeg');
    }
  }

  String _messageFromResponse(ApiResponse<dynamic> response) {
    final m = (response.message ?? '').trim();
    if (m.isNotEmpty) return m;
    return _firstErrorString(response.errors);
  }

  String _firstErrorString(Map<String, dynamic>? errors) {
    if (errors == null || errors.isEmpty) return '';
    for (final value in errors.values) {
      if (value is List && value.isNotEmpty && value.first is String) {
        final v = (value.first as String).trim();
        if (v.isNotEmpty) return v;
      }
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    return '';
  }

  Future<void> _mergeStoredUser(
    Map<String, dynamic> sent,
    dynamic responseData,
  ) async {
    final auth = await authService.getStoredAuth();
    if (auth == null) return;

    final merged = Map<String, dynamic>.from(auth.userData ?? {});

    merged['name'] = sent['name'];
    merged['email'] = sent['email'];
    merged['phone'] = sent['phone'];
    merged['dob'] = sent['dob'];
    merged['address'] = sent['address'];
    merged['zip_code'] = sent['zip_code'];
    merged['province'] = sent['province'];
    merged['municipality'] = sent['municipality'];
    merged['country'] = sent['country'];

    _applyResponseUserMap(merged, responseData);

    await authService.applySession(
      AuthData(
        accessToken: auth.accessToken,
        refreshToken: auth.refreshToken,
        expiresAt: auth.expiresAt,
        userData: merged,
      ),
    );

    if (Get.isRegistered<ProfileAvatarService>()) {
      Get.find<ProfileAvatarService>().revision.value++;
    }
  }

  void _applyResponseUserMap(
    Map<String, dynamic> merged,
    dynamic responseData,
  ) {
    if (responseData == null) return;
    if (responseData is! Map) return;
    final root = Map<String, dynamic>.from(responseData);
    dynamic user = root['user'];
    if (user == null && root['data'] is Map) {
      final data = Map<String, dynamic>.from(root['data'] as Map);
      user = data['user'] ?? data;
    }
    if (user is! Map) return;
    final u = Map<String, dynamic>.from(user);
    for (final e in u.entries) {
      if (e.value != null) merged[e.key] = e.value;
    }
    _normalizeAvatarUrlInMap(merged);
  }

  void _normalizeAvatarUrlInMap(Map<String, dynamic> map) {
    final raw = map['avatar_url'];
    if (raw is! String || raw.trim().isEmpty) return;
    final resolved = normalizeAvatarUrlForStorage(raw);
    if (resolved != null && resolved.isNotEmpty) {
      map['avatar_url'] = resolved;
    }
  }
}
