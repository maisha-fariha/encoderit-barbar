import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gems_core/gems_core.dart';

import 'routes/app_pages.dart';
import 'gen/l10n/app_localizations.dart';
import 'services/app_services.dart';
import 'controllers/auth_controller.dart';

const _statusBarStyle = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarIconBrightness: Brightness.light, // Android
  statusBarBrightness: Brightness.dark, // iOS (dark bg => light icons)
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(_statusBarStyle);

  // Required by pages that call Get.find<AuthController>() (login/register).
  final appServices = AppServices();
  await appServices.initialize(
    environmentMode: EnvironmentMode.development,
    appConfig: AppConfig(
      apiBaseUrl: 'https://reqres.in/api',
      enableLogging: true,
      apiTimeout: const Duration(seconds: 30),
    ),
  );
  final auth = AppServices.getIt<AuthController>();
  Get.put(auth, permanent: true);
  await auth.bootstrap();

  runApp(const EncoderitBarbarApp());
}

class EncoderitBarbarApp extends StatelessWidget {
  const EncoderitBarbarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _statusBarStyle,
      child: GetMaterialApp(
        title: 'EncoderIT Barbar',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          // Match main screens (black scaffolds) so route transitions never flash white.
          scaffoldBackgroundColor: Colors.black,
          canvasColor: Colors.black,
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: _statusBarStyle,
          ),
        ),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: const Locale('it'),
        fallbackLocale: const Locale('it'),
        supportedLocales: const [
          Locale('en'),
          Locale('it'),
        ],
        builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
          value: _statusBarStyle,
          // Ensures there's never a white flash behind the first route.
          child: ColoredBox(
            color: Colors.black,
            child: child ?? const SizedBox.shrink(),
          ),
        ),
        initialRoute: AppRoutes.onboarding,
        getPages: AppPages.routes,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
