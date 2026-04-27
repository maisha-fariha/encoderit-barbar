import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:gems_data_layer/gems_data_layer.dart';
import 'package:get/get.dart';

import '../routes/app_pages.dart';
import '../utils/api_endpoints.dart';

class AuthController extends GetxController {
  AuthController({
    required this.authService,
    required this.connectivity,
  });

  final AuthService authService;
  final Connectivity connectivity;

  final RxBool isLoggedIn = false.obs;
  final RxBool isBusy = false.obs;

  Future<bool> _hasNetwork() async {
    final result = await connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  /// Online: [AuthService.isAuthenticated]. Offline: restore session from prefs if token exists and is not expired.
  Future<void> bootstrap() async {
    if (await _hasNetwork()) {
      isLoggedIn.value = await authService.isAuthenticated();
      return;
    }
    isLoggedIn.value = await _tryOfflineSession();
  }

  Future<bool> _tryOfflineSession() async {
    final stored = await authService.getStoredAuth();
    if (stored == null || stored.accessToken.isEmpty) return false;
    if (stored.isExpired) return false;
    authService.apiService.setAuthToken(stored.accessToken);
    return true;
  }

  Future<void> login(String email, String password) async {
    isBusy.value = true;
    try {
      final res = await authService.login(
        email: email,
        password: password,
        endpoint: ApiEndpoints.authLogin,
      );
      if (res.success && res.data != null) {
        isLoggedIn.value = true;
      } else {
        Get.snackbar('Login failed', res.message ?? 'Unknown error');
      }
    } finally {
      isBusy.value = false;
    }
  }

  Future<void> register(String email, String password) async {
    isBusy.value = true;
    try {
      final res = await authService.register(
        data: {'email': email, 'password': password},
        endpoint: ApiEndpoints.authRegister,
      );
      if (res.success && res.data != null) {
        isLoggedIn.value = true;
        Get.snackbar('Welcome', 'Account ready');
      } else {
        Get.snackbar('Register failed', res.message ?? 'Unknown error');
      }
    } finally {
      isBusy.value = false;
    }
  }

  Future<void> logout() async {
    await authService.logout();
    isLoggedIn.value = false;
    Get.offAllNamed(AppRoutes.login);
  }
}
