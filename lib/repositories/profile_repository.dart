import 'package:flutter/foundation.dart';
import 'package:gems_data_layer/gems_data_layer.dart';

import '../models/profile/profile_update_request.dart';
import '../utils/api_endpoints.dart';

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
    final body = request.toJson();
    if (kDebugMode) {
      debugPrint('[ProfileRepository] PUT ${ApiEndpoints.profile} body=$body');
    }

    try {
      final response = await apiService.put<dynamic>(
        ApiEndpoints.profile,
        data: body,
      );

      if (kDebugMode) {
        debugPrint(
          '[ProfileRepository] success=${response.success} '
          'status=${response.statusCode} message=${response.message}',
        );
      }

      if (response.success) {
        await _mergeStoredUser(body, response.data);
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
    merged['avatar_url'] = sent['avatar_url'];
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
  }
}
