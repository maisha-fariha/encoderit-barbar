import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

/// Central entry for API-driven session expiry (401 / Unauthenticated).
class SessionGuard {
  SessionGuard._();

  static bool _handling = false;

  static void onUnauthorized(String? message, {String? requestPath}) {
    if (_handling) return;
    if (!Get.isRegistered<AuthController>()) return;

    _handling = true;
    Get.find<AuthController>()
        .handleSessionExpired(message: message)
        .whenComplete(() {
      Future<void>.delayed(const Duration(seconds: 1), () {
        _handling = false;
      });
    });
  }
}
