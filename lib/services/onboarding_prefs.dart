import 'package:shared_preferences/shared_preferences.dart';

import '../routes/app_pages.dart';

/// Persists whether the user has finished the opening/onboarding flow.
class OnboardingPrefs {
  OnboardingPrefs._();

  static const _key = 'encoderit_onboarding_completed_v2';

  static bool isCompleted(SharedPreferences prefs) =>
      prefs.getBool(_key) ?? false;

  static Future<void> markCompleted(SharedPreferences prefs) async {
    await prefs.setBool(_key, true);
  }

  /// Where to send users who are not signed in.
  static String loggedOutRoute(SharedPreferences prefs) =>
      isCompleted(prefs) ? AppRoutes.login : AppRoutes.onboarding;
}
