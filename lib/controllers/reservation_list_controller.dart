import 'package:gems_core/gems_core.dart';
import 'package:gems_data_layer/gems_data_layer.dart';

import '../models/appointment/appointment_model.dart';
import '../repositories/appointment_repository.dart';

class ReservationListController extends BaseListController<AppointmentModel>
    with BaseControllerMixin<AppointmentModel> {
  ReservationListController({required this.repository});

  final AppointmentRepository repository;
  bool isLoadingMore = false;
  bool hasMore = true;
  int currentPage = 1;

  @override
  Future<void> loadItems() async {
    items.clear();
    hasMore = true;
    currentPage = 1;
    setLoading(true);
    setError('');
    try {
      final result = await repository.getPage(1);
      result.when(
        success: (page) {
          items.clear();
          items.addAll(page.items);
          currentPage = page.currentPage;
          hasMore = page.currentPage < page.lastPage;
        },
        failure: (error) => setError(error.message),
      );
    } finally {
      setLoading(false);
    }
    update(['reservation-list']);
  }

  Future<void> loadNextPage() async {
    if (isLoading.value || isLoadingMore || !hasMore) return;
    isLoadingMore = true;
    try {
      final next = currentPage + 1;
      final result = await repository.getPage(next, useCache: false);
      result.when(
        success: (page) {
          items.addAll(page.items);
          currentPage = page.currentPage;
          hasMore = page.currentPage < page.lastPage;
        },
        failure: (error) => setError(error.message),
      );
    } finally {
      isLoadingMore = false;
      update(['reservation-list']);
    }
  }

  List<AppointmentModel> byStatus(String status) {
    final expected = _normalizeStatus(status);
    return items
        .where((e) => _normalizeStatus(e.status) == expected)
        .toList(growable: false);
  }

  String _normalizeStatus(String raw) {
    final status = raw.trim().toLowerCase();
    switch (status) {
      case 'booked':
      case 'upcoming':
      case 'confirmed':
      case 'pending':
        return 'booked';
      case 'done':
      case 'complete':
      case 'completed':
        return 'completed';
      case 'cancel':
      case 'canceled':
      case 'cancelled':
      case 'rejected':
        return 'cancelled';
      default:
        return status;
    }
  }

  Future<Result<void>> deleteAppointment(String appointmentId) async {
    final result = await repository.deleteAppointment(appointmentId);
    result.when(
      success: (_) {
        items.removeWhere((e) => e.id == appointmentId);
        update(['reservation-list']);
      },
      failure: (_) {},
    );
    return result;
  }

  Future<Result<void>> deleteRecurringGroup(String recurringGroupId) async {
    final result = await repository.deleteRecurringGroup(recurringGroupId);
    result.when(
      success: (_) {
        items.removeWhere((e) => e.recurringGroupId == recurringGroupId);
        update(['reservation-list']);
      },
      failure: (_) {},
    );
    return result;
  }
}
