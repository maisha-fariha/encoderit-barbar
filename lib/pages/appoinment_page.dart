import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gems_responsive/gems_responsive.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/appointment_controller.dart';
import '../controllers/barber_list_controller.dart';
import '../controllers/reservation_list_controller.dart';
import '../controllers/shop_list_controller.dart';
import '../controllers/service_list_controller.dart';
import '../gen/l10n/app_localizations.dart';
import '../models/appointment/appointment_model.dart';
import '../models/shop/shop_model.dart';
import '../routes/app_pages.dart';

class AppoinmentPage extends StatefulWidget {
  const AppoinmentPage({super.key});

  @override
  State<AppoinmentPage> createState() => _AppoinmentPageState();
}

class _AppoinmentPageState extends State<AppoinmentPage> {
  int _step = 1;
  int _selectedService = 0;
  int _selectedBarber = 0;
  int _selectedTime = 0;
  DateTime _selectedDate = _today();
  bool _recurringEnabled = true;
  int _recurringIndex = -1; // -1 = nothing selected; otherwise 0..3
  int _howManyBookings = 0; // 0 = nothing selected; otherwise 1..10

  static bool _isBlockedWeekday(DateTime d) =>
      d.weekday == DateTime.wednesday || d.weekday == DateTime.friday;

  static DateTime _today() {
    final n = DateTime.now();
    var d = DateTime(n.year, n.month, n.day);
    while (_isBlockedWeekday(d)) {
      d = d.add(const Duration(days: 1));
    }
    return d;
  }
  late final ShopListController _shopController;
  late final ServiceListController _serviceController;
  late final BarberListController _barberController;

  final _times = const <String>[
    '09:00',
    '09:30',
    '10:00',
    '10:30',
    '11:00',
    '11:30',
    '12:00',
    '12:30',
    '13:00',
    '13:30',
    '14:00',
    '14:30',
    '15:00',
    '15:30',
    '16:00',
    '16:30',
    '17:00',
    '17:30',
  ];

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
    _shopController.loadItems();
    _serviceController.items.clear();
    _barberController.items.clear();
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

  /// Best-effort alternate barber: the first barber other than the selected one.
  ///
  /// Returns an empty string when only one barber is available — callers should
  /// fall back to a "no barber available" UI in that case.
  String get _alternativeBarberName {
    final list = _barberController.items;
    if (list.length <= 1) return '';
    for (int i = 0; i < list.length; i++) {
      if (i == _selectedBarber) continue;
      final name = list[i].name.trim();
      if (name.isNotEmpty) return name;
    }
    return '';
  }

  Future<void> _loadServicesForSelectedShop() async {
    final shopId = _selectedShopId;
    if (shopId == null || shopId.isEmpty) return;
    await _serviceController.loadByShop(shopId);
    if (_selectedService >= _serviceController.items.length) {
      _selectedService = 0;
    }
    _barberController.items.clear();
    _selectedBarber = 0;
  }

