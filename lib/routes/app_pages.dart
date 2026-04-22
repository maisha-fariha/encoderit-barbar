import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/barbar_list_controller.dart';
import '../pages/barbar_list_page.dart';
import '../pages/login_page.dart';
import '../pages/register_page.dart';
import '../pages/splash_page.dart';
import '../services/app_services.dart';

class AppRoutes {
  AppRoutes._();

  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const barbarList = '/barbar';
}

class AppPages {
  AppPages._();

  static final routes = <GetPage>[
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterPage(),
    ),
    GetPage(
      name: AppRoutes.barbarList,
      page: () => const BarbarListPage(),
      binding: BindingsBuilder(() {
        if (!Get.find<AuthController>().isLoggedIn.value) {
          Future.microtask(() => Get.offAllNamed(AppRoutes.login));
          return;
        }
        if (!Get.isRegistered<BarbarListController>()) {
          Get.put(AppServices.getIt<BarbarListController>());
        }
      }),
    ),
  ];
}
