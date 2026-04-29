import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../auth/app_auth_gateway.dart';
import '../routes/app_pages.dart';
import '../utils/api_endpoints.dart';

class AuthController extends GetxController {
  AuthController({
    required this.authGateway,
    required this.connectivity,
  });

  final AppAuthGateway authGateway;
  final Connectivity connectivity;

  final RxBool isLoggedIn = false.obs;
  final RxBool isBusy = false.obs;

  void _snackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFE8E8E8),
      colorText: const Color(0xFF0B0B0B),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
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
      // Temporary dev bypass: skip credential/API validation and auto-login.
      isLoggedIn.value = true;
      Get.offAllNamed(AppRoutes.home);
    } finally {
      isBusy.value = false;
    }
  }

  Future<void> register({
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
          if (fullName != null && fullName.trim().isNotEmpty) 'name': fullName.trim(),
          if (phone != null && phone.trim().isNotEmpty) 'phone': phone.trim(),
        },
        endpoint: ApiEndpoints.authRegister,
      );
      if (res.success && res.data != null) {
        isLoggedIn.value = true;
        _snackbar('Welcome', 'Account ready');
        Get.offAllNamed(AppRoutes.home);
      } else {
        _snackbar('Register failed', res.message ?? 'Unknown error');
      }
    } finally {
      isBusy.value = false;
    }
  }

  Future<void> logout() async {
    await authGateway.logout();
    isLoggedIn.value = false;
    Get.offAllNamed(AppRoutes.login);
  }
}