  Future<void> _loadBarbersForSelection() async {
    final shopId = _selectedShopId;
    final serviceId = _selectedServiceId;
    if (shopId == null ||
        shopId.isEmpty ||
        serviceId == null ||
        serviceId.isEmpty) {
      return;
    }
    await _barberController.loadByShopAndService(
      shopId: shopId,
      serviceId: serviceId,
    );
    if (_selectedBarber >= _barberController.items.length) {
      _selectedBarber = 0;
    }
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

  /// Maps the UI's "recurring interval" selection to the API's repeat type.
  ///
  /// The backend currently only accepts `monthly` or `times` for
  /// `repeat.type` (it rejects `weekly`/`daily` with
  /// "The selected repeat.type is invalid"). Because none of the four UI
  /// options express a single-month cadence, we send `times` for all of them
  /// so the API just creates [_howManyBookings] appointments.
  ///
  /// If the backend gains support for `weekly`, return [RecurringRepeatType.weekly]
  /// for indices 0..2 and [RecurringRepeatType.monthly] for index 3.
  RecurringRepeatType _mapRecurringRepeatType(int recurringIndex) {
    return RecurringRepeatType.times;
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

    final time = (_times.isNotEmpty &&
            _selectedTime >= 0 &&
            _selectedTime < _times.length)
        ? _times[_selectedTime]
        : '';
    if (time.isEmpty) {
      _showErrorMessage(l10n.bookingGenericError);
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

      final outcome = await controller.bookRecurring(
        shopId: shopId,
        barberId: barberId,
        serviceId: serviceId,
        date: _formatApiDate(_selectedDate),
        time: time,
        repeatType: _mapRecurringRepeatType(_recurringIndex),
        repeatValue: _howManyBookings,
        notes: null,
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

        // Best-effort: refresh the reservation list so the new bookings show up.
        if (Get.isRegistered<ReservationListController>()) {
          // ignore: discarded_futures
          Get.find<ReservationListController>().loadItems();
        }

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
      if (Get.isRegistered<ReservationListController>()) {
        // ignore: discarded_futures
        Get.find<ReservationListController>().loadItems();
      }
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
        _selectedBarber = 0;
      });
      return;
    }
    if (_step == 3) {
      if (_barberController.items.isEmpty) {
        _showPageMessage('No barbers available');
        return;
      }
      setState(() {
        _step = 4;
        _selectedTime = 0;
        _selectedDate = _today();
        _recurringEnabled = true;
        _recurringIndex = -1;
        _howManyBookings = 0;
      });
      return;
    }
    if (_step == 4) {
      setState(() => _step = 5);
      return;
    }
    // Next steps can be implemented later.
  }

