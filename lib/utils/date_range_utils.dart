final _isoWallClockPattern = RegExp(
  r'^(\d{4})-(\d{2})-(\d{2})[T ](\d{2}):(\d{2})(?::(\d{2})(?:\.\d+)?)?',
);

/// Parses API ISO datetimes using wall-clock components only.
///
/// `2026-05-28T19:00:00+06:00` → 28 May 2026 19:00 (offset is ignored).
DateTime? parseApiWallClockDateTime(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is! String || value.isEmpty) return null;

  final match = _isoWallClockPattern.firstMatch(value.trim());
  if (match != null) {
    return DateTime(
      int.parse(match.group(1)!),
      int.parse(match.group(2)!),
      int.parse(match.group(3)!),
      int.parse(match.group(4)!),
      int.parse(match.group(5)!),
      match.group(6) != null ? int.parse(match.group(6)!) : 0,
    );
  }
  return DateTime.tryParse(value);
}

/// Parses `YYYY-MM-DD` into a local date at midnight.
DateTime? parseApiDateOnly(String raw) {
  final parts = raw.trim().split('-');
  if (parts.length < 3) return null;
  final y = int.tryParse(parts[0]);
  final m = int.tryParse(parts[1]);
  final d = int.tryParse(parts[2]);
  if (y == null || m == null || d == null) return null;
  return DateTime(y, m, d);
}

/// Whether [date] falls inside [start]..[end], with optional yearly recurrence.
bool isDateInBlockedRange({
  required DateTime date,
  required DateTime start,
  required DateTime end,
  required bool recursYearly,
}) {
  final day = DateTime(date.year, date.month, date.day);
  if (recursYearly) {
    final dKey = day.month * 100 + day.day;
    final sKey = start.month * 100 + start.day;
    final eKey = end.month * 100 + end.day;
    if (sKey <= eKey) return dKey >= sKey && dKey <= eKey;
    return dKey >= sKey || dKey <= eKey;
  }
  final startDay = DateTime(start.year, start.month, start.day);
  final endDay = DateTime(end.year, end.month, end.day);
  return !day.isBefore(startDay) && !day.isAfter(endDay);
}
