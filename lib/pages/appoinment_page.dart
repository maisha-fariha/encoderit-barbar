import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gems_core/gems_core.dart';
import 'package:gems_responsive/gems_responsive.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/appointment_controller.dart';
import '../controllers/appointment_ui_refresh_controller.dart';
import '../controllers/barber_list_controller.dart';
import '../controllers/reservation_list_controller.dart';
import '../controllers/shop_list_controller.dart';
import '../controllers/service_list_controller.dart';
import '../gen/l10n/app_localizations.dart';
import '../models/appointment/availability_slot_model.dart';
import '../models/appointment/appointment_model.dart';
import '../models/appointment/recurring_preview_model.dart';
import '../models/barber/barber_model.dart';
import '../models/schedule/shop_holiday_model.dart';
import '../models/schedule/vacation_period_model.dart';
import '../models/shop/shop_model.dart';
import '../repositories/availability_repository.dart';
import '../repositories/appointment_repository.dart';
import '../repositories/barber_repository.dart';
import '../repositories/shop_repository.dart';
import '../routes/app_pages.dart';
import '../services/app_services.dart';
import '../utils/compact_screen_utils.dart';
import '../widgets/delete_appointment_confirm_dialog.dart';

int _appointmentGridCrossAxisCount(BuildContext context) {
  return ResponsiveHelper.getResponsiveValue<int>(
    context,
    small: 2,
    medium: 2,
    large: 4,
  );
}

/// Reference width for a medium 2-column grid (tablet portrait).
const double _kMediumGridReferenceWidth = 600;
const double _kMediumGridHorizontalPadding = 18;

/// Large screens: 4 columns, cell height capped to medium 2-column size.
double _gridAspectRatioLikeMediumTwoColumn(
  BuildContext context, {
  required int crossAxisCount,
  required double twoColumnAspectRatio,
}) {
  const spacing = 16.0;
  const refColumns = 2;
  final mediumGridWidth =
      _kMediumGridReferenceWidth - 2 * _kMediumGridHorizontalPadding;
  final mediumCellWidth =
      (mediumGridWidth - spacing * (refColumns - 1)) / refColumns;
  final mediumCellHeight = mediumCellWidth / twoColumnAspectRatio;

  final screenWidth = MediaQuery.sizeOf(context).width;
  final hPad = screenWidth >= 600 ? 28.0 : 18.0;
  final gridWidth = screenWidth - 2 * hPad;
  final cellWidth =
      (gridWidth - spacing * (crossAxisCount - 1)) / crossAxisCount;

  return cellWidth / mediumCellHeight;
}

/// ~4:5 width:height shop cards (reference design).
double _shopGridChildAspectRatio(BuildContext context) {
  final columns = _appointmentGridCrossAxisCount(context);
  const twoColRatio = 0.72;
  final compactTwoCol = 0.68;
  final referenceRatio =
      isCompactScreen(context) ? compactTwoCol : twoColRatio;
  if (columns > 2) {
    return _gridAspectRatioLikeMediumTwoColumn(
      context,
      crossAxisCount: columns,
      twoColumnAspectRatio: referenceRatio,
    );
  }
  return referenceRatio;
}

/// ~4:5 width:height barber cards (reference design, aligned with shop cards).
double _barberGridChildAspectRatio(BuildContext context) {
  final columns = _appointmentGridCrossAxisCount(context);
  const twoColRatio = 0.72;
  final compactTwoCol = 0.68;
  final referenceRatio =
      isCompactScreen(context) ? compactTwoCol : twoColRatio;
  if (columns > 2) {
    return _gridAspectRatioLikeMediumTwoColumn(
      context,
      crossAxisCount: columns,
      twoColumnAspectRatio: referenceRatio,
    );
  }
  return referenceRatio;
}

class AppoinmentPage extends StatefulWidget {
  const AppoinmentPage({super.key});

  @override
  State<AppoinmentPage> createState() => _AppoinmentPageState();
}

class _AppoinmentPageState extends State<AppoinmentPage> {
  int _step = 1;
  int _selectedService = 0;
  int _selectedBarber = -1;
  int _selectedTime = -1;
  DateTime _selectedDate = _today();
  bool _recurringEnabled = false;
  int _recurringIndex = -1; // -1 = nothing selected; otherwise 0..3
  int _howManyBookings = 0; // 0 = nothing selected; otherwise 1..52
  List<AvailabilitySlot> _slots = const <AvailabilitySlot>[];
  bool _isLoadingSlots = false;
  String _slotsErrorMessage = '';
  bool _isLoadingPreview = false;
  String _previewErrorMessage = '';
  List<RecurringPreviewDateItem> _previewItems = const <RecurringPreviewDateItem>[];
  final Set<String> _waitlistedOriginalDates = <String>{};
  final Map<String, int> _selectedAlternativeBarberByDate = <String, int>{};
  bool _pendingStep4WorkingDayAlign = false;
  List<ShopHoliday> _shopHolidays = const <ShopHoliday>[];
  List<VacationPeriod> _barberVacations = const <VacationPeriod>[];
  List<VacationPeriod> _shopVacations = const <VacationPeriod>[];

  static DateTime _today() {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }
  late final ShopListController _shopController;
  late final ServiceListController _serviceController;
  late final BarberListController _barberController;

  BarberModel? get _selectedBarberModel {
    final list = _barberController.items;
    if (list.isEmpty ||
        _selectedBarber < 0 ||
        _selectedBarber >= list.length) {
      return null;
    }
    return list[_selectedBarber];
  }

  bool get _hasBarberWorkingSchedule {
    final barber = _selectedBarberModel;
    return barber != null && barber.workingDayOfWeekValues.isNotEmpty;
  }

  bool _isShopHoliday(DateTime date) {
    for (final holiday in _shopHolidays) {
      if (holiday.blocksDate(date)) return true;
    }
    return false;
  }

  bool _isVacationDay(DateTime date) {
    for (final vacation in _barberVacations) {
      if (vacation.blocksDate(date)) return true;
    }
    final shopId = _selectedShopIdAsInt;
    if (shopId == null) return false;
    for (final vacation in _shopVacations) {
      if (!vacation.appliesToShop(shopId)) continue;
      if (vacation.blocksDate(date)) return true;
    }
    return false;
  }

  bool _isBarberWorkingDay(DateTime date) {
    final day = DateTime(date.year, date.month, date.day);
    if (day.isBefore(_today())) return false;
    final barber = _selectedBarberModel;
    if (barber == null) return false;
    if (!barber.isWorkingDay(day)) return false;
    if (_isShopHoliday(day)) return false;
    if (_isVacationDay(day)) return false;
    return true;
  }

  Future<void> _loadScheduleConstraints() async {
    final shopId = _selectedShopId;
    final barberId = _selectedBarberModel?.id;
    if (shopId == null || shopId.isEmpty) {
      if (!mounted) return;
      setState(() {
        _shopHolidays = const <ShopHoliday>[];
        _barberVacations = const <VacationPeriod>[];
        _shopVacations = const <VacationPeriod>[];
      });
      return;
    }

    final shopRepo = AppServices.getIt<ShopRepository>();
    final holidaysFuture = shopRepo.getHolidays(shopId);
    final vacationsFuture = barberId != null && barberId.isNotEmpty
        ? AppServices.getIt<BarberRepository>().getVacations(barberId)
        : Future.value(Result.success(BarberVacationsResult.empty));

    final holidaysOutcome = await holidaysFuture;
    final vacationsOutcome = await vacationsFuture;
    if (!mounted) return;

    setState(() {
      _shopHolidays = holidaysOutcome.isSuccess
          ? (holidaysOutcome.value ?? const <ShopHoliday>[])
          : const <ShopHoliday>[];
      final vacations = vacationsOutcome.value;
      if (vacationsOutcome.isSuccess && vacations != null) {
        _barberVacations = vacations.barberVacations;
        _shopVacations = vacations.shopVacations;
      } else {
        _barberVacations = const <VacationPeriod>[];
        _shopVacations = const <VacationPeriod>[];
      }
    });
  }

  static int _minutesFromClock(String raw) {
    final parts = raw.trim().split(':');
    if (parts.isEmpty) return 0;
    final h = int.tryParse(parts.first) ?? 0;
    final m = parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0;
    return h * 60 + m;
  }

  static bool _isClockTimeWithinRange(
    String time,
    String start,
    String end,
  ) {
    final t = _minutesFromClock(time);
    final s = _minutesFromClock(start);
    final e = _minutesFromClock(end);
    return t >= s && t <= e;
  }

  bool _isSlotSelectable(AvailabilitySlot slot) {
    if (!slot.available || slot.time.trim().isEmpty) return false;
    final hour = _selectedBarberModel?.workingHourForDate(_selectedDate);
    if (hour == null) return false;
    return _isClockTimeWithinRange(slot.time, hour.startTime, hour.endTime);
  }

  bool get _hasAvailableSlots => _slots.any(_isSlotSelectable);

  /// When the currently selected day has no available slots, move forward and
  /// pick the next working day that has at least one selectable slot.
  Future<void> _selectNextDateWithAvailableSlots({int searchDays = 45}) async {
    if (!_hasBarberWorkingSchedule) return;
    if (_hasAvailableSlots) return;

    final base = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    for (int offset = 1; offset <= searchDays; offset++) {
      final candidate = base.add(Duration(days: offset));
      if (!_isBarberWorkingDay(candidate)) continue;

      if (!mounted) return;
      setState(() {
        _selectedDate = candidate;
        _selectedTime = -1;
      });

      await _loadSlotsForSelection(showLoading: false);
      if (!mounted) return;
      if (_hasAvailableSlots) {
        await _loadRecurringPreview();
        return;
      }
    }
  }

  void _alignSelectedDateToNextWorkingDay() {
    if (!_hasBarberWorkingSchedule) return;
    if (_isBarberWorkingDay(_selectedDate)) return;

    for (int offset = 0; offset < 370; offset++) {
      final candidate = _today().add(Duration(days: offset));
      if (_isBarberWorkingDay(candidate)) {
        _selectedDate = candidate;
        return;
      }
    }
  }

