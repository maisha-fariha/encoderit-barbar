import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'routes/app_pages.dart';

const _statusBarStyle = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarIconBrightness: Brightness.light, // Android
  statusBarBrightness: Brightness.dark, // iOS (dark bg => light icons)
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(_statusBarStyle);

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
