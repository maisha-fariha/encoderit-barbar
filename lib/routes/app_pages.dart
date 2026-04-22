import 'package:get/get.dart';

import '../controllers/barbar_list_controller.dart';
import '../pages/barbar_list_page.dart';
import '../services/app_services.dart';

class AppRoutes {
  AppRoutes._();

  static const barbarList = '/';
}

class AppPages {
  AppPages._();

  static final routes = <GetPage>[
    GetPage(
      name: AppRoutes.barbarList,
      page: () => const BarbarListPage(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<BarbarListController>()) {
          Get.put(AppServices.getIt<BarbarListController>());
        }
      }),
    ),
  ];
}