  void _onBack() {
    if (_step <= 1) return;
    setState(() => _step -= 1);
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

  static const List<int> _recurrenceIntervalDays = [7, 14, 21, 28];

  // e.g. "Giovedì 9 aprile 2026, ore 10:00" (IT)
  // or   "Thursday 9 April 2026, at 10:00" (EN)
  String _bookingDateTimeLabel(DateTime date, String time, Locale locale) {
    const itMonthsLower = [
      'gennaio',
      'febbraio',
      'marzo',
      'aprile',
      'maggio',
      'giugno',
      'luglio',
      'agosto',
      'settembre',
      'ottobre',
      'novembre',
      'dicembre',
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
    final weekday = _weekdayName(date, locale);
    final dow = weekday.isEmpty
        ? weekday
        : '${weekday[0].toUpperCase()}${weekday.substring(1)}';
    final mon = (isIt ? itMonthsLower : enMonths)[(date.month - 1).clamp(0, 11)];
    final connector = isIt ? 'ore' : 'at';
    return '$dow ${date.day} $mon ${date.year}, $connector $time';
  }

  List<String> _bookingDateTimeLabels(Locale locale) {
    if (_recurringIndex < 0 || _howManyBookings < 1) return const [];
    final intervalDays =
        _recurrenceIntervalDays[_recurringIndex.clamp(
          0,
          _recurrenceIntervalDays.length - 1,
        )];
    final time = _times.isNotEmpty
        ? _times[_selectedTime.clamp(0, _times.length - 1)]
        : '';
    final out = <String>[];
    for (int i = 0; i < _howManyBookings; i++) {
      final d = _selectedDate.add(Duration(days: intervalDays * i));
      out.add(_bookingDateTimeLabel(d, time, locale));
    }
    return out;
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

  Future<void> _pickStep3Date() async {
    final initial = _selectedDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020, 1, 1),
      lastDate: DateTime(2035, 12, 31),
      selectableDayPredicate: (d) => !_isBlockedWeekday(d),
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
              dayForegroundColor: const WidgetStatePropertyAll(onSurface),
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
                foregroundColor: primary,
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

    if (picked == null) return;
    setState(() => _selectedDate = picked);
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
                                      child: const Text('Retry'),
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
                                      ResponsiveHelper.getResponsiveValue<int>(
                                        context,
                                        small: 2,
                                        large: 3,
                                      ),
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 16,
                                  childAspectRatio:
                                      ResponsiveHelper.getResponsiveValue<
                                        double
                                      >(context, small: 0.66, large: 0.86),
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
                                      child: const Text('Retry'),
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
                                      child: const Text('Retry'),
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
                                      ResponsiveHelper.getResponsiveValue<int>(
                                        context,
                                        small: 2,
                                        large: 3,
                                      ),
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 16,
                                  childAspectRatio:
                                      ResponsiveHelper.getResponsiveValue<
                                        double
                                      >(context, small: 0.70, large: 0.88),
                                ),
                            itemCount: _barbers.length,
                            itemBuilder: (context, i) {
                              final item = _barbers[i];
                              final selected = i == _selectedBarber;
                              return _BarberCard(
                                item: item,
                                selected: selected,
                                onTap: () =>
                                    setState(() => _selectedBarber = i),
                              );
                            },
                          );
                        },
                      )
                    : _step == 4
                    ? SingleChildScrollView(
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
                              onSelectDate: (d) =>
                                  setState(() => _selectedDate = d),
                              selectedTimeIndex: _selectedTime,
                              times: _times,
                              onSelectTime: (i) =>
                                  setState(() => _selectedTime = i),
                              onTapCalendar: _pickStep3Date,
                            );

                            final right = Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _Step3RecurringToggle(
                                  value: _recurringEnabled,
                                  onChanged: (v) =>
                                      setState(() => _recurringEnabled = v),
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
                                    onSelect: (i) =>
                                        setState(() => _recurringIndex = i),
                                  ),
                                  if (_recurringIndex >= 0 &&
                                      _howManyBookings >= 1) ...[
                                    const SizedBox(height: 15),
                                    _Step3MonthlySummary(
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
                                      dateLabels: _bookingDateTimeLabels(
                                        Localizations.localeOf(context),
                                      ),
                                      selectedBarberName: _selectedBarberName,
                                      alternativeBarberName:
                                          _alternativeBarberName,
                                    ),
                                  ],
                                  const SizedBox(height: 15),
                                  _Step4HowManyDropdown(
                                    selectedCount: _howManyBookings,
                                    onSelect: (n) =>
                                        setState(() => _howManyBookings = n),
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
                            final bookings = _howManyBookings >= 1
                                ? _howManyBookings
                                : 1;
                            final card = _Step4SummaryCard(
                              service: selectedService,
                              barber: selectedBarber,
                              time: _times[_selectedTime],
                              dateLabel: _shortDateLabel(_selectedDate, locale),
                              recurringEnabled: _recurringEnabled,
                              intervalLabel: intervalLabel,
                              bookingsCount: bookings,
                            );
                            if (!isLarge) return card;
                            return Center(
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
                              onTap: _step == 5 ? _showConfirmDialog : _onContinue,
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
  });

  final _ServiceItem service;
  final _BarberItem barber;
  final String time;
  final String dateLabel;
  final bool recurringEnabled;
  final String intervalLabel;
  final int bookingsCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
            _Step4MonthlyRecurrence(intervalLabel: intervalLabel),
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
                '€${service.priceEuro}',
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

class _Step4MonthlyRecurrence extends StatefulWidget {
  const _Step4MonthlyRecurrence({required this.intervalLabel});

  final String intervalLabel;

  @override
  State<_Step4MonthlyRecurrence> createState() =>
      _Step4MonthlyRecurrenceState();
}

