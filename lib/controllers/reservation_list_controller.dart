import 'package:gems_core/gems_core.dart';
import 'package:gems_data_layer/gems_data_layer.dart';
import 'package:get/get.dart';

import 'appointment_ui_refresh_controller.dart';
import '../models/appointment/appointment_model.dart';
import '../repositories/appointment_repository.dart';

class _ReservationTabQuery {
  const _ReservationTabQuery({
    required this.status,
    required this.expired,
  });

  final String status;
  final bool expired;
}

class ReservationListController extends BaseListController<AppointmentModel>
    with BaseControllerMixin<AppointmentModel> {
  ReservationListController({required this.repository});

  final AppointmentRepository repository;
  bool isLoadingMore = false;
  bool hasMore = true;
  int currentPage = 1;

  /// 0 = booked, 1 = completed, 2 = cancelled
  int activeTab = 0;
  final Map<int, int> tabCounts = {0: 0, 1: 0, 2: 0};

  static const _bookedTab = 0;
  static const _completedTab = 1;
  static const _cancelledTab = 2;

  _ReservationTabQuery _queryForTab(int tab) {
    return switch (tab) {
      _bookedTab => const _ReservationTabQuery(
        status: 'booked',
        expired: false,
      ),
      _completedTab => const _ReservationTabQuery(
        status: 'completed',
        expired: false,
      ),
      _cancelledTab => const _ReservationTabQuery(
        status: 'cancelled',
        expired: false,
      ),
      _ => const _ReservationTabQuery(
        status: 'booked',
        expired: false,
      ),
    };
  }

  void _applyPage(AppointmentPageResult page) {
    items
      ..clear()
      ..addAll(page.items);
    currentPage = page.currentPage;
    hasMore = page.currentPage < page.lastPage;
    tabCounts[activeTab] = page.total;
  }

  Future<void> _fetchTabTotal(int tab) async {
    final query = _queryForTab(tab);
    final result = await repository.getPage(
      1,
      useCache: false,
      forceNetwork: true,
      status: query.status,
      expired: query.expired,
    );
    result.when(
      success: (page) => tabCounts[tab] = page.total,
      failure: (_) {},
    );
  }

  Future<void> _fetchFirstPageFromNetwork() async {
    final query = _queryForTab(activeTab);
    final result = await repository.getPage(
      1,
      forceNetwork: true,
      status: query.status,
      expired: query.expired,
    );
    result.when(
      success: _applyPage,
      failure: (error) => setError(error.message),
    );
  }

  Future<void> loadTabCounts({int? skipTab}) async {
    final tabs = <int>[_bookedTab, _completedTab, _cancelledTab];
    await Future.wait(
      tabs
          .where((tab) => tab != skipTab)
          .map((tab) => _fetchTabTotal(tab)),
    );
    update(['reservation-list']);
  }

  @override
  Future<void> loadItems() async {
    hasMore = true;
    currentPage = 1;
    setLoading(items.isEmpty);
    setError('');
    try {
      await _fetchFirstPageFromNetwork();
      await loadTabCounts(skipTab: activeTab);
    } finally {
      setLoading(false);
    }
    update(['reservation-list']);
  }

  Future<void> switchTab(int tab) async {
    if (activeTab == tab) return;
    activeTab = tab;
    hasMore = true;
    currentPage = 1;
    setLoading(items.isEmpty);
    setError('');
    try {
      await _fetchFirstPageFromNetwork();
    } finally {
      setLoading(false);
    }
    update(['reservation-list']);
  }

  Future<void> reloadItemsFromNetwork() async {
    setError('');
    try {
      await _fetchFirstPageFromNetwork();
      await loadTabCounts(skipTab: activeTab);
    } finally {
      update(['reservation-list']);
    }
  }

  Future<void> loadNextPage() async {
    if (isLoading.value || isLoadingMore || !hasMore) return;
    isLoadingMore = true;
    try {
      final next = currentPage + 1;
      final query = _queryForTab(activeTab);
      final result = await repository.getPage(
        next,
        useCache: false,
        status: query.status,
        expired: query.expired,
      );
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

  Future<Result<void>> deleteAppointment(String appointmentId) async {
    final result = await repository.deleteAppointment(appointmentId);
    if (!result.isSuccess) return result;
    await repository.invalidateAppointmentsCache();
    await reloadItemsFromNetwork();
    if (Get.isRegistered<AppointmentUiRefreshController>()) {
      Get.find<AppointmentUiRefreshController>().notifyAppointmentsChanged();
    }
    return result;
  }

  Future<Result<void>> deleteRecurringGroup(String recurringGroupId) async {
    final result = await repository.deleteRecurringGroup(recurringGroupId);
    if (!result.isSuccess) return result;
    await repository.invalidateAppointmentsCache();
    await reloadItemsFromNetwork();
    if (Get.isRegistered<AppointmentUiRefreshController>()) {
      Get.find<AppointmentUiRefreshController>().notifyAppointmentsChanged();
    }
    return result;
  }
}
