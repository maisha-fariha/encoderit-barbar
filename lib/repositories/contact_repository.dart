import 'package:flutter/foundation.dart';
import 'package:gems_data_layer/gems_data_layer.dart';

import '../utils/api_endpoints.dart';

/// Outcome of `POST /contacts`.
class SubmitContactOutcome {
  const SubmitContactOutcome({
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

/// Submits the public contact form.
///
/// Always returns [SubmitContactOutcome]; never throws.
class ContactRepository {
  ContactRepository({required this.apiService});

  final ApiService apiService;

  Future<SubmitContactOutcome> submit({
    required String name,
    required String email,
    required String subject,
    required String message,
  }) async {
    final body = <String, dynamic>{
      'name': name,
      'email': email,
      'subject': subject,
      'message': message,
    };

    if (kDebugMode) {
      debugPrint('[ContactRepository] POST ${ApiEndpoints.contacts} body=$body');
    }

    try {
      final response = await apiService.post<dynamic>(
        ApiEndpoints.contacts,
        data: body,
      );

      if (kDebugMode) {
        debugPrint(
          '[ContactRepository] success=${response.success} '
          'status=${response.statusCode} message=${response.message}',
        );
      }

      if (response.success) {
        return SubmitContactOutcome(
          success: true,
          message: (response.message ?? '').trim(),
        );
      }

      return SubmitContactOutcome(
        success: false,
        message: _messageFromResponse(response),
        errors: response.errors,
      );
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('[ContactRepository] exception: $e\n$st');
      }
      return SubmitContactOutcome(
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
}
