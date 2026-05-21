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
