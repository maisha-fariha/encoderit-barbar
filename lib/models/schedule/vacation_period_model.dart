import '../../utils/date_range_utils.dart';

/// Barber- or shop-level closed period from `/barbers/:id/vacations`.
class VacationPeriod {
  const VacationPeriod({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.recursYearly,
    required this.shopIds,
  });

  final int id;
  final DateTime startDate;
  final DateTime endDate;
  final bool recursYearly;
  final List<int> shopIds;

  bool appliesToShop(int shopId) =>
      shopIds.isEmpty || shopIds.contains(shopId);

  bool blocksDate(DateTime date) => isDateInBlockedRange(
        date: date,
        start: startDate,
        end: endDate,
        recursYearly: recursYearly,
      );

  factory VacationPeriod.fromJson(Map<String, dynamic> json) {
    final startRaw = json['start_date']?.toString() ?? '';
    final endRaw = json['end_date']?.toString() ?? startRaw;
    final start = parseApiDateOnly(startRaw) ?? DateTime(1970);
    final end = parseApiDateOnly(endRaw) ?? start;
    return VacationPeriod(
      id: _intFromJson(json['id']),
      startDate: start,
      endDate: end,
      recursYearly: json['recurs_yearly'] == true,
      shopIds: _shopIdsFromJson(json['shop_ids']),
    );
  }
}

class BarberVacationsResult {
  const BarberVacationsResult({
    this.barberVacations = const <VacationPeriod>[],
    this.shopVacations = const <VacationPeriod>[],
  });

  final List<VacationPeriod> barberVacations;
  final List<VacationPeriod> shopVacations;

  static const empty = BarberVacationsResult();

  factory BarberVacationsResult.fromJson(Map<String, dynamic> json) {
    return BarberVacationsResult(
      barberVacations: _parseList(json['barber_vacations']),
      shopVacations: _parseList(json['shop_vacations']),
    );
  }
}

List<VacationPeriod> _parseList(dynamic raw) {
  if (raw is! List) return const <VacationPeriod>[];
  return raw
      .whereType<Map>()
      .map((e) => VacationPeriod.fromJson(Map<String, dynamic>.from(e)))
      .toList();
}

List<int> _shopIdsFromJson(dynamic raw) {
  if (raw is! List) return const <int>[];
  return raw
      .map((e) {
        if (e is int) return e;
        if (e is String) return int.tryParse(e);
        return null;
      })
      .whereType<int>()
      .toList();
}

int _intFromJson(dynamic value) {
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}
