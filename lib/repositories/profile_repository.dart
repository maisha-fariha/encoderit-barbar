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
    this.avatarUrl,
  });

  final bool success;
  final String message;
  final Map<String, dynamic>? errors;
  final bool isNetworkError;
  final String? avatarUrl;
}

/// Result of `DELETE /profile` with `{ password }`.
class DeleteAccountOutcome {
  const DeleteAccountOutcome({
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

  /// Loads the latest profile from `GET /profile` into the local session.
  ///
  /// Login responses often omit address/dob/etc.; this keeps the profile screen
  /// in sync after logout/login.
  Future<bool> refreshSessionFromServer() async {
    try {
      final response = await apiService.get<dynamic>(ApiEndpoints.profile);
      if (!response.success) {
        if (kDebugMode) {
          debugPrint(
            '[ProfileRepository] GET ${ApiEndpoints.profile} failed: '
            '${response.message}',
          );
        }
        return false;
      }

      final auth = await authService.getStoredAuth();
      if (auth == null) return false;

      final merged = Map<String, dynamic>.from(auth.userData ?? {});
      _applyResponseUserMap(merged, response.data);

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
      return true;
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('[ProfileRepository] refreshSessionFromServer: $e\n$st');
      }
      return false;
    }
  }

  Future<DeleteAccountOutcome> deleteAccount({required String password}) async {
    final trimmed = password.trim();
    if (trimmed.isEmpty) {
      return const DeleteAccountOutcome(
        success: false,
        message: 'Password is required',
      );
    }

    try {
      if (kDebugMode) {
        debugPrint(
          '[ProfileRepository] >>> DELETE ${ApiEndpoints.profile} '
          '(password length=${trimmed.length})',
        );
      }

      final response = await apiService.delete<dynamic>(
        ApiEndpoints.profile,
        data: {'password': trimmed},
        options: Options(
          headers: const {'Accept': 'application/json'},
        ),
      );

      if (kDebugMode) {
        debugPrint(
          '[ProfileRepository] <<< DELETE ${ApiEndpoints.profile} '
          'success=${response.success} status=${response.statusCode} '
          'message=${response.message}',
        );
      }

      if (response.success) {
        if (Get.isRegistered<ProfileAvatarService>()) {
          await Get.find<ProfileAvatarService>().clearLocalAvatar();
        }
        return DeleteAccountOutcome(
          success: true,
          message: _successMessageFromResponse(response),
        );
      }

      return DeleteAccountOutcome(
        success: false,
        message: _messageFromResponse(response),
        errors: response.errors,
      );
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('[ProfileRepository] deleteAccount exception: $e\n$st');
      }
      return DeleteAccountOutcome(
        success: false,
        message: e.toString(),
        isNetworkError: true,
      );
    }
  }

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
        final avatarUrl = await _mergeStoredUser(
          request.toFormFields(),
          response.data,
        );
        return UpdateProfileOutcome(
          success: true,
          message: _successMessageFromResponse(response),
          avatarUrl: avatarUrl,
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
        '  note: API returns avatar (string URL) in JSON response; '
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

  Future<String?> _mergeStoredUser(
    Map<String, dynamic> sent,
    dynamic responseData,
  ) async {
    final auth = await authService.getStoredAuth();
    if (auth == null) return null;

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

    // Prefer just-sent editable fields over empty/partial API echoes.
    for (final key in <String>[
      'name',
      'email',
      'phone',
      'dob',
      'address',
      'zip_code',
      'province',
      'municipality',
      'country',
    ]) {
      final v = sent[key];
      if (v is String && v.trim().isNotEmpty) {
        merged[key] = v.trim();
      }
    }

    await authService.applySession(
      AuthData(
        accessToken: auth.accessToken,
        refreshToken: auth.refreshToken,
        expiresAt: auth.expiresAt,
        userData: merged,
      ),
    );

    final displayAvatar =
        resolveAvatarDisplayUrl(sessionAvatarFromUserData(merged));
    if (displayAvatar != null &&
        displayAvatar.isNotEmpty &&
        Get.isRegistered<ProfileAvatarService>()) {
      await Get.find<ProfileAvatarService>().clearLocalAvatar();
    } else if (Get.isRegistered<ProfileAvatarService>()) {
      Get.find<ProfileAvatarService>().revision.value++;
    }

    return displayAvatar;
  }

  /// Supports `{ data: { id, avatar, … } }`, `{ user: … }`, or a flat profile map.
  Map<String, dynamic>? _profilePayloadFromResponse(dynamic responseData) {
    if (responseData is! Map) return null;
    final root = Map<String, dynamic>.from(responseData);

    if (root['user'] is Map) {
      return Map<String, dynamic>.from(root['user'] as Map);
    }

    final data = root['data'];
    if (data is Map) {
      final dataMap = Map<String, dynamic>.from(data);
      if (dataMap['user'] is Map) {
        return Map<String, dynamic>.from(dataMap['user'] as Map);
      }
      if (_looksLikeProfilePayload(dataMap)) return dataMap;
    }

    if (_looksLikeProfilePayload(root)) return root;

    return null;
  }

  bool _looksLikeProfilePayload(Map<String, dynamic> map) {
    return map.containsKey('id') ||
        map.containsKey('email') ||
        map.containsKey('avatar') ||
        map.containsKey('avatar_url');
  }

  void _applyResponseUserMap(
    Map<String, dynamic> merged,
    dynamic responseData,
  ) {
    final payload = _profilePayloadFromResponse(responseData);
    if (payload == null) {
      if (kDebugMode) {
        debugPrint(
          '[ProfileRepository] Could not parse profile payload from: $responseData',
        );
      }
      return;
    }

    for (final e in payload.entries) {
      if (e.key == 'user_details' ||
          e.key == 'userDetails' ||
          e.key == 'profile') {
        continue;
      }
      if (e.value == null) continue;
      if (e.value is String && (e.value as String).trim().isEmpty) {
        // Don't wipe existing values with empty API fields.
        final existing = merged[e.key];
        if (existing is String && existing.trim().isNotEmpty) continue;
        if (existing != null && existing is! String) continue;
      }
      merged[e.key] = e.value;
    }

    final details = payload['user_details'] ??
        payload['userDetails'] ??
        payload['profile'];
    if (details is Map) {
      for (final e in Map<String, dynamic>.from(details).entries) {
        if (e.value == null) continue;
        if (e.value is String && (e.value as String).trim().isEmpty) {
          final existing = merged[e.key];
          if (existing is String && existing.trim().isNotEmpty) continue;
        }
        merged[e.key] = e.value;
      }
    }

    _normalizeAvatarUrlInMap(merged);
  }

  String _successMessageFromResponse(ApiResponse<dynamic> response) {
    final fromField = (response.message ?? '').trim();
    if (fromField.isNotEmpty) return fromField;
    final data = response.data;
    if (data is Map) {
      final message = data['message'];
      if (message is String && message.trim().isNotEmpty) {
        return message.trim();
      }
    }
    return '';
  }

  void _normalizeAvatarUrlInMap(Map<String, dynamic> map) {
    final raw = map['avatar'] ?? map['avatar_url'];
    if (raw is! String || raw.trim().isEmpty) return;
    final resolved = normalizeAvatarUrlForStorage(raw);
    if (resolved != null && resolved.isNotEmpty) {
      map['avatar'] = resolved;
      map.remove('avatar_url');
    }
  }
}
