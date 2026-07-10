import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/price_display_prefs.dart';
import '../utils/service_price_visibility.dart';

class PriceDisplayController extends GetxController {
  PriceDisplayController(this._prefs);

  final SharedPreferences _prefs;
  final RxBool showPricesInApp = true.obs;

  @override
  void onInit() {
    super.onInit();
    showPricesInApp.value = PriceDisplayPrefs.readShowPrices(_prefs);
  }

  Future<void> setShowPricesInApp(bool value) async {
    if (showPricesInApp.value == value) return;
    showPricesInApp.value = value;
    await PriceDisplayPrefs.saveShowPrices(_prefs, value);
  }

  bool shouldDisplayPrice(bool apiShowPrice) => shouldDisplayServicePrice(
        apiShowPrice: apiShowPrice,
        userShowsPrices: showPricesInApp.value,
      );
}
