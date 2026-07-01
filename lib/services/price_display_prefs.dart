import 'package:shared_preferences/shared_preferences.dart';

class PriceDisplayPrefs {
  PriceDisplayPrefs._();

  static const _key = 'encoderit_show_service_prices';

  static bool readShowPrices(SharedPreferences prefs) =>
      prefs.getBool(_key) ?? true;

  static Future<void> saveShowPrices(SharedPreferences prefs, bool value) async {
    await prefs.setBool(_key, value);
  }
}
