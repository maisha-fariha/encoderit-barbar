import '../../utils/date_range_utils.dart';

class ShopHoliday {
  const ShopHoliday({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.recursYearly,
  });

  final int id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final bool recursYearly;

  bool blocksDate(DateTime date) => isDateInBlockedRange(
        date: date,
        start: startDate,
        end: endDate,
        recursYearly: recursYearly,
      );

  factory ShopHoliday.fromJson(Map<String, dynamic> json) {
    final startRaw = json['start_date']?.toString() ?? '';
    final endRaw = json['end_date']?.toString() ?? startRaw;
    final start = parseApiDateOnly(startRaw) ?? DateTime(1970);
    final end = parseApiDateOnly(endRaw) ?? start;
    return ShopHoliday(
      id: _intFromJson(json['id']),
      name: json['name']?.toString() ?? '',
      startDate: start,
      endDate: end,
      recursYearly: json['recurs_yearly'] == true,
    );
  }
}

int _intFromJson(dynamic value) {
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}
