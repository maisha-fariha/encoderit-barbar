import 'package:intl/intl.dart';

import 'date_range_utils.dart';

/// Formats appointment datetime for list/card display (API wall-clock, no TZ shift).
String formatAppointmentDateTime(
  DateTime? dateTime, {
  String languageCode = 'it',
  String? iso,
}) {
  final value = iso != null && iso.isNotEmpty
      ? parseApiWallClockDateTime(iso)
      : dateTime;
  if (value == null) return '';
  final locale = languageCode == 'it' ? 'it_IT' : 'en_US';
  return DateFormat('d MMMM yyyy, HH:mm', locale).format(value);
}
