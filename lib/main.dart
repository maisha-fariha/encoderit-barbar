import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gems_core/gems_core.dart';

import 'routes/app_pages.dart';
import 'services/app_services.dart';
import 'controllers/auth_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appServices = AppServices();
  await appServices.initialize(
    environmentMode: EnvironmentMode.development,
    appConfig: AppConfig(
      apiBaseUrl: 'https://reqres.in/api',
      enableLogging: true,
      apiTimeout: const Duration(seconds: 30),
    ),
  );

  Get.put(AppServices.getIt<AuthController>(), permanent: true);

  runApp(const EncoderitBarbarApp());
}

class EncoderitBarbarApp extends StatelessWidget {
  const EncoderitBarbarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'EncoderIT Barbar',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
