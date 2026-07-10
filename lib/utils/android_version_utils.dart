import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

/// True only on Android 10 ([Build.VERSION.RELEASE] == "10", API 29).
bool get isAndroid10 {
  if (kIsWeb || !Platform.isAndroid) return false;
  return Platform.operatingSystemVersion.trim() == '10';
}