  /// Runs after build when step 4 is shown so [BarberModel.hours] arriving after
  /// cache (or a stale selection) still snaps the pill selection to a valid day.
  void _scheduleStep4WorkingDayAlignment() {
    if (_step != 4) return;
    if (_pendingStep4WorkingDayAlign) return;
    _pendingStep4WorkingDayAlign = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _pendingStep4WorkingDayAlign = false;
      if (!mounted || _step != 4) return;
      if (!_hasBarberWorkingSchedule) return;
      if (_isBarberWorkingDay(_selectedDate)) return;

      final before = _selectedDate;
      setState(() {
        _alignSelectedDateToNextWorkingDay();
      });
      if (!mounted || before == _selectedDate) return;

      await _loadSlotsForSelection(showLoading: false);
      await _loadRecurringPreview();
    });
  }

  String? get _selectedSlotTime {
    if (_selectedTime < 0 || _selectedTime >= _slots.length) return null;
    final slot = _slots[_selectedTime];
    if (!slot.available) return null;
    final time = slot.time.trim();
    return time.isEmpty ? null : time;
  }

  int? get _selectedShopIdAsInt => int.tryParse(_selectedShopId ?? '');
  int? get _selectedServiceIdAsInt => int.tryParse(_selectedServiceId ?? '');
  int? get _selectedBarberIdAsInt {
    final list = _barberController.items;
    if (list.isEmpty || _selectedBarber < 0 || _selectedBarber >= list.length) {
      return null;
    }
    return int.tryParse(list[_selectedBarber].id);
  }

  List<_ServiceItem> get _items {
    return _serviceController.items
        .map(
          (service) => _ServiceItem(
            title: service.name,
            minutes: service.durationMinutes,
            priceEuro: service.price.round(),
          ),
        )
        .toList();
  }

  List<_BarberItem> get _barbers {
    return _barberController.items
        .map(
          (barber) => _BarberItem(
            name: barber.name,
            subtitle: barber.phone.isNotEmpty
                ? barber.phone
                : (barber.email.isNotEmpty ? barber.email : 'Barber'),
            imageAsset: 'assets/images/barbar_1.jpg',
          ),
        )
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _shopController = Get.find<ShopListController>();
    _serviceController = Get.find<ServiceListController>();
    _barberController = Get.find<BarberListController>();
    // Defer mutations that notify GetX/Obx (e.g. Contact's shop Obx) so we never
    // call them during this route's first build — avoids "markNeedsBuild during build".
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _shopController.loadItems();
      _serviceController.items.clear();
      _barberController.items.clear();
    });
  }

  /// Clears appointment cache, refreshes reservation list, and signals home to reload.
  Future<void> _syncAppointmentsAfterBooking() async {
    await AppServices.getIt<AppointmentRepository>().invalidateAppointmentsCache();
    if (Get.isRegistered<AppointmentUiRefreshController>()) {
      Get.find<AppointmentUiRefreshController>().notifyAppointmentsChanged();
    }
    if (Get.isRegistered<ReservationListController>()) {
      await Get.find<ReservationListController>().loadItems();
    }
  }

  String? get _selectedShopId => _shopController.selectedShop?.id;
  String? get _selectedServiceId {
    if (_serviceController.items.isEmpty ||
        _selectedService < 0 ||
        _selectedService >= _serviceController.items.length) {
      return null;
    }
    return _serviceController.items[_selectedService].id;
  }

  /// Display name of the barber chosen at step 3, or empty when none is loaded.
  ///
  /// Used by widgets that summarize earlier-step selections (e.g. the recurring
  /// summary card on step 4 and the booking summary on step 5).
  String get _selectedBarberName {
    final list = _barberController.items;
    if (list.isEmpty) return '';
    if (_selectedBarber < 0 || _selectedBarber >= list.length) return '';
    return list[_selectedBarber].name;
  }


  Future<void> _loadServicesForSelectedShop() async {
    final shopId = _selectedShopId;
    if (shopId == null || shopId.isEmpty) return;
    await _serviceController.loadByShop(shopId);
    if (_selectedService >= _serviceController.items.length) {
      _selectedService = 0;
    }
    _barberController.items.clear();
    _selectedBarber = -1;
  }

  Future<void> _loadBarbersForSelection({bool forceNetwork = false}) async {
    final shopId = _selectedShopId;
    final serviceId = _selectedServiceId;
    if (shopId == null ||
        shopId.isEmpty ||
        serviceId == null ||
        serviceId.isEmpty) {
      return;
    }
    final previousBarberId = _selectedBarberModel?.id;
    await _barberController.loadByShopAndService(
      shopId: shopId,
      serviceId: serviceId,
      forceNetwork: forceNetwork,
    );
    if (previousBarberId != null && previousBarberId.isNotEmpty) {
      final index = _barberController.items.indexWhere(
        (b) => b.id == previousBarberId,
      );
      if (index >= 0) {
        _selectedBarber = index;
      } else if (_selectedBarber >= _barberController.items.length) {
        _selectedBarber = -1;
      }
    } else if (_selectedBarber >= _barberController.items.length) {
      _selectedBarber = -1;
    }
  }

  /// Refreshes barber [hours], holidays, vacations, slots, and preview for step 4.
  Future<void> _refreshStep4ScheduleData() async {
    if (_step != 4) return;
    await _loadBarbersForSelection(forceNetwork: true);
    await _loadScheduleConstraints();
    if (!mounted || _step != 4) return;

    final previousDate = _selectedDate;
    setState(() {
      if (!_isBarberWorkingDay(_selectedDate)) {
        _alignSelectedDateToNextWorkingDay();
      }
    });
    if (!mounted || _step != 4) return;

    if (previousDate != _selectedDate) {
      _selectedTime = -1;
    }
    await _loadSlotsForSelection(showLoading: false);
    if (_recurringEnabled && _recurringIndex >= 0 && _howManyBookings >= 1) {
      await _loadRecurringPreview(showLoading: false);
    }
    _scheduleStep4WorkingDayAlignment();
  }

  Future<void> _loadSlotsForSelection({bool showLoading = true}) async {
    final shopId = int.tryParse(_selectedShopId ?? '');
    final serviceId = int.tryParse(_selectedServiceId ?? '');
    final barbers = _barberController.items;
    final barberId = (barbers.isNotEmpty &&
            _selectedBarber >= 0 &&
            _selectedBarber < barbers.length)
        ? int.tryParse(barbers[_selectedBarber].id)
        : null;
    if (shopId == null || serviceId == null || barberId == null) {
      setState(() {
        _slots = const <AvailabilitySlot>[];
        _selectedTime = -1;
        _slotsErrorMessage = '';
        _isLoadingSlots = false;
      });
      return;
    }

    if (!_isBarberWorkingDay(_selectedDate)) {
      setState(() {
        _slots = const <AvailabilitySlot>[];
        _selectedTime = -1;
        _slotsErrorMessage = '';
        _isLoadingSlots = false;
      });
      return;
    }

    if (showLoading) {
      setState(() {
        _isLoadingSlots = true;
        _slotsErrorMessage = '';
      });
    }

    final repo = AppServices.getIt<AvailabilityRepository>();
    final result = await repo.getSlots(
      shopId: shopId,
      serviceId: serviceId,
      barberId: barberId,
      date: _formatApiDate(_selectedDate),
    );
    if (!mounted) return;
    result.when(
      success: (data) {
        final slots = data.slots;
        int index = _selectedTime;
        final invalid = index < 0 ||
            index >= slots.length ||
            (index >= 0 && index < slots.length && !_isSlotSelectable(slots[index]));
        if (invalid) {
          index = slots.indexWhere(_isSlotSelectable);
        }
        setState(() {
          _slots = slots;
          _selectedTime = index;
          _slotsErrorMessage = '';
          _isLoadingSlots = false;
        });
      },
      failure: (error) {
        setState(() {
          _slots = const <AvailabilitySlot>[];
          _selectedTime = -1;
          _slotsErrorMessage = error.message;
          _isLoadingSlots = false;
        });
      },
    );
  }

  Future<void> _loadRecurringPreview({bool showLoading = true}) async {
    if (!_recurringEnabled || _recurringIndex < 0 || _howManyBookings < 1) {
      setState(() {
        _previewItems = const <RecurringPreviewDateItem>[];
        _previewErrorMessage = '';
        _isLoadingPreview = false;
      });
      return;
    }
    final shopId = _selectedShopIdAsInt;
    final serviceId = _selectedServiceIdAsInt;
    final barberId = _selectedBarberIdAsInt;
    final time = _selectedSlotTime;
    if (shopId == null || serviceId == null || barberId == null || time == null) {
      setState(() {
        _previewItems = const <RecurringPreviewDateItem>[];
        _previewErrorMessage = '';
        _isLoadingPreview = false;
      });
      return;
    }

    if (showLoading) {
      setState(() {
        _isLoadingPreview = true;
        _previewErrorMessage = '';
      });
    }

    final repo = AppServices.getIt<AppointmentRepository>();
    final outcome = await repo.previewRecurring(
      shopId: shopId,
      barberId: barberId,
      serviceId: serviceId,
      date: _formatApiDate(_selectedDate),
      time: time,
      quantity: _howManyBookings,
      interval: _recurringIndex + 1,
      type: 'weekly',
      notes: null,
    );

    if (!mounted) return;
    if (outcome.success) {
      assert(() {
        debugPrint(
          '[RecurringPreview] '
          'shop=$shopId service=$serviceId barber=$barberId '
          'date=${_formatApiDate(_selectedDate)} time=$time '
          'qty=$_howManyBookings interval=${_recurringIndex + 1} '
          'apiDates=${outcome.result?.dates.length ?? 0}',
        );
        return true;
      }());
      setState(() {
        _previewItems = outcome.result?.dates ?? const <RecurringPreviewDateItem>[];
        final allowedDates = _previewItems.map((e) => e.date).toSet();
        _waitlistedOriginalDates.retainAll(allowedDates);
        _pruneAlternativeBarberSelections();
        _previewErrorMessage = '';
        _isLoadingPreview = false;
      });
      assert(() {
        debugPrint('[RecurringPreview] renderedDates=${_previewItems.length}');
        return true;
      }());
      return;
    }

    setState(() {
      _previewItems = const <RecurringPreviewDateItem>[];
      _previewErrorMessage = outcome.message;
      _isLoadingPreview = false;
    });
  }

  void _showPageMessage(String message) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFFE8E8E8),
        content: Text(
          message,
          style: GoogleFonts.inter(
            color: const Color(0xFF0B0B0B),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showErrorMessage(String message) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFFE8E8E8),
        content: Text(
          message,
          style: GoogleFonts.inter(
            color: const Color(0xFFB91C1C),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  String _formatApiDate(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)}';
  }

  /// Maps UI recurrence to API repeat type.
  ///
  /// Current tab-4 options are all week-based frequencies, so `weekly`
  /// is correct for booking payloads.
  RecurringRepeatType _mapRecurringRepeatType(int recurringIndex) {
    return RecurringRepeatType.weekly;
  }

  int? _alternativeBarberIdForPreviewItem(RecurringPreviewDateItem item) {
    if (item.isAvailable || item.alternativeBarbers.isEmpty) return null;
    if (_waitlistedOriginalDates.contains(item.date)) return null;
    if (item.alternativeBarbers.length == 1) {
      return item.alternativeBarbers.first.id;
    }
    return _selectedAlternativeBarberByDate[item.date];
  }

  bool _hasUnresolvedAlternativeBarberSelections() {
    for (final item in _previewItems) {
      if (item.isAvailable || item.alternativeBarbers.length <= 1) continue;
      if (_waitlistedOriginalDates.contains(item.date)) continue;
      final selected = _selectedAlternativeBarberByDate[item.date];
      if (selected == null ||
          !item.alternativeBarbers.any((a) => a.id == selected)) {
        return true;
      }
    }
    return false;
  }

  List<Map<String, dynamic>> _buildRecurringOverrides() {
    if (_previewItems.isEmpty) return const <Map<String, dynamic>>[];
    final overrides = <Map<String, dynamic>>[];
    for (final item in _previewItems) {
      if (_waitlistedOriginalDates.contains(item.date)) {
        overrides.add(<String, dynamic>{
          'original_date': item.date,
          'waiting_list': true,
          'date': item.date,
          'time': item.time,
        });
        continue;
      }
      final altBarberId = _alternativeBarberIdForPreviewItem(item);
      if (altBarberId != null) {
        overrides.add(<String, dynamic>{
          'original_date': item.date,
          'barber_id': altBarberId,
          'date': item.date,
          'time': item.time,
        });
      }
    }
    return overrides;
  }

  /// Confirms the booking from the dialog.
  ///
  /// Branches by `_recurringEnabled`:
  /// - true  → POST `/appointments/recurring`
  /// - false → POST `/appointments`
  ///
  /// Loading + disabled-buttons state is driven by the controller's reactive
  /// [AppointmentController.isBooking].
  Future<void> _onConfirmBookingTap(BuildContext dialogContext) async {
    final l10n = AppLocalizations.of(context)!;

    // Validate selections / ids first so we don't fire a useless request.
    final shopIdStr = _selectedShopId;
    final serviceIdStr = _selectedServiceId;
    final barbers = _barberController.items;
    final barberIdStr =
        (barbers.isNotEmpty &&
            _selectedBarber >= 0 &&
            _selectedBarber < barbers.length)
        ? barbers[_selectedBarber].id
        : null;
    final shopId = int.tryParse(shopIdStr ?? '');
    final serviceId = int.tryParse(serviceIdStr ?? '');
    final barberId = int.tryParse(barberIdStr ?? '');

    if (shopId == null || serviceId == null || barberId == null) {
      _showErrorMessage(l10n.bookingGenericError);
      return;
    }

    final time = _selectedSlotTime ?? '';
    if (time.isEmpty) {
      _showErrorMessage(l10n.selectTimeRequired);
      return;
    }

    // Capture context-bound objects BEFORE awaiting so we don't trip the
    // use_build_context_synchronously lint, and so the dialog's Navigator
    // is still valid even if its element later unmounts.
    final dialogNavigator = Navigator.of(dialogContext);
    final controller = Get.find<AppointmentController>();

    if (_recurringEnabled) {
      // ── Recurring path ──────────────────────────────────────────────────
      // Validate recurring-specific selections.
      if (_recurringIndex < 0 || _howManyBookings < 1) {
        _showErrorMessage(l10n.recurringMissingSelection);
        return;
      }
      if (_hasUnresolvedAlternativeBarberSelections()) {
        _showErrorMessage(l10n.recurringAlternativeBarberRequired);
        return;
      }

      final outcome = await controller.bookRecurring(
        shopId: shopId,
        barberId: barberId,
        serviceId: serviceId,
        date: _formatApiDate(_selectedDate),
        time: time,
        repeatType: _mapRecurringRepeatType(_recurringIndex),
        repeatValue: _howManyBookings,
        repeatInterval: _recurringIndex + 1,
        notes: null,
        overrides: _buildRecurringOverrides(),
      );

      if (!mounted) return;

      if (outcome.success) {
        // Close dialog and refresh reservations in the background.
        if (dialogNavigator.canPop()) dialogNavigator.pop();

        final result = outcome.result;
        final bookedCount = result?.booked.length ?? 0;
        final skippedCount = result?.skipped.length ?? 0;

        String message;
        if (bookedCount == 0 && skippedCount > 0) {
          // API succeeded but no slot could be booked.
          message = l10n.recurringAllSkipped(skippedCount);
        } else if (skippedCount > 0) {
          // Partial success: some booked, some skipped.
          message = l10n.recurringPartialSuccess(bookedCount, skippedCount);
        } else if (outcome.message.isNotEmpty) {
          message = outcome.message;
        } else {
          message = l10n.recurringSuccess;
        }
        _showPageMessage(message);

        await _syncAppointmentsAfterBooking();

        if (Get.previousRoute.isNotEmpty) {
          Get.back();
        } else {
          Get.offAllNamed(AppRoutes.home);
        }
        return;
      }

      // Recurring failure: keep dialog open, show error.
      final errMsg = outcome.isNetworkError
          ? l10n.bookingGenericError
          : (outcome.message.isNotEmpty
                ? outcome.message
                : l10n.bookingGenericError);
      _showErrorMessage(errMsg);
      return;
    }

    // ── Single-appointment path ───────────────────────────────────────────
    final outcome = await controller.bookSingle(
      shopId: shopId,
      barberId: barberId,
      serviceId: serviceId,
      date: _formatApiDate(_selectedDate),
      time: time,
      notes: 'First appointment',
    );

    if (!mounted) return;

    if (outcome.success) {
      if (dialogNavigator.canPop()) dialogNavigator.pop();
      final successMsg = outcome.message.isNotEmpty
          ? outcome.message
          : l10n.bookingSuccess;
      _showPageMessage(successMsg);
      await _syncAppointmentsAfterBooking();
      if (Get.previousRoute.isNotEmpty) {
        Get.back();
      } else {
        Get.offAllNamed(AppRoutes.home);
      }
      return;
    }

    final errMsg = outcome.isNetworkError
        ? l10n.bookingGenericError
        : (outcome.message.isNotEmpty
              ? outcome.message
              : l10n.bookingGenericError);
    _showErrorMessage(errMsg);
  }

  /// Step 4 entry after a specific barber is chosen (grid tap or random).
  Future<void> _enterStep4WithBarber(int barberIndex) async {
    if (_barberController.items.isEmpty) {
      _showPageMessage('No barbers available');
      return;
    }
    final index = barberIndex.clamp(0, _barberController.items.length - 1);

    setState(() {
      _selectedBarber = index;
      _step = 4;
      _selectedTime = -1;
      _selectedDate = _today();
      _alignSelectedDateToNextWorkingDay();
      _recurringEnabled = false;
      _recurringIndex = -1;
      _howManyBookings = 0;
      _slots = const <AvailabilitySlot>[];
      _slotsErrorMessage = '';
      _isLoadingSlots = true;
      _previewItems = const <RecurringPreviewDateItem>[];
      _waitlistedOriginalDates.clear();
      _selectedAlternativeBarberByDate.clear();
      _previewErrorMessage = '';
      _isLoadingPreview = false;
      _shopHolidays = const <ShopHoliday>[];
      _barberVacations = const <VacationPeriod>[];
      _shopVacations = const <VacationPeriod>[];
    });
    await _loadBarbersForSelection(forceNetwork: true);
    await _loadScheduleConstraints();
    if (!mounted) return;
    setState(_alignSelectedDateToNextWorkingDay);
    await _loadSlotsForSelection(showLoading: false);
    await _selectNextDateWithAvailableSlots();
    _scheduleStep4WorkingDayAlignment();
  }

  /// "Someone available" — pick a random barber from the loaded list, then step 4.
  Future<void> _onSomeoneAvailableTap() async {
    final items = _barberController.items;
    if (items.isEmpty) {
      _showPageMessage('No barbers available');
      return;
    }
    final index = Random().nextInt(items.length);
    await _enterStep4WithBarber(index);
  }

  Future<void> _onContinue() async {
    if (_step == 1) {
      if (_shopController.items.isEmpty) {
        _showPageMessage('No shops available right now');
        return;
      }
      await _loadServicesForSelectedShop();
      if (_serviceController.items.isEmpty) {
        _showPageMessage('No services available for this shop');
        return;
      }
      setState(() {
        _step = 2;
        _selectedService = 0;
      });
      return;
    }
    if (_step == 2) {
      if (_serviceController.items.isEmpty) {
        _showPageMessage('No services available');
        return;
      }
      await _loadBarbersForSelection();
      if (_barberController.items.isEmpty) {
        _showPageMessage('No barbers available for selected service');
        return;
      }
      setState(() {
        _step = 3;
        _selectedBarber = -1;
      });
      return;
    }
    if (_step == 3) {
      await _onSomeoneAvailableTap();
      return;
    }
    if (_step == 4) {
      final l10n = AppLocalizations.of(context)!;

      if (!_hasBarberWorkingSchedule) {
        _showPageMessage(l10n.noBarberWorkingDays);
        return;
      }

      if (!_isBarberWorkingDay(_selectedDate)) {
        _showPageMessage(l10n.noBarberWorkingDays);
        return;
      }

      if (_isLoadingSlots) {
        _showPageMessage(l10n.slotsStillLoading);
        return;
      }

      if (_recurringEnabled) {
        final missingInterval = _recurringIndex < 0;
        final missingQuantity = _howManyBookings < 1;
        if (missingInterval && missingQuantity) {
          _showErrorMessage(l10n.recurringMissingSelection);
          return;
        }
        if (missingInterval) {
          _showErrorMessage(l10n.recurringIntervalRequired);
          return;
        }
        if (missingQuantity) {
          _showErrorMessage(l10n.recurringQuantityRequired);
          return;
        }
        if (_hasUnresolvedAlternativeBarberSelections()) {
          _showErrorMessage(l10n.recurringAlternativeBarberRequired);
          return;
        }
      }

      if (!_hasAvailableSlots) {
        _showPageMessage(l10n.noSlotsAvailableForSelectedDate);
        return;
      }

      if (_selectedSlotTime == null) {
        _showPageMessage(l10n.selectTimeRequired);
        return;
      }

      await _refreshStep4ScheduleData();
      if (!mounted || _step != 4) return;
      setState(() => _step = 5);
      return;
    }
    // Next steps can be implemented later.
  }

  Future<void> _onBack() async {
    if (_step <= 1) return;
    final returningToStep4 = _step == 5;
    setState(() {
      if (_step == 4) {
        _pendingStep4WorkingDayAlign = false;
        _selectedBarber = -1;
      }
      _step -= 1;
    });
    if (returningToStep4 && mounted && _step == 4) {
      await _refreshStep4ScheduleData();
    }
  }

  String _monthLabel(DateTime date, Locale locale) {
    const itMonths = [
      'Gennaio',
      'Febbraio',
      'Marzo',
      'Aprile',
      'Maggio',
      'Giugno',
      'Luglio',
      'Agosto',
      'Settembre',
      'Ottobre',
      'Novembre',
      'Dicembre',
    ];
    const enMonths = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final months = locale.languageCode == 'it' ? itMonths : enMonths;
    final m = months[(date.month - 1).clamp(0, 11)];
    return '$m ${date.year}';
  }

  String _weekdayName(DateTime date, Locale locale) {
    const itDays = [
      'lunedì',
      'martedì',
      'mercoledì',
      'giovedì',
      'venerdì',
      'sabato',
      'domenica',
    ];
    const enDays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    final list = locale.languageCode == 'it' ? itDays : enDays;
    return list[(date.weekday - 1).clamp(0, 6)];
  }

  void _syncRecurringDates() {
    // Recurring dates are now provided by the preview API.
  }

  Future<void> _confirmRemoveRecurringDateAt(int index) async {
    final confirmed = await showDeleteAppointmentConfirmDialog(context);
    if (confirmed != true || !mounted) return;
    _removeRecurringDateAt(index);
  }

  void _removeRecurringDateAt(int index) {
    if (index < 0 || index >= _previewItems.length) return;
    final removedDate = _previewItems[index].date;
    setState(() {
      _previewItems = List<RecurringPreviewDateItem>.from(_previewItems)
        ..removeAt(index);
      _waitlistedOriginalDates.remove(removedDate);
      _selectedAlternativeBarberByDate.remove(removedDate);
      _howManyBookings = _previewItems.length;
      if (_howManyBookings == 0) {
        _recurringIndex = -1;
      }
    });
  }

  void _toggleWaitlistForDate(String originalDate, bool value) {
    setState(() {
      if (value) {
        _waitlistedOriginalDates.add(originalDate);
      } else {
        _waitlistedOriginalDates.remove(originalDate);
      }
    });
  }

  void _pruneAlternativeBarberSelections() {
    final dates = _previewItems.map((e) => e.date).toSet();
    _selectedAlternativeBarberByDate.removeWhere((date, barberId) {
      if (!dates.contains(date)) return true;
      final item = _previewItems.firstWhere((e) => e.date == date);
      return !item.alternativeBarbers.any((a) => a.id == barberId);
    });
    for (final item in _previewItems) {
      if (item.isAvailable || item.alternativeBarbers.length != 1) continue;
      _selectedAlternativeBarberByDate[item.date] =
          item.alternativeBarbers.first.id;
    }
  }

  void _onSelectAlternativeBarberForDate(String date, int barberId) {
    setState(() {
      _selectedAlternativeBarberByDate[date] = barberId;
    });
  }

  // e.g. "Gio, Aprile 09" (IT) or "Thu, April 09" (EN)
  String _shortDateLabel(DateTime date, Locale locale) {
    const itDaysShort = ['Lun', 'Mar', 'Mer', 'Gio', 'Ven', 'Sab', 'Dom'];
    const enDaysShort = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const itMonths = [
      'Gennaio',
      'Febbraio',
      'Marzo',
      'Aprile',
      'Maggio',
      'Giugno',
      'Luglio',
      'Agosto',
      'Settembre',
      'Ottobre',
      'Novembre',
      'Dicembre',
    ];
    const enMonths = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final isIt = locale.languageCode == 'it';
    final dow = (isIt ? itDaysShort : enDaysShort)[(date.weekday - 1).clamp(0, 6)];
    final mon = (isIt ? itMonths : enMonths)[(date.month - 1).clamp(0, 11)];
    final day = date.day.toString().padLeft(2, '0');
    return '$dow, $mon $day';
  }

  /// First selectable working day for the picker, or [fallback] if none found.
  DateTime _initialDateForPicker({required DateTime fallback}) {
    if (_isBarberWorkingDay(_selectedDate)) return _selectedDate;
    for (int offset = 0; offset < 370; offset++) {
      final candidate = _today().add(Duration(days: offset));
      if (_isBarberWorkingDay(candidate)) return candidate;
    }
    return fallback;
  }

  /// Opens the month calendar. The header icon is always tappable; only working
  /// weekdays are selectable inside the dialog.
  Future<void> _pickStep3Date() async {
    final initial = _initialDateForPicker(fallback: _selectedDate);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020, 1, 1),
      lastDate: DateTime(2035, 12, 31),
      selectableDayPredicate: (d) => _isBarberWorkingDay(d),
      builder: (context, child) {
        final base = Theme.of(context);
        const surface = Color(0xFF242424);
        const onSurface = Color(0xFFEDEDED);
        const primary = Color(0xFF185C5C);
        const onPrimary = Color(0xFFEDEDED);
        const divider = Color(0xFF3A3A3A);

        final scheme = base.colorScheme.copyWith(
          brightness: Brightness.dark,
          primary: primary,
          onPrimary: onPrimary,
          secondary: primary,
          onSecondary: onPrimary,
          surface: surface,
          onSurface: onSurface,
        );
        return Theme(
          data: ThemeData(
            brightness: Brightness.dark,
            useMaterial3: true,
            colorScheme: scheme,
            dialogTheme: const DialogThemeData(
              backgroundColor: surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(22)),
              ),
            ),
            dividerColor: divider,
            datePickerTheme: DatePickerThemeData(
              backgroundColor: surface,
              dividerColor: divider,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(22)),
              ),
              headerBackgroundColor: surface,
              headerForegroundColor: onSurface,
              weekdayStyle: const TextStyle(
                color: Color(0xFFBDBDBD),
                fontWeight: FontWeight.w700,
              ),
              dayStyle: const TextStyle(
                color: onSurface,
                fontWeight: FontWeight.w700,
              ),
              todayForegroundColor: const WidgetStatePropertyAll(onSurface),
              todayBorder: const BorderSide(color: primary, width: 1),
              dayForegroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.disabled)) {
                  return const Color(0xFF6C6C6C);
                }
                return onSurface;
              }),
              dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) return primary;
                return Colors.transparent;
              }),
              yearForegroundColor: const WidgetStatePropertyAll(onSurface),
              yearBackgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) return primary;
                return Colors.transparent;
              }),
              rangePickerBackgroundColor: surface,
              rangePickerHeaderBackgroundColor: surface,
              rangePickerHeaderForegroundColor: onSurface,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                disabledForegroundColor: Colors.white.withValues(alpha: 0.38),
                textStyle: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            textTheme: GoogleFonts.interTextTheme(
              base.textTheme,
            ).apply(bodyColor: onSurface, displayColor: onSurface),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (picked == null || !_isBarberWorkingDay(picked)) return;
    setState(() {
      _selectedDate = picked;
      _syncRecurringDates();
    });
    if (_step == 4) {
      await _loadSlotsForSelection();
      await _loadRecurringPreview();
    }
  }

  Future<void> _showConfirmDialog() async {
    await showGeneralDialog<void>(
      context: context,
      // While booking is in progress, prevent dismissing by tapping outside.
      barrierDismissible: false,
      barrierLabel: 'confirm',
      barrierColor: Colors.black.withValues(alpha: 0.55),
      pageBuilder: (context, anim1, anim2) => const SizedBox.shrink(),
      transitionDuration: const Duration(milliseconds: 180),
      transitionBuilder: (context, anim, anim2, child) {
        final curve = Curves.easeOutCubic.transform(anim.value);
        return Transform.scale(
          scale: 0.96 + (0.04 * curve),
          child: Opacity(
            opacity: curve,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 680),
                  child: Material(
                    color: const Color(0xFF242424),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: const Color(0xFF185C5C),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 4,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: 18,
                            top: 18,
                            child: Obx(() {
                              final busy = Get.isRegistered<AppointmentController>()
                                  ? Get.find<AppointmentController>().isBooking.value
                                  : false;
                              return InkWell(
                                onTap: busy
                                    ? null
                                    : () => Navigator.of(context).pop(),
                                borderRadius: BorderRadius.circular(18),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Icon(
                                    Icons.close_rounded,
                                    color: busy
                                        ? const Color(0xFF555555)
                                        : const Color(0xFF797979),
                                    size: 32,
                                  ),
                                ),
                              );
                            }),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(26, 30, 26, 26),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 10),
                                SvgPicture.asset(
                                  'assets/icons/shield.svg',
                                  width: 70,
                                ),
                                const SizedBox(height: 22),
                                Text(
                                  AppLocalizations.of(context)!.areYouSure,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFFDDDDDD),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.actionCannotBeUndone,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFFDDDDDD),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 30),
                                Obx(() {
                                  final controller =
                                      Get.find<AppointmentController>();
                                  final busy = controller.isBooking.value;
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          height: 54,
                                          child: OutlinedButton(
                                            onPressed: busy
                                                ? null
                                                : () =>
                                                      Navigator.of(
                                                        context,
                                                      ).pop(),
                                            style: OutlinedButton.styleFrom(
                                              side: const BorderSide(
                                                color: Color(0xFF797979),
                                                width: 1,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              backgroundColor:
                                                  Colors.transparent,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 15.0,
                                                  ),
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  AppLocalizations.of(
                                                    context,
                                                  )!.cancelAction,
                                                  style: GoogleFonts.inter(
                                                    color: const Color(
                                                      0xFF797979,
                                                    ),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    height: 1.5,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 18),
                                      Expanded(
                                        child: SizedBox(
                                          height: 54,
                                          child: FilledButton(
                                            onPressed: busy
                                                ? null
                                                : () => _onConfirmBookingTap(
                                                    context,
                                                  ),
                                            style: FilledButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xFFEEEEEE,
                                              ),
                                              foregroundColor: const Color(
                                                0xFF242424,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              disabledBackgroundColor:
                                                  const Color(0xFFCFCFCF),
                                              disabledForegroundColor:
                                                  const Color(0xFF242424),
                                            ),
                                            child: busy
                                                ? const SizedBox(
                                                    width: 22,
                                                    height: 22,
                                                    child:
                                                        CircularProgressIndicator(
                                                          strokeWidth: 2.4,
                                                          valueColor:
                                                              AlwaysStoppedAnimation(
                                                                Color(
                                                                  0xFF242424,
                                                                ),
                                                              ),
                                                        ),
                                                  )
                                                : FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                      AppLocalizations.of(
                                                        context,
                                                      )!.confirmAction,
                                                      style: GoogleFonts.inter(
                                                        color: const Color(
                                                          0xFF242424,
                                                        ),
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        height: 1.5,
                                                      ),
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.paddingOf(context);
    final l10n = AppLocalizations.of(context)!;
    final isWide = MediaQuery.sizeOf(context).width >= 600;
    final scale = ResponsiveHelper.getResponsiveValue<double>(
      context,
      small: 1.0,
      medium: 1.12,
      large: 1.22,
    );
    final hPad = isWide ? 28.0 : 18.0;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(hPad, 14, hPad, 6),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: SvgPicture.asset('assets/icons/back_button.svg'),
                    color: Colors.white,
                    iconSize: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10n.bookAppointment,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 18 * scale,
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad + 4, vertical: 8),
              child: Row(
                children: List.generate(5, (i) {
                  final active = i < _step;
                  return Expanded(
                    child: Container(
                      height: 6,
                      margin: EdgeInsets.only(right: i == 4 ? 0 : 6),
                      decoration: BoxDecoration(
                        color: active
                            ? const Color(0xFFDDDDDD)
                            : const Color(0xFF242424),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(hPad + 4, 20, hPad + 4, 14),
              child: Row(
                children: [
                  Text(
                    _step == 1
                        ? l10n.stepChooseBarber
                        : _step == 2
                        ? l10n.stepSelectService
                        : _step == 3
                        ? l10n.stepSelectBarber
                        : _step == 4
                        ? l10n.stepChooseDate
                        : l10n.stepBookingSummary,
                    style: GoogleFonts.inter(
                      color: Color(0xFFEEEEEE),
                      fontSize: 16 * scale,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    l10n.phaseOf(_step, 5),
                    style: GoogleFonts.inter(
                      color: const Color(0xFFDDDDDD),
                      fontSize: 12 * scale,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeOut,
                layoutBuilder: (currentChild, previousChildren) {
                  return Stack(
                    alignment: Alignment.topCenter,
                    fit: StackFit.expand,
                    children: <Widget>[
                      ...previousChildren,
                      ...? (currentChild != null ? <Widget>[currentChild] : null),
                    ],
                  );
                },
                child: _step == 1
                    ? GetBuilder<ShopListController>(
                        id: 'shop-selection',
                        builder: (controller) {
                          if (controller.isLoading.value &&
                              controller.items.isEmpty) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFFEEEEEE),
                              ),
                            );
                          }
                          if (controller.errorMessage.value.isNotEmpty &&
                              controller.items.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: hPad),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      controller.errorMessage.value,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFFDDDDDD),
                                        fontSize: 14 * scale,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    FilledButton(
                                      onPressed: controller.loadItems,
                                      style: FilledButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFFEEEEEE,
                                        ),
                                        foregroundColor: const Color(
                                          0xFF000000,
                                        ),
                                      ),
                                      child: Text(l10n.retryLabel),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          return GridView.builder(
                            key: const ValueKey('shops'),
                            padding: EdgeInsets.fromLTRB(hPad, 20, hPad, 18),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      _appointmentGridCrossAxisCount(context),
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 16,
                                  childAspectRatio:
                                      _shopGridChildAspectRatio(context),
                                ),
                            itemCount: controller.items.length,
                            itemBuilder: (context, i) {
                              final item = controller.items[i];
                              final selected = i == controller.selectedIndex;
                              return _ShopCard(
                                item: item,
                                selected: selected,
                                onTap: () async {
                                  controller.selectShop(i);
                                  await _loadServicesForSelectedShop();
                                  setState(() {});
                                },
                              );
                            },
                          );
                        },
                      )
                    : _step == 2
                    ? GetBuilder<ServiceListController>(
                        id: 'service-selection',
                        builder: (controller) {
                          if (controller.isLoading.value &&
                              controller.items.isEmpty) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFFEEEEEE),
                              ),
                            );
                          }
                          if (controller.errorMessage.value.isNotEmpty &&
                              controller.items.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: hPad),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      controller.errorMessage.value,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFFDDDDDD),
                                        fontSize: 14 * scale,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    FilledButton(
                                      onPressed: _loadServicesForSelectedShop,
                                      style: FilledButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFFEEEEEE,
                                        ),
                                        foregroundColor: const Color(
                                          0xFF000000,
                                        ),
                                      ),
                                      child: Text(l10n.retryLabel),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return ListView.separated(
                            key: const ValueKey('services'),
                            padding: EdgeInsets.fromLTRB(
                              hPad + 2,
                              8,
                              hPad + 2,
                              18,
                            ),
                            itemCount: _items.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 16),
                            itemBuilder: (context, i) {
                              final item = _items[i];
                              final selected = i == _selectedService;
                              return _ServiceCard(
                                item: item,
                                selected: selected,
                                onTap: () =>
                                    setState(() => _selectedService = i),
                              );
                            },
                          );
                        },
                      )
                    : _step == 3
                    ? GetBuilder<BarberListController>(
                        id: 'barber-selection',
                        builder: (controller) {
                          if (controller.isLoading.value &&
                              controller.items.isEmpty) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFFEEEEEE),
                              ),
                            );
                          }
                          if (controller.errorMessage.value.isNotEmpty &&
                              controller.items.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: hPad),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      controller.errorMessage.value,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFFDDDDDD),
                                        fontSize: 14 * scale,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    FilledButton(
                                      onPressed: _loadBarbersForSelection,
                                      style: FilledButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFFEEEEEE,
                                        ),
                                        foregroundColor: const Color(
                                          0xFF000000,
                                        ),
                                      ),
                                      child: Text(l10n.retryLabel),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          if (controller.items.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: hPad),
                                child: Text(
                                  'No barber found for this service.',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFFDDDDDD),
                                    fontSize: 14 * scale,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          }
                          return GridView.builder(
                            key: const ValueKey('barbers'),
                            padding: EdgeInsets.fromLTRB(hPad, 0, hPad, 18),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      _appointmentGridCrossAxisCount(context),
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 16,
                                  childAspectRatio:
                                      _barberGridChildAspectRatio(context),
                                ),
                            itemCount: _barbers.length,
                            itemBuilder: (context, i) {
                              final item = _barbers[i];
                              final selected = i == _selectedBarber;
                              return _BarberCard(
                                item: item,
                                selected: selected,
                                onTap: () => _enterStep4WithBarber(i),
                              );
                            },
                          );
                        },
                      )
                    : _step == 4
                    ? GetBuilder<BarberListController>(
                        id: 'barber-selection',
                        builder: (_) {
                          _scheduleStep4WorkingDayAlignment();
                          return SingleChildScrollView(
                        key: const ValueKey('step4'),
                        padding: EdgeInsets.fromLTRB(hPad, 16, hPad, 18),
                        child: Builder(
                          builder: (context) {
                            final isLarge = ResponsiveHelper.isLargeDevice(
                              context,
                            );

                            final calendar = _Step3CalendarCard(
                              monthLabel: _monthLabel(
                                _selectedDate,
                                Localizations.localeOf(context),
                              ),
                              selectedDate: _selectedDate,
                              isPillDayEnabled: _isBarberWorkingDay,
                              isSlotSelectable: _isSlotSelectable,
                              onSelectDate: (d) async {
                                if (!_isBarberWorkingDay(d)) return;
                                setState(() {
                                  _selectedDate = d;
                                  _syncRecurringDates();
                                });
                                await _loadSlotsForSelection();
                                await _loadRecurringPreview();
                              },
                              selectedTimeIndex: _selectedTime,
                              slots: _slots,
                              isLoadingSlots: _isLoadingSlots,
                              slotsErrorMessage: _slotsErrorMessage,
                              onRetrySlots: _loadSlotsForSelection,
                              onSelectTime: (i) async {
                                if (i < 0 ||
                                    i >= _slots.length ||
                                    !_isSlotSelectable(_slots[i])) {
                                  return;
                                }
                                setState(() {
                                  _selectedTime = i;
                                  _syncRecurringDates();
                                });
                                await _loadRecurringPreview();
                              },
                              onTapCalendar: _pickStep3Date,
                            );

                            final right = Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _Step3RecurringToggle(
                                  value: _recurringEnabled,
                                  onChanged: (v) async {
                                    setState(() {
                                      _recurringEnabled = v;
                                      if (!v) {
                                        _recurringIndex = -1;
                                        _howManyBookings = 0;
                                        _previewItems =
                                            const <RecurringPreviewDateItem>[];
                                      }
                                      _syncRecurringDates();
                                    });
                                    await _loadRecurringPreview();
                                  },
                                ),
                                if (_recurringEnabled) ...[
                                  const SizedBox(height: 15),
                                  _Step3RecurringOptions(
                                    options: [
                                      l10n.everyWeekday(
                                        _weekdayName(
                                          _selectedDate,
                                          Localizations.localeOf(context),
                                        ),
                                      ),
                                      l10n.every2Weeks,
                                      l10n.every3Weeks,
                                      l10n.every4Weeks,
                                    ],
                                    selectedIndex: _recurringIndex,
                                    onSelect: (i) async {
                                      setState(() {
                                        _recurringIndex = i;
                                        _syncRecurringDates();
                                      });
                                      await _loadRecurringPreview();
                                    },
                                  ),
                                  if (_recurringIndex >= 0 &&
                                      _howManyBookings >= 1) ...[
                                    const SizedBox(height: 15),
                                    _RecurringPreviewSummary(
                                      intervalLabel: [
                                        l10n.everyWeekday(
                                          _weekdayName(
                                            _selectedDate,
                                            Localizations.localeOf(context),
                                          ),
                                        ),
                                        l10n.every2Weeks,
                                        l10n.every3Weeks,
                                        l10n.every4Weeks,
                                      ][_recurringIndex.clamp(0, 3)],
                                      previewItems: _previewItems,
                                      isLoading: _isLoadingPreview,
                                      errorMessage: _previewErrorMessage,
                                      onRetry: _loadRecurringPreview,
                                      selectedBarberName: _selectedBarberName,
                                      onRemoveAt: _confirmRemoveRecurringDateAt,
                                      waitlistedOriginalDates:
                                          _waitlistedOriginalDates,
                                      alternativeBarberByDate:
                                          _selectedAlternativeBarberByDate,
                                      onToggleWaitlist: _toggleWaitlistForDate,
                                      onSelectAlternativeBarber:
                                          _onSelectAlternativeBarberForDate,
                                      decorateContainer: true,
                                    ),
                                  ],
                                  const SizedBox(height: 15),
                                  _Step4HowManyDropdown(
                                    selectedCount: _howManyBookings,
                                    onSelect: (n) async {
                                      setState(() {
                                        _howManyBookings = n;
                                        _syncRecurringDates();
                                      });
                                      await _loadRecurringPreview();
                                    },
                                  ),
                                ],
                              ],
                            );

                            if (!isLarge) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  calendar,
                                  const SizedBox(height: 20),
                                  right,
                                ],
                              );
                            }

                            return Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 1100,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(flex: 5, child: calendar),
                                    const SizedBox(width: 18),
                                    Expanded(flex: 6, child: right),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                        },
                      )
                    : SingleChildScrollView(
                        key: const ValueKey('step5'),
                        padding: EdgeInsets.fromLTRB(hPad, 20, hPad, 20),
                        child: Builder(
                          builder: (context) {
                            final isLarge = ResponsiveHelper.isLargeDevice(
                              context,
                            );
                            final locale = Localizations.localeOf(context);
                            final selectedService =
                                _items.isNotEmpty &&
                                    _selectedService >= 0 &&
                                    _selectedService < _items.length
                                ? _items[_selectedService]
                                : const _ServiceItem(
                                    title: 'Service',
                                    minutes: 0,
                                    priceEuro: 0,
                                  );
                            final selectedBarber =
                                _barbers.isNotEmpty &&
                                    _selectedBarber >= 0 &&
                                    _selectedBarber < _barbers.length
                                ? _barbers[_selectedBarber]
                                : const _BarberItem(
                                    name: 'Barber',
                                    subtitle: '',
                                    imageAsset: 'assets/images/barbar_1.jpg',
                                  );
                            final intervalLabels = [
                              l10n.everyWeekday(
                                _weekdayName(_selectedDate, locale),
                              ),
                              l10n.every2Weeks,
                              l10n.every3Weeks,
                              l10n.every4Weeks,
                            ];
                            final intervalLabel =
                                _recurringIndex >= 0 && _recurringIndex < 4
                                    ? intervalLabels[_recurringIndex]
                                    : intervalLabels[0];
                            final bookings = _recurringEnabled
                                ? (_previewItems.isNotEmpty
                                      ? _previewItems.length
                                      : (_howManyBookings >= 1 ? _howManyBookings : 1))
                                : 1;
                            final card = _Step4SummaryCard(
                              service: selectedService,
                              barber: selectedBarber,
                              time: _selectedSlotTime ?? '',
                              dateLabel: _shortDateLabel(_selectedDate, locale),
                              recurringEnabled: _recurringEnabled,
                              intervalLabel: intervalLabel,
                              bookingsCount: bookings,
                              selectedBarberName: _selectedBarberName,
                              previewItems: _previewItems,
                              previewErrorMessage: _previewErrorMessage,
                              isLoadingPreview: _isLoadingPreview,
                              onRetryPreview: _loadRecurringPreview,
                              onRemoveRecurringAt: _confirmRemoveRecurringDateAt,
                              alternativeBarberByDate:
                                  _selectedAlternativeBarberByDate,
                              waitlistedOriginalDates: _waitlistedOriginalDates,
                              onToggleWaitlist: _toggleWaitlistForDate,
                              onSelectAlternativeBarber:
                                  _onSelectAlternativeBarberForDate,
                            );
                            if (!isLarge) return card;
                            return Align(
                              alignment: Alignment.topCenter,
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 980,
                                ),
                                child: card,
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(hPad, 6, hPad, 10 + pad.bottom),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: ResponsiveHelper.getResponsiveValue<double>(
                      context,
                      small: double.infinity,
                      large: 560,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: const Color(0xFF242424),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(32),
                              onTap: _step == 5
                                  ? _showConfirmDialog
                                  : _step == 3
                                  ? _onSomeoneAvailableTap
                                  : _onContinue,
                              child: Center(
                                child: Text(
                                  _step == 3
                                      ? l10n.someoneAvailable
                                      : _step == 5
                                      ? l10n.confirmBooking
                                      : l10n.continueLabel,
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 16 * scale,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (_step > 1) ...[
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton(
                            onPressed: _onBack,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF5A5A5A)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            child: Text(
                              'Back',
                              style: GoogleFonts.inter(
                                color: const Color(0xFFE5E5E5),
                                fontSize: 15 * scale,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Step4SummaryCard extends StatelessWidget {
  const _Step4SummaryCard({
    required this.service,
    required this.barber,
    required this.time,
    required this.dateLabel,
    required this.recurringEnabled,
    required this.intervalLabel,
    required this.bookingsCount,
    required this.selectedBarberName,
    required this.previewItems,
    required this.previewErrorMessage,
    required this.isLoadingPreview,
    required this.onRetryPreview,
    required this.onRemoveRecurringAt,
    this.alternativeBarberByDate = const <String, int>{},
    this.waitlistedOriginalDates = const <String>{},
    this.onToggleWaitlist,
    this.onSelectAlternativeBarber,
  });

  final _ServiceItem service;
  final _BarberItem barber;
  final String time;
  final String dateLabel;
  final bool recurringEnabled;
  final String intervalLabel;
  final int bookingsCount;
  final String selectedBarberName;
  final List<RecurringPreviewDateItem> previewItems;
  final String previewErrorMessage;
  final bool isLoadingPreview;
  final Future<void> Function() onRetryPreview;
  final ValueChanged<int> onRemoveRecurringAt;
  final Map<String, int> alternativeBarberByDate;
  final Set<String> waitlistedOriginalDates;
  final void Function(String originalDate, bool value)? onToggleWaitlist;
  final void Function(String date, int barberId)? onSelectAlternativeBarber;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final totalPrice = recurringEnabled
        ? service.priceEuro * bookingsCount
        : service.priceEuro;
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 25, 30, 25),
      decoration: BoxDecoration(
        color: const Color(0xFF242424),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFF185C5C)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 4,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Step4KeyValueRow(label: l10n.service, value: service.title),
          const SizedBox(height: 14),
          _Step4KeyValueRow(label: l10n.barber, value: barber.name),
          const SizedBox(height: 14),
          _Step4KeyValueRow(label: l10n.date, value: dateLabel),
          const SizedBox(height: 14),
          _Step4KeyValueRow(label: l10n.time, value: time),
          const SizedBox(height: 18),
          if (recurringEnabled) ...[
            const _Step4Divider(),
            const SizedBox(height: 20),
            _RecurringPreviewSummary(
              intervalLabel: intervalLabel,
              previewItems: previewItems,
              isLoading: isLoadingPreview,
              errorMessage: previewErrorMessage,
              onRetry: onRetryPreview,
              selectedBarberName: selectedBarberName,
              onRemoveAt: onRemoveRecurringAt,
              waitlistedOriginalDates: waitlistedOriginalDates,
              alternativeBarberByDate: alternativeBarberByDate,
              onToggleWaitlist: onToggleWaitlist,
              onSelectAlternativeBarber: onSelectAlternativeBarber,
              decorateContainer: false,
            ),
            const SizedBox(height: 25),
            const _Step4Divider(),
            const SizedBox(height: 20),
            _Step4ReservationTime(count: bookingsCount),
            const _Step4Divider(),
            const SizedBox(height: 20),
          ],
          Row(
            children: [
              Text(
                l10n.total,
                style: GoogleFonts.inter(
                  color: const Color(0xFFFFFFFF),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  height: 1.5,
                ),
              ),
              const Spacer(),
              Text(
                '€$totalPrice',
                style: GoogleFonts.inter(
                  color: const Color(0xFFFFFFFF),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Step4ReservationTime extends StatelessWidget {
  const _Step4ReservationTime({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Text(
          l10n.howManyBookings,
          style: GoogleFonts.inter(
            color: const Color(0xFFDDDDDD),
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 1.5,
          ),
        ),
        const Spacer(),
        Text(
          l10n.nTimes(count),
          style: GoogleFonts.inter(
            color: const Color(0xFFFFFFFF),
            fontSize: 16,
            fontWeight: FontWeight.w700,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _Step4KeyValueRow extends StatelessWidget {
  const _Step4KeyValueRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: const Color(0xFFDDDDDD),
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 1.5,
          ),
        ),
        const Spacer(),
        Text(
          value,
          textAlign: TextAlign.right,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.inter(
            color: const Color(0xFFFFFFFF),
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _Step4Divider extends StatelessWidget {
  const _Step4Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: Color(0xFF797979).withValues(alpha: 0.30),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _ServiceItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg = selected ? const Color(0xFFFFFFFF) : const Color(0xFF242424);
    final title = selected ? const Color(0xFF000000) : Colors.white;
    final sub = selected ? const Color(0xFF242424) : const Color(0xFFDDDDDD);
    final price = selected ? const Color(0xFF000000) : Colors.white;
    final scale = ResponsiveHelper.getResponsiveValue<double>(
      context,
      small: 1.0,
      medium: 1.12,
      large: 1.20,
    );
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Color(0xFF242424)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 4,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: GoogleFonts.inter(
                      color: title,
                      fontSize: 15 * scale,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${item.minutes} minuti',
                    style: GoogleFonts.inter(
                      color: sub,
                      fontSize: 13 * scale,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '€${item.priceEuro}',
                  style: GoogleFonts.inter(
                    color: price,
                    fontSize: 16 * scale,
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                _SelectIcon(selected: selected),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectIcon extends StatelessWidget {
  const _SelectIcon({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    if (selected) {
      return SvgPicture.asset('assets/icons/checked.svg', width: 24);
    }
    return SvgPicture.asset('assets/icons/non_check.svg', width: 24);
  }
}

class _ShopCard extends StatelessWidget {
  const _ShopCard({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final Shop item;
  final bool selected;
  final VoidCallback onTap;

  static const _radius = 32.0;
  static const _unselectedBg = Color(0xFF262626);
  static const _unselectedPillBg = Color(0xFF3A3A3C);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final compact = isCompactScreen(context);
    final titleColor =
        selected ? const Color(0xFF000000) : const Color(0xFFFFFFFF);
    final addressColor =
        selected ? const Color(0xFF242424) : const Color(0xFFDDDDDD);
    final titleSize = compactOneStepSmallerFont(context, compact ? 14 : 16);
    final addressSize = compactOneStepSmallerFont(context, compact ? 11 : 12);
    final selectFontSize = compactOneStepSmallerFont(context, compact ? 13 : 14);
    final iconSize = compact ? 64.0 : 72.0;
    final cardPadding = compact ? 16.0 : 20.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final cellHeight = constraints.maxHeight;
        return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(_radius),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            height: cellHeight.isFinite ? cellHeight : null,
            width: constraints.maxWidth,
            padding: EdgeInsets.all(cardPadding),
            decoration: BoxDecoration(
              color: selected ? Colors.white : _unselectedBg,
              borderRadius: BorderRadius.circular(_radius),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/shop.png',
                  width: iconSize,
                  height: iconSize,
                  fit: BoxFit.contain,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: titleColor,
                        fontSize: titleSize,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: compact ? 6 : 8),
                    Text(
                      '${item.addressLine1}\n${item.addressLine2}',
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: addressColor,
                        fontSize: addressSize,
                        fontWeight: FontWeight.w500,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
                if (selected)
                  Container(
                    width: compact ? 40 : 44,
                    height: compact ? 40 : 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFD1D1D6),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/checked.svg',
                        width: compact ? 20 : 22,
                      ),
                    ),
                  )
                else
                  Container(
                    width: double.infinity,
                    height: compact ? 38 : 40,
                    decoration: BoxDecoration(
                      color: _unselectedPillBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      l10n.select,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF8E8E93),
                        fontSize: selectFontSize,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BarberCard extends StatelessWidget {
  const _BarberCard({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _BarberItem item;
  final bool selected;
  final VoidCallback onTap;

  static const _radius = 32.0;
  static const _unselectedBg = Color(0xFF262626);
  static const _unselectedPillBg = Color(0xFF3A3A3C);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final compact = isCompactScreen(context);
    final nameColor =
        selected ? const Color(0xFF000000) : const Color(0xFFFFFFFF);
    final subtitleColor =
        selected ? const Color(0xFF242424) : const Color(0xFFDDDDDD);
    final nameSize = compactOneStepSmallerFont(context, compact ? 14 : 16);
    final subtitleSize = compactOneStepSmallerFont(context, compact ? 11 : 12);
    final selectFontSize = compactOneStepSmallerFont(context, compact ? 13 : 14);
    final avatarSize = compact ? 72.0 : 80.0;
    final cardPadding = compact ? 16.0 : 20.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final cellHeight = constraints.maxHeight;
        return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(_radius),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            height: cellHeight.isFinite ? cellHeight : null,
            width: constraints.maxWidth,
            padding: EdgeInsets.all(cardPadding),
            decoration: BoxDecoration(
              color: selected ? Colors.white : _unselectedBg,
              borderRadius: BorderRadius.circular(_radius),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipOval(
                  child: Image.asset(
                    item.imageAsset,
                    width: avatarSize,
                    height: avatarSize,
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: nameColor,
                        fontSize: nameSize,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: compact ? 6 : 8),
                    Text(
                      item.subtitle,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: subtitleColor,
                        fontSize: subtitleSize,
                        fontWeight: FontWeight.w500,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
                if (selected)
                  Container(
                    width: compact ? 40 : 44,
                    height: compact ? 40 : 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFD1D1D6),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/checked.svg',
                        width: compact ? 20 : 22,
                      ),
                    ),
                  )
                else
                  Container(
                    width: double.infinity,
                    height: compact ? 38 : 40,
                    decoration: BoxDecoration(
                      color: _unselectedPillBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      l10n.select,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF8E8E93),
                        fontSize: selectFontSize,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ServiceItem {
  const _ServiceItem({
    required this.title,
    required this.minutes,
    required this.priceEuro,
  });

  final String title;
  final int minutes;
  final int priceEuro;
}

class _BarberItem {
  const _BarberItem({
    required this.name,
    required this.subtitle,
    required this.imageAsset,
  });

  final String name;
  final String subtitle;
  final String imageAsset;
}

class _Step3CalendarCard extends StatelessWidget {
  const _Step3CalendarCard({
    required this.monthLabel,
    required this.selectedDate,
    required this.isPillDayEnabled,
    required this.isSlotSelectable,
    required this.onSelectDate,
    required this.selectedTimeIndex,
    required this.slots,
    required this.isLoadingSlots,
    required this.slotsErrorMessage,
    required this.onRetrySlots,
    required this.onSelectTime,
    required this.onTapCalendar,
  });

  final String monthLabel;
  final DateTime selectedDate;
  /// Enables/disables the horizontal day pills only (not the calendar icon).
  final bool Function(DateTime date) isPillDayEnabled;
  final bool Function(AvailabilitySlot slot) isSlotSelectable;
  final ValueChanged<DateTime> onSelectDate;
  final int selectedTimeIndex;
  final List<AvailabilitySlot> slots;
  final bool isLoadingSlots;
  final String slotsErrorMessage;
  final Future<void> Function() onRetrySlots;
  final ValueChanged<int> onSelectTime;
  final VoidCallback onTapCalendar;

  static String _dayShort(DateTime date, Locale locale) {
    const itDays = ['Lun', 'Mar', 'Mer', 'Gio', 'Ven', 'Sab', 'Dom'];
    const enDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final list = locale.languageCode == 'it' ? itDays : enDays;
    return list[(date.weekday - 1).clamp(0, 6)];
  }

  // 7-day window around the selected date: 1 day before + selected + 5 after.
  static List<DateTime> _dayWindow(DateTime selected) {
    final base = DateTime(selected.year, selected.month, selected.day);
    final start = base.subtract(const Duration(days: 1));
    return List.generate(7, (i) => start.add(Duration(days: i)));
  }

  static bool _sameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        color: const Color(0xFF242424),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF185C5C)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 4,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                monthLabel,
                style: GoogleFonts.inter(
                  color: const Color(0xFFDDDDDD),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
              const Spacer(),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTapCalendar,
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: SvgPicture.asset(
                      'assets/icons/calendar.svg',
                      width: 24,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFFDDDDDD),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Builder(
              builder: (context) {
                final locale = Localizations.localeOf(context);
                final days = _dayWindow(selectedDate);
                return Row(
                  children: [
                    for (int i = 0; i < days.length; i++) ...[
                      if (i > 0) const SizedBox(width: 14),
                      Builder(
                        builder: (_) {
                          final d = days[i];
                          final isSelectable = isPillDayEnabled(d);
                          final isSelected = _sameDate(d, selectedDate);
                          return _DayChip(
                            day: _dayShort(d, locale),
                            date: d.day.toString().padLeft(2, '0'),
                            selected: isSelected,
                            emphasized: isSelectable,
                            onTap: (isSelectable && !isSelected)
                                ? () => onSelectDate(d)
                                : null,
                          );
                        },
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 25),
          Text(
            l10n.selectPreferredTime,
            style: GoogleFonts.inter(
              color: const Color(0xFFDDDDDD),
              fontSize: 15,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          if (isLoadingSlots)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 18),
              child: Center(
                child: CircularProgressIndicator(color: Color(0xFFEEEEEE)),
              ),
            )
          else if (slotsErrorMessage.isNotEmpty && slots.isEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  slotsErrorMessage,
                  style: GoogleFonts.inter(
                    color: const Color(0xFFDDDDDD),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: onRetrySlots,
                    child: Text(l10n.retryLabel),
                  ),
                ),
              ],
            )
          else if (slots.isEmpty)
            Text(
              l10n.noSlotsAvailableForSelectedDate,
              style: GoogleFonts.inter(
                color: const Color(0xFFDDDDDD),
                fontSize: 13,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: slots.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 2.35,
              ),
              itemBuilder: (context, i) {
                final isDisabled = !isSlotSelectable(slots[i]);
                final selected = i == selectedTimeIndex;
                final bg = isDisabled
                    ? Color(0xFF242424).withValues(alpha: 0.30)
                    : selected
                    ? const Color(0xFFFFFFFF)
                    : const Color(0xFF242424);
                final border = isDisabled
                    ? Color(0xFF797979).withValues(alpha: 0.30)
                    : selected
                    ? const Color(0xFFDDDDDD)
                    : const Color(0xFF797979);
                final text = isDisabled
                    ? Color(0xFFEEEEEE).withValues(alpha: 0.30)
                    : selected
                    ? const Color(0xFF242424)
                    : const Color(0xFFEEEEEE);
                return InkWell(
                  onTap: isDisabled ? null : () => onSelectTime(i),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: border),
                    ),
                    child: Center(
                      child: Text(
                        slots[i].time,
                        style: GoogleFonts.inter(
                          color: text,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({
    required this.day,
    required this.date,
    required this.selected,
    required this.emphasized,
    this.onTap,
  });

  final String day;
  final String date;
  final bool selected;
  final bool emphasized;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final dayColor = selected
        ? const Color(0xFFFFFFFF)
        : emphasized
        ? const Color(0xFFFFFFFF)
        : Color(0xFFEEEEEE).withValues(alpha: 0.30);
    final dateColor = selected
        ? const Color(0xFF242424)
        : emphasized
        ? const Color(0xFFDDDDDD)
        : Color(0xFFDDDDDD).withValues(alpha: 0.30);

    final gradient = selected || emphasized
        ? const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF797979), Color(0xFF302C2C)],
          )
        : LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF797979).withValues(alpha: 0.30),
              Color(0xFF302C2C).withValues(alpha: 0.30),
            ],
          );

    final card = Container(
      width: 42,
      height: 79,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF434141)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Text(
            day,
            style: GoogleFonts.inter(
              color: dayColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          if (selected)
            Container(
              width: 28,
              height: 30,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: const BoxDecoration(
                color: Color(0xFFFFFFFF),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  date,
                  style: GoogleFonts.inter(
                    color: dateColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                date,
                style: GoogleFonts.inter(
                  color: dateColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );

    if (onTap == null) return card;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: card,
      ),
    );
  }
}

class _Step3RecurringToggle extends StatelessWidget {
  const _Step3RecurringToggle({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return InkWell(
      onTap: () => onChanged(!value),
      child: Row(
        children: [
          value
              ? SvgPicture.asset('assets/icons/checked_box.svg', width: 24)
              : SvgPicture.asset('assets/icons/non_checked_box.svg', width: 24),
          const SizedBox(width: 10),
          Text(
            l10n.recurringAppointments,
            style: GoogleFonts.inter(
              color: const Color(0xFFFFFFFF),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _Step3RecurringOptions extends StatelessWidget {
  const _Step3RecurringOptions({
    required this.options,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF242424),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF185C5C), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 27, 20, 27),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.recurringIntervalTitle,
                    style: GoogleFonts.inter(
                      color: const Color(0xFFFFFFFF),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            ...List.generate(options.length * 2 - 1, (idx) {
              final isDivider = idx.isOdd;
              if (isDivider) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: const _Step3Divider(),
                );
              }
              final i = idx ~/ 2;
              final isSelected = i == selectedIndex;
              return InkWell(
                onTap: () => onSelect(i),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          options[i],
                          style: GoogleFonts.inter(
                            color: const Color(0xFFDDDDDD),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check_rounded,
                          color: Color(0xFFDDDDDD),
                          size: 20,
                        ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _RecurringPreviewSummary extends StatelessWidget {
  const _RecurringPreviewSummary({
    required this.intervalLabel,
    required this.previewItems,
    required this.isLoading,
    required this.errorMessage,
    required this.onRetry,
    required this.selectedBarberName,
    required this.waitlistedOriginalDates,
    this.alternativeBarberByDate = const <String, int>{},
    this.onRemoveAt,
    this.onToggleWaitlist,
    this.onSelectAlternativeBarber,
    this.decorateContainer = true,
  });

  final String intervalLabel;
  final List<RecurringPreviewDateItem> previewItems;
  final bool isLoading;
  final String errorMessage;
  final Future<void> Function() onRetry;
  final String selectedBarberName;
  final Set<String> waitlistedOriginalDates;
  final Map<String, int> alternativeBarberByDate;
  final ValueChanged<int>? onRemoveAt;
  final void Function(String originalDate, bool value)? onToggleWaitlist;
  final void Function(String date, int barberId)? onSelectAlternativeBarber;
  final bool decorateContainer;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            SvgPicture.asset('assets/icons/recurrence_icon.svg', width: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                intervalLabel,
                style: GoogleFonts.inter(
                  color: const Color(0xFFFFFFFF),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Center(
              child: CircularProgressIndicator(color: Color(0xFFEEEEEE)),
            ),
          )
        else if (errorMessage.isNotEmpty && previewItems.isEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                errorMessage,
                style: GoogleFonts.inter(
                  color: const Color(0xFFDDDDDD),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: onRetry,
                  child: Text(l10n.retryLabel),
                ),
              ),
            ],
          )
        else if (previewItems.isEmpty)
          Text(
            l10n.noSlotsAvailableForSelectedDate,
            style: GoogleFonts.inter(
              color: const Color(0xFFDDDDDD),
              fontSize: 13,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          )
        else
          for (int i = 0; i < previewItems.length; i++) ...[
            _RecurringPreviewRow(
              item: previewItems[i],
              selectedBarberName: selectedBarberName,
              isWaitlisted: waitlistedOriginalDates.contains(previewItems[i].date),
              selectedAlternativeBarberId:
                  alternativeBarberByDate[previewItems[i].date],
              onToggleWaitlist: onToggleWaitlist == null
                  ? null
                  : (value) => onToggleWaitlist!(previewItems[i].date, value),
              onSelectAlternativeBarber: onSelectAlternativeBarber == null
                  ? null
                  : (barberId) =>
                      onSelectAlternativeBarber!(previewItems[i].date, barberId),
              onRemove: onRemoveAt == null ? null : () => onRemoveAt!(i),
            ),
          ],
      ],
    );

    if (!decorateContainer) return content;
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 27, 30, 30),
      decoration: BoxDecoration(
        color: const Color(0xFF242424),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF185C5C)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 4,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: content,
    );
  }
}

class _RecurringPreviewRow extends StatelessWidget {
  const _RecurringPreviewRow({
    required this.item,
    required this.selectedBarberName,
    required this.isWaitlisted,
    this.selectedAlternativeBarberId,
    this.onToggleWaitlist,
    this.onSelectAlternativeBarber,
    this.onRemove,
  });

  final RecurringPreviewDateItem item;
  final String selectedBarberName;
  final bool isWaitlisted;
  final int? selectedAlternativeBarberId;
  final ValueChanged<bool>? onToggleWaitlist;
  final ValueChanged<int>? onSelectAlternativeBarber;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final languageCode = Localizations.localeOf(context).languageCode;
    final dateTimeLabel = item.dateTimeLabelFor(languageCode);
    final reasonLabel = item.reasonLabelFor(languageCode);
    final hasAlternatives = item.alternativeBarbers.isNotEmpty;
    final hasReason = reasonLabel.isNotEmpty;
    final nextSlot = item.nextAvailableSlot?.trim() ?? '';
    final nextDate = item.nextAvailableDate?.trim() ?? '';
    final canSelectAlternative =
        !item.isAvailable && hasAlternatives && onSelectAlternativeBarber != null;

    RecurringPreviewAlternativeBarber? selectedAlternative;
    if (selectedAlternativeBarberId != null) {
      for (final alt in item.alternativeBarbers) {
        if (alt.id == selectedAlternativeBarberId) {
          selectedAlternative = alt;
          break;
        }
      }
    }

    Widget statusWidget;
    if (item.isAvailable) {
      statusWidget = Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF797979).withValues(alpha: 0.20),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          l10n.withBarberLabel(selectedBarberName.trim()),
          style: GoogleFonts.inter(
            color: const Color(0xFFDDDDDD),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
        ),
      );
    } else if (selectedAlternative != null) {
      statusWidget = Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF797979).withValues(alpha: 0.20),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF185C5C), width: 1),
        ),
        child: Text(
          l10n.selectedAlternativeBarber(selectedAlternative.name.trim()),
          style: GoogleFonts.inter(
            color: const Color(0xFFDDDDDD),
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 1.5,
          ),
        ),
      );
    } else if (hasAlternatives) {
      statusWidget = Text(
        item.status,
        style: GoogleFonts.inter(
          color: const Color(0xFFDDDDDD),
          fontSize: 13,
          fontWeight: FontWeight.w500,
          height: 1.5,
        ),
      );
    } else {
      statusWidget = Text(
        item.status,
        style: GoogleFonts.inter(
          color: const Color(0xFFDDDDDD),
          fontSize: 13,
          fontWeight: FontWeight.w500,
          height: 1.5,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateTimeLabel,
                  style: GoogleFonts.inter(
                    color: const Color(0xFFDDDDDD),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                statusWidget,
                if (hasAlternatives &&
                    !item.isAvailable &&
                    canSelectAlternative) ...[
                  const SizedBox(height: 12),
                  Text(
                    l10n.alternativeBarbersTitle,
                    style: GoogleFonts.inter(
                      color: const Color(0xFFDDDDDD),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (item.alternativeBarbers.length == 1)
                    _AlternativeBarberChip(
                      name: item.alternativeBarbers.first.name.trim(),
                      selected:
                          selectedAlternativeBarberId ==
                              item.alternativeBarbers.first.id ||
                          selectedAlternative != null,
                      enabled: true,
                      onTap: () => onSelectAlternativeBarber!(
                        item.alternativeBarbers.first.id,
                      ),
                    )
                  else
                    _AlternativeBarberDropdown(
                      alternatives: item.alternativeBarbers,
                      selectedBarberId: selectedAlternativeBarberId,
                      enabled: true,
                      onSelect: onSelectAlternativeBarber!,
                    ),
                ],
                if (hasReason) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        size: 16,
                        color: Color(0xFFEF4444),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          reasonLabel,
                          style: GoogleFonts.inter(
                            color: const Color(0xFFEF4444),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                if (nextSlot.isNotEmpty || nextDate.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    [
                      if (nextSlot.isNotEmpty) '${l10n.nextSlotLabel}: $nextSlot',
                      if (nextDate.isNotEmpty) '${l10n.nextDateLabel}: $nextDate',
                    ].join(' • '),
                    style: GoogleFonts.inter(
                      color: const Color(0xFFBDBDBD),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                ],
                if (!item.isAvailable && onToggleWaitlist != null) ...[
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => onToggleWaitlist!(!isWaitlisted),
                    child: Row(
                      children: [
                        isWaitlisted
                            ? SvgPicture.asset('assets/icons/checked_box.svg', width: 20)
                            : SvgPicture.asset('assets/icons/non_checked_box.svg', width: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            l10n.waitlistMe,
                            style: GoogleFonts.inter(
                              color: const Color(0xFFDDDDDD),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: onRemove,
            borderRadius: BorderRadius.circular(12),
            child: Icon(
              Icons.close_rounded,
              size: 16,
              color: onRemove == null
                  ? const Color(0xFF797979)
                  : const Color(0xFFEDEDED),
            ),
          ),
        ],
      ),
    );
  }
}

class _AlternativeBarberChip extends StatelessWidget {
  const _AlternativeBarberChip({
    required this.name,
    required this.selected,
    required this.enabled,
    this.onTap,
  });

  final String name;
  final bool selected;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final border = selected
        ? const Color(0xFF185C5C)
        : const Color(0xFF797979).withValues(alpha: 0.5);
    final nameColor = selected
        ? const Color(0xFFDDDDDD)
        : enabled
        ? const Color(0xFFEEEEEE)
        : const Color(0xFFEEEEEE).withValues(alpha: 0.35);
    final bg = selected
        ? const Color(0xFF242424)
        : enabled
        ? const Color(0xFFEEEEEE)
        : const Color(0xFFEEEEEE).withValues(alpha: 0.35);

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              name.isNotEmpty ? name : '—',
              style: GoogleFonts.inter(
                color: nameColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
            if (!selected && enabled) ...[
              const SizedBox(width: 8),
              Text(
                l10n.select,
                style: GoogleFonts.inter(
                  color: const Color(0xFF797979),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AlternativeBarberDropdown extends StatelessWidget {
  const _AlternativeBarberDropdown({
    required this.alternatives,
    required this.selectedBarberId,
    required this.enabled,
    required this.onSelect,
  });

  final List<RecurringPreviewAlternativeBarber> alternatives;
  final int? selectedBarberId;
  final bool enabled;
  final ValueChanged<int> onSelect;

  Future<void> _open(BuildContext context) async {
    if (!enabled || alternatives.isEmpty) return;
    final l10n = AppLocalizations.of(context)!;
    final picked = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      barrierColor: Colors.black.withValues(alpha: 0.65),
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF242424),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFF185C5C), width: 2),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 10),
                  Center(
                    child: Container(
                      width: 46,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF).withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 6, 20, 14),
                    child: Text(
                      l10n.alternativeBarbersTitle,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.45,
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: alternatives.length,
                      separatorBuilder: (_, index) => const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: _Step3Divider(),
                      ),
                      itemBuilder: (_, i) {
                        final alt = alternatives[i];
                        final name = alt.name.trim();
                        final isSelected = selectedBarberId == alt.id;
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => Navigator.of(sheetContext).pop(alt.id),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      name.isNotEmpty ? name : '—',
                                      style: GoogleFonts.inter(
                                        color: isSelected
                                            ? const Color(0xFFDDDDDD)
                                            : const Color(0xFF797979),
                                        fontSize: 16,
                                        fontWeight: isSelected
                                            ? FontWeight.w700
                                            : FontWeight.w600,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                  if (isSelected)
                                    const Icon(
                                      Icons.check_rounded,
                                      color: Color(0xFF185C5C),
                                      size: 22,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        );
      },
    );
    if (picked != null) onSelect(picked);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    RecurringPreviewAlternativeBarber? selected;
    if (selectedBarberId != null) {
      for (final alt in alternatives) {
        if (alt.id == selectedBarberId) {
          selected = alt;
          break;
        }
      }
    }
    final hasSelection = selected != null;
    final label = hasSelection
        ? selected.name.trim()
        : l10n.selectAlternativeBarber;
    final labelColor = hasSelection
        ? const Color(0xFFDDDDDD)
        : const Color(0xFF797979);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? () => _open(context) : null,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF242424),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: hasSelection
                  ? const Color(0xFF185C5C)
                  : const Color(0xFF797979).withValues(alpha: 0.5),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label.isNotEmpty ? label : '—',
                  style: GoogleFonts.inter(
                    color: enabled
                        ? labelColor
                        : labelColor.withValues(alpha: 0.35),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: enabled
                    ? const Color(0xFF797979)
                    : const Color(0xFF797979).withValues(alpha: 0.35),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Step4HowManyDropdown extends StatelessWidget {
  const _Step4HowManyDropdown({
    required this.selectedCount,
    required this.onSelect,
  });

  final int selectedCount; // 0 means "no selection / placeholder"
  final ValueChanged<int> onSelect;

  static const int _maxOptions = 52;

  Future<void> _open(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final picked = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      barrierColor: Colors.black.withValues(alpha: 0.65),
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF242424),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: const Color(0xFF185C5C),
                  width: 2
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 10),
                  Center(
                    child: Container(
                      width: 46,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF).withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 6, 20, 14),
                    child: Text(
                      l10n.howManyBookings,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.55,
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: _maxOptions,
                      separatorBuilder: (_, index) => const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: _Step3Divider(),
                      ),
                      itemBuilder: (_, i) {
                        final count = i + 1;
                        final isSelected = count == selectedCount;
                        return InkWell(
                          onTap: () => Navigator.of(sheetContext).pop(count),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 18,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    l10n.nTimes(count),
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFFDDDDDD),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check_rounded,
                                    color: Color(0xFFDDDDDD),
                                    size: 20,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
    if (picked != null && picked >= 1 && picked <= _maxOptions) {
      onSelect(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasSelection = selectedCount >= 1 && selectedCount <= _maxOptions;
    final label = hasSelection ? l10n.nTimes(selectedCount) : l10n.howManyBookings;
    final labelColor =
        hasSelection ? const Color(0xFFDDDDDD) : const Color(0xFF797979);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _open(context),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
          decoration: BoxDecoration(
            color: const Color(0xFF242424),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF185C5C)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    color: labelColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF797979),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Step3Divider extends StatelessWidget {
  const _Step3Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: Color(0xFF797979).withValues(alpha: 0.30),
    );
  }
}
