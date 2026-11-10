import '../models/appointment/appointment_model.dart';

/// Shop id of the customer's most recent appointment (by [startsAt], then
/// [AppointmentModelActivitySort.activitySortTime]).
String? shopIdFromLatestAppointment(Iterable<AppointmentModel> appointments) {
  AppointmentModel? latest;
  for (final item in appointments) {
    final shopId = item.shop?.id.trim() ?? '';
    if (shopId.isEmpty) continue;
    if (latest == null || _isMoreRecent(item, latest)) {
      latest = item;
    }
  }
  return latest?.shop?.id;
}

bool _isMoreRecent(AppointmentModel a, AppointmentModel b) {
  final aAt = a.startsAt ?? a.activitySortTime;
  final bAt = b.startsAt ?? b.activitySortTime;
  return aAt.isAfter(bAt);
}

/// Keeps appointments belonging to [shopId]. If [shopId] is null/empty, returns
/// [appointments] unchanged.
List<AppointmentModel> filterAppointmentsByShopId(
  Iterable<AppointmentModel> appointments,
  String? shopId,
) {
  final id = shopId?.trim() ?? '';
  if (id.isEmpty) return List<AppointmentModel>.from(appointments);
  return appointments
      .where((item) => (item.shop?.id.trim() ?? '') == id)
      .toList(growable: false);
}
