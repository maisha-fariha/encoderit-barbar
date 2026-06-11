/// Parses `HH:mm` or `H:mm` into minutes since midnight.
int minutesFromClock(String raw) {
  final parts = raw.trim().split(':');
  if (parts.isEmpty) return 0;
  final h = int.tryParse(parts.first) ?? 0;
  final m = parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0;
  return h * 60 + m;
}

/// Formats [totalMinutes] as clock time (`H:mm` or `HH:mm`).
String formatClockMinutes(int totalMinutes, {required bool padHour}) {
  final hours = totalMinutes ~/ 60;
  final minutes = totalMinutes % 60;
  final hourText =
      padHour ? hours.toString().padLeft(2, '0') : hours.toString();
  return '$hourText:${minutes.toString().padLeft(2, '0')}';
}

/// Builds a slot label like `8:00 - 8:30` from API start time + service duration.
String formatSlotTimeRange(String startTime, int durationMinutes) {
  final trimmed = startTime.trim();
  if (trimmed.isEmpty) return trimmed;
  if (durationMinutes <= 0) return trimmed;

  final padHour = RegExp(r'^\d{2}:').hasMatch(trimmed);
  final startMinutes = minutesFromClock(trimmed);
  final endMinutes = startMinutes + durationMinutes;
  final startLabel = formatClockMinutes(startMinutes, padHour: padHour);
  final endLabel = formatClockMinutes(endMinutes, padHour: padHour);
  return '$startLabel - $endLabel';
}