class _Step4MonthlyRecurrenceState extends State<_Step4MonthlyRecurrence> {
  bool _waitlist = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    Widget row(String text, {bool withPill = true}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: GoogleFonts.inter(
                      color: const Color(0xFFDDDDDD),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (withPill) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFF797979).withValues(alpha: 0.20),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        'con Marcus Silva',
                        style: GoogleFonts.inter(
                          color: const Color(0xFFDDDDDD),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(Icons.close_rounded, size: 16, color: Color(0xFF797979)),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            SvgPicture.asset('assets/icons/recurrence_icon.svg', width: 18),
            const SizedBox(width: 10),
            Text(
              widget.intervalLabel,
              style: GoogleFonts.inter(
                color: const Color(0xFFFFFFFF),
                fontSize: 16,
                fontWeight: FontWeight.w700,
                height: 1.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        row('Giovedì 9 aprile 2026, ore 10:00'),

        Column(
          children: [
            row('Giovedì 16 aprile 2026, ore 10:00', withPill: false),
            Padding(
              padding: const EdgeInsets.only(left: 2, right: 2, bottom: 6),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    size: 16,
                    color: Color(0xFFE24B4B),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.noBarberAvailable,
                    style: GoogleFonts.inter(
                      color: const Color(0xFFE24B4B),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () => setState(() => _waitlist = !_waitlist),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      _waitlist
                          ? 'assets/icons/checked_box.svg'
                          : 'assets/icons/non_checked_box.svg',
                      width: 20,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFFFFFFFF),
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      l10n.waitlistMe,
                      style: GoogleFonts.inter(
                        color: const Color(0xFFDDDDDD),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Giovedì 23 aprile 2026, ore 10:00',
                      style: GoogleFonts.inter(
                        color: const Color(0xFFDDDDDD),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFF797979).withValues(alpha: 0.20),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0xFFEF4444),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'Alternative Barber with James Martinez',
                        style: GoogleFonts.inter(
                          color: const Color(0xFFDDDDDD),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Icon(
                Icons.close_rounded,
                size: 16,
                color: Color(0xFF797979),
              ),
            ],
          ),
        ),
        row('Giovedì 30 aprile 2026, ore 10:00'),
      ],
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bg = selected ? const Color(0xFFFFFFFF) : const Color(0xFF242424);
    final title = selected ? const Color(0xFF000000) : const Color(0xFFFFFFFF);
    final sub = selected ? const Color(0xFF242424) : const Color(0xFFDDDDDD);
    final scale = ResponsiveHelper.getResponsiveValue<double>(
      context,
      small: 1.0,
      medium: 1.10,
      large: 1.18,
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Color(0xFF242424)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 4,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset('assets/images/shop.png', width: 60),
            const SizedBox(height: 16),
            Text(
              item.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                color: title,
                fontSize: 16 * scale,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                '${item.addressLine1}\n${item.addressLine2}',
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  color: sub,
                  fontSize: 12 * scale,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 30),
            if (selected)
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEEEEE),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFDDDDDD), width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    'assets/icons/checked.svg',
                    width: 24,
                  ),
                ),
              )
            else
              Container(
                height: 39,
                padding: const EdgeInsets.symmetric(horizontal: 22),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.30),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: const Color(0xFF242424), width: 1),
                ),
                child: Center(
                  child: Text(
                    l10n.select,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF797979),
                      fontSize: 14 * scale,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
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

class _BarberCard extends StatelessWidget {
  const _BarberCard({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _BarberItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bg = selected ? const Color(0xFFFFFFFF) : const Color(0xFF242424);
    final name = selected ? const Color(0xFF000000) : const Color(0xFFFFFFFF);
    final sub = selected ? const Color(0xFF242424) : const Color(0xFFDDDDDD);
    final scale = ResponsiveHelper.getResponsiveValue<double>(
      context,
      small: 1.0,
      medium: 1.10,
      large: 1.18,
    );
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: selected ? 2 : 0,
                  color: const Color(0xFF242424),
                ),
              ),
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.black.withValues(
                  alpha: selected ? 0.06 : 0.10,
                ),
                backgroundImage: AssetImage(item.imageAsset),
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: Text(
                item.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  color: name,
                  fontSize: 16 * scale,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                item.subtitle,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  color: sub,
                  fontSize: 12 * scale,
                  fontWeight: FontWeight.w600,
                  height: 1.15,
                ),
              ),
            ),
            const Spacer(),
            if (selected)
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEEEEE),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFDDDDDD)),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/checked.svg',
                    width: 24,
                  ),
                ),
              )
            else
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 22),
                decoration: BoxDecoration(
                  color: Color(0xFF000000).withValues(alpha: 0.30),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: const Color(0xFF242424), width: 1),
                ),
                child: Center(
                  child: Text(
                    l10n.select,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF797979),
                      fontSize: 14 * scale,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
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
    required this.onSelectDate,
    required this.selectedTimeIndex,
    required this.times,
    required this.onSelectTime,
    required this.onTapCalendar,
  });

  final String monthLabel;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onSelectDate;
  final int selectedTimeIndex;
  final List<String> times;
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
    // Disabled times to match the reference screenshot styling.
    final disabled = <int>{6, 14, 16}; // 12:00, 14:30, 17:00
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
              InkWell(
                onTap: onTapCalendar,
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: SvgPicture.asset(
                    'assets/icons/calendar.svg',
                    width: 24,
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
                final now = DateTime.now();
                final today = DateTime(now.year, now.month, now.day);
                return Row(
                  children: [
                    for (int i = 0; i < days.length; i++) ...[
                      if (i > 0) const SizedBox(width: 14),
                      Builder(
                        builder: (_) {
                          final d = days[i];
                          final isBlockedDow =
                              d.weekday == DateTime.wednesday ||
                                  d.weekday == DateTime.friday;
                          final isSelectable =
                              !d.isBefore(today) && !isBlockedDow;
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
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: times.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 2.35,
            ),
            itemBuilder: (context, i) {
              final isDisabled = disabled.contains(i);
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
                      times[i],
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

class _Step3MonthlySummary extends StatefulWidget {
  const _Step3MonthlySummary({
    required this.intervalLabel,
    required this.dateLabels,
    required this.selectedBarberName,
    required this.alternativeBarberName,
  });
  final String intervalLabel;
  final List<String> dateLabels;
  final String selectedBarberName;
  final String alternativeBarberName;

  @override
  State<_Step3MonthlySummary> createState() => _Step3MonthlySummaryState();
}

class _Step3MonthlySummaryState extends State<_Step3MonthlySummary> {
  bool _waitlist = false;

  Widget _entry({required String text, required Widget inner}) {
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
                  text,
                  style: GoogleFonts.inter(
                    color: const Color(0xFFDDDDDD),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                inner,
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.close_rounded, size: 16, color: Color(0xFF797979)),
        ],
      ),
    );
  }

  Widget _withBarberPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF797979).withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          color: const Color(0xFFDDDDDD),
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _alternativeBarberPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF797979).withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFEF4444), width: 1),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          color: const Color(0xFFDDDDDD),
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _warningWithWaitlist(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 16,
              color: Color(0xFFEF4444),
            ),
            const SizedBox(width: 8),
            Text(
              l10n.noBarberAvailable,
              style: GoogleFonts.inter(
                color: const Color(0xFFEF4444),
                fontSize: 13,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: () => setState(() => _waitlist = !_waitlist),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                SvgPicture.asset(
                  _waitlist
                      ? 'assets/icons/checked_box.svg'
                      : 'assets/icons/non_checked_box.svg',
                  width: 18,
                ),
                const SizedBox(width: 10),
                Text(
                  l10n.waitlistMe,
                  style: GoogleFonts.inter(
                    color: const Color(0xFFDDDDDD),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _innerForCycle(int cycleIndex, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final selected = widget.selectedBarberName.trim();
    final alternative = widget.alternativeBarberName.trim();

    switch (cycleIndex % 4) {
      case 0:
        return _withBarberPill(l10n.withBarberLabel(selected));
      case 1:
        return _warningWithWaitlist(context);
      case 2:
        // If we don't have an alternate barber loaded, fall back to the
        // "no barber available" warning so we never display fake data.
        if (alternative.isEmpty || alternative == selected) {
          return _warningWithWaitlist(context);
        }
        return _alternativeBarberPill(l10n.alternativeBarberLabel(alternative));
      case 3:
      default:
        return _withBarberPill(l10n.withBarberLabel(selected));
    }
  }

  @override
  Widget build(BuildContext context) {
    final lines = widget.dateLabels;
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              SvgPicture.asset('assets/icons/recurrence_icon.svg', width: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.intervalLabel,
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
          for (int i = 0; i < lines.length; i++)
            _entry(text: lines[i], inner: _innerForCycle(i, context)),
        ],
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

  static const int _maxOptions = 10;

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
                      separatorBuilder: (_, __) => const Padding(
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
