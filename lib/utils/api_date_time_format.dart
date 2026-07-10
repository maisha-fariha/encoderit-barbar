import 'package:intl/intl.dart';

import 'date_range_utils.dart';
import 'shop_timezone.dart';

/// Formats appointment datetime for list/card display.
///
/// When [shopTimezone] is set, treats [dateTime] / [iso] as UTC and formats in
/// the shop's IANA zone. Otherwise keeps the previous wall-clock formatting.
String formatAppointmentDateTime(
  DateTime? dateTime, {
  String languageCode = 'it',
  String? iso,
  String? shopTimezone,
}) {
  final value = iso != null && iso.isNotEmpty
      ? parseApiWallClockDateTime(iso)
      : dateTime;
  if (value == null) return '';

  final tzName = shopTimezone?.trim();
  if (tzName != null && tzName.isNotEmpty) {
    return ShopTimezone.formatUtcInShop(
      utcOrWallAsUtc: value,
      shopTimezone: tzName,
      languageCode: languageCode,
    );
  }

  final locale = languageCode == 'it' ? 'it_IT' : 'en_US';
  return DateFormat('d MMMM yyyy, HH:mm', locale).format(value);
}
