import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gems_core/gems_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'routes/app_pages.dart';
import 'widgets/app_scroll_behavior.dart';
import 'gen/l10n/app_localizations.dart';
import 'services/app_services.dart';
import 'services/profile_avatar_service.dart';
import 'auth/app_auth_gateway.dart';
import 'controllers/appointment_controller.dart';
import 'controllers/appointment_ui_refresh_controller.dart';
import 'controllers/auth_controller.dart';
import 'controllers/barber_list_controller.dart';
import 'controllers/contact_controller.dart';
import 'controllers/profile_controller.dart';
import 'controllers/reservation_list_controller.dart';
import 'controllers/shop_list_controller.dart';
import 'controllers/service_list_controller.dart';

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
      apiBaseUrl: 'https://iconico.encoder-test-vpn.space/api/v1',
      enableLogging: true,
      apiTimeout: const Duration(seconds: 30),
    ),
  );
  final auth = AppServices.getIt<AuthController>();
  Get.put(auth, permanent: true);
  final shopList = AppServices.getIt<ShopListController>();
  Get.put(shopList, permanent: true);
  final serviceList = AppServices.getIt<ServiceListController>();
  Get.put(serviceList, permanent: true);
  final barberList = AppServices.getIt<BarberListController>();
  Get.put(barberList, permanent: true);

  final avatarService = ProfileAvatarService(
    gateway: AppServices.getIt<AppAuthGateway>(),
    prefs: AppServices.getIt<SharedPreferences>(),
  );
  await avatarService.initialize();
  Get.put(avatarService, permanent: true);

  final reservationList = AppServices.getIt<ReservationListController>();
  Get.put(reservationList, permanent: true);
  Get.put(AppointmentUiRefreshController(), permanent: true);
  final appointmentController = AppServices.getIt<AppointmentController>();
  Get.put(appointmentController, permanent: true);
  final contactController = AppServices.getIt<ContactController>();
  Get.put(contactController, permanent: true);
  final profileController = AppServices.getIt<ProfileController>();
  Get.put(profileController, permanent: true);
  await auth.bootstrap();
  await avatarService.onAuthChanged();

  final initialRoute = auth.isLoggedIn.value
      ? AppRoutes.home
      : AppRoutes.onboarding;
  runApp(EncoderitBarbarApp(initialRoute: initialRoute));
}

class EncoderitBarbarApp extends StatelessWidget {
  const EncoderitBarbarApp({super.key, required this.initialRoute});

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _statusBarStyle,
      child: GetMaterialApp(
        title: 'EncoderIT Barbar',
        scrollBehavior: const AppScrollBehavior(),
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorScheme: const ColorScheme.dark(
            surface: Color(0xFF242424),
            onSurface: Colors.white,
            primary: Color(0xFFEEEEEE),
            onPrimary: Colors.black,
          ),
          // Match main screens (black scaffolds) so route transitions never flash white.
          scaffoldBackgroundColor: Colors.black,
          canvasColor: Colors.black,
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: _statusBarStyle,
            backgroundColor: Colors.black,
            surfaceTintColor: Colors.transparent,
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
        supportedLocales: const [Locale('it'), Locale('en')],
        localeResolutionCallback: (locale, supportedLocales) =>
            const Locale('it'),
        builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
          value: _statusBarStyle,
          // Ensures there's never a white flash behind the first route.
          child: ColoredBox(
            color: Colors.black,
            child: child ?? const SizedBox.shrink(),
          ),
        ),
        initialRoute: initialRoute,
        getPages: AppPages.routes,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
