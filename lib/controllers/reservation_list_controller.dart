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
    final expected = status.trim().toLowerCase();
    return items
        .where((e) => e.status.trim().toLowerCase() == expected)
        .toList(growable: false);
  }
}
