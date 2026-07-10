import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Shop-timezone helpers (IANA ids like `Europe/Rome`, `Asia/Dhaka`).
///
/// Booking times are shop wall-clock; display converts UTC → shop timezone.
class ShopTimezone {
  ShopTimezone._();

  static bool _initialized = false;

  static void ensureInitialized() {
    if (_initialized) return;
    tzdata.initializeTimeZones();
    _initialized = true;
  }

  static String normalize(String? iana) {
    final value = (iana ?? '').trim();
    return value.isEmpty ? 'UTC' : value;
  }

  static tz.Location locationFor(String? iana) {
    ensureInitialized();
    try {
      return tz.getLocation(normalize(iana));
    } catch (_) {
      return tz.getLocation('UTC');
    }
  }

  /// Calendar "today" in the shop timezone (date-only, local midnight).
  static DateTime todayDate([String? iana]) {
    final now = tz.TZDateTime.now(locationFor(iana));
    return DateTime(now.year, now.month, now.day);
  }

  /// Formats a UTC instant (or UTC wall components) in the shop timezone.
  static String formatUtcInShop({
    required DateTime utcOrWallAsUtc,
    String? shopTimezone,
    required String languageCode,
  }) {
    final loc = locationFor(shopTimezone);
    final utc = DateTime.utc(
      utcOrWallAsUtc.year,
      utcOrWallAsUtc.month,
      utcOrWallAsUtc.day,
      utcOrWallAsUtc.hour,
      utcOrWallAsUtc.minute,
      utcOrWallAsUtc.second,
      utcOrWallAsUtc.millisecond,
      utcOrWallAsUtc.microsecond,
    );
    final shopLocal = tz.TZDateTime.from(utc, loc);
    final locale = languageCode == 'it' ? 'it_IT' : 'en_US';
    return DateFormat('d MMMM yyyy, HH:mm', locale).format(shopLocal);
  }
}
