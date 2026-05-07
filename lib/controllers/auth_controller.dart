import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:gems_data_layer/gems_data_layer.dart';
import 'package:get/get.dart';

import '../auth/app_auth_gateway.dart';
import '../routes/app_pages.dart';
import '../utils/api_endpoints.dart';

class AuthController extends GetxController {
  AuthController({required this.authGateway, required this.connectivity});

  final AppAuthGateway authGateway;
  final Connectivity connectivity;

  final RxBool isLoggedIn = false.obs;
  final RxBool isBusy = false.obs;

  String _extractApiMessage({
    required String? message,
    required Map<String, dynamic>? errors,
    required String fallback,
  }) {
    if (message != null && message.trim().isNotEmpty) {
      return message.trim();
    }
    if (errors != null && errors.isNotEmpty) {
      for (final value in errors.values) {
        if (value is List && value.isNotEmpty && value.first is String) {
          final first = (value.first as String).trim();
          if (first.isNotEmpty) return first;
        }
        if (value is String && value.trim().isNotEmpty) {
          return value.trim();
        }
      }
    }
    return fallback;
  }

  void _snackbar(String title, String message, {bool isError = false}) {
    final context = Get.context;
    if (context != null) {
      final messenger = ScaffoldMessenger.maybeOf(context);
      if (messenger != null) {
        messenger.clearSnackBars();
        messenger.showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color(0xFFE8E8E8),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF0B0B0B),
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  message,
                  style: TextStyle(
                    color: isError
                        ? const Color(0xFFB91C1C)
                        : const Color(0xFF0B0B0B),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            duration: const Duration(seconds: 4),
          ),
        );
        return;
      }
    }

    // Fallback only if no ScaffoldMessenger is available.
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFE8E8E8),
      colorText: isError ? const Color(0xFFB91C1C) : const Color(0xFF0B0B0B),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 4),
    );
  }

  Future<bool> _hasNetwork() async {
    final result = await connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  /// Online: [AppAuthGateway.isAuthenticated]. Offline: restore session from prefs if token exists and is not expired.
  Future<void> bootstrap() async {
    if (await _hasNetwork()) {
      isLoggedIn.value = await authGateway.isAuthenticated();
      return;
    }
    isLoggedIn.value = await _tryOfflineSession();
  }

  Future<bool> _tryOfflineSession() async {
    final stored = await authGateway.getStoredAuth();
    if (stored == null || stored.accessToken.isEmpty) return false;
    if (stored.isExpired) return false;
    authGateway.apiService.setAuthToken(stored.accessToken);
    return true;
  }

  Future<void> login(String email, String password) async {
    isBusy.value = true;
    try {
      final res = await authGateway.login(
        email: email,
        password: password,
        endpoint: ApiEndpoints.authLogin,
      );
      if (res.success && res.data != null) {
        isLoggedIn.value = true;
        _snackbar('Welcome back', 'Login successful');
        Get.offAllNamed(AppRoutes.home);
        return;
      }
      final errorMessage = _extractApiMessage(
        message: res.message,
        errors: res.errors,
        fallback: 'Invalid email or password',
      );
      _snackbar('Login failed', errorMessage, isError: true);
    } finally {
      isBusy.value = false;
    }
  }

  Future<ApiResponse<void>> register({
    required String email,
    required String password,
    String? fullName,
    String? phone,
  }) async {
    isBusy.value = true;
    try {
      final res = await authGateway.register(
        data: {
          'email': email,
          'password': password,
          'password_confirmation': password,
          'verification_method': 'otp',
          if (fullName != null && fullName.trim().isNotEmpty)
            'name': fullName.trim(),
          if (phone != null && phone.trim().isNotEmpty) 'phone': phone.trim(),
        },
        endpoint: ApiEndpoints.authRegister,
      );
      if (res.success && res.data != null) {
        final successMessage = _extractApiMessage(
          message: res.message,
          errors: res.errors,
          fallback: 'Registration successful. Please verify OTP.',
        );
        _snackbar('Registration successful', successMessage);
        return ApiResponse<void>(
          success: true,
          message: successMessage,
          statusCode: res.statusCode,
          errors: res.errors,
        );
      } else {
        final errorMessage = _extractApiMessage(
          message: res.message,
          errors: res.errors,
          fallback: 'Unknown error',
        );
        _snackbar('Register failed', errorMessage, isError: true);
        return ApiResponse<void>(
          success: false,
          message: errorMessage,
          statusCode: res.statusCode,
          errors: res.errors,
        );
      }
    } finally {
      isBusy.value = false;
    }
  }

  void completeRegistrationAfterOtp() {
    isLoggedIn.value = true;
    _snackbar('Welcome', 'Account verified successfully');
    Get.offAllNamed(AppRoutes.home);
  }

  Future<void> logout() async {
    await authGateway.logout();
    isLoggedIn.value = false;
    Get.offAllNamed(AppRoutes.login);
  }

  /// Request OTP for password reset (verification_method = otp).
  Future<ApiResponse<void>> requestPasswordResetOtp(String email) async {
    final res = await authGateway.apiService.post<Map<String, dynamic>>(
      ApiEndpoints.authForgotPassword,
      data: {'email': email, 'verification_method': 'otp'},
    );

    return ApiResponse<void>(
      success: res.success,
      message: res.message,
      statusCode: res.statusCode,
      errors: res.errors,
    );
  }

  /// Verify OTP for a given email (used in forgot-password flow).
  Future<ApiResponse<void>> verifyEmailOtp({
    required String email,
    required String otp,
  }) async {
    final res = await authGateway.apiService.post<Map<String, dynamic>>(
      ApiEndpoints.authVerifyOtp,
      data: {'email': email, 'otp': otp},
    );

    return ApiResponse<void>(
      success: res.success,
      message: res.message,
      statusCode: res.statusCode,
      errors: res.errors,
    );
  }

  /// Reset password with email + otp.
  Future<ApiResponse<void>> resetPasswordWithOtp({
    required String email,
    required String otp,
    required String password,
    required String passwordConfirmation,
  }) async {
    final res = await authGateway.apiService.post<Map<String, dynamic>>(
      ApiEndpoints.authResetPassword,
      data: {
        'email': email,
        'otp': otp,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );

    return ApiResponse<void>(
      success: res.success,
      message: res.message,
      statusCode: res.statusCode,
      errors: res.errors,
    );
  }
}
