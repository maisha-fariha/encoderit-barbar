import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gems_responsive/gems_responsive.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/barber_list_controller.dart';
import '../controllers/shop_list_controller.dart';
import '../controllers/service_list_controller.dart';
import '../gen/l10n/app_localizations.dart';
import '../models/shop/shop_model.dart';

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
  DateTime _selectedDate = DateTime(2026, 4, 9);
  bool _recurringEnabled = true;
  int _recurringIndex = 0;
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
        _selectedDate = DateTime(2026, 4, 9);
        _recurringEnabled = true;
        _recurringIndex = 0;
      });
      return;
    }
    if (_step == 4) {
      setState(() => _step = 5);
      return;
    }
    // Next steps can be implemented later.
  }

  String _monthLabelIt(DateTime date) {
    const months = [
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
    final m = months[(date.month - 1).clamp(0, 11)];
    return '$m ${date.year}';
  }

  Future<void> _pickStep3Date() async {
    final initial = _selectedDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020, 1, 1),
      lastDate: DateTime(2035, 12, 31),
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
      barrierDismissible: true,
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
                            child: InkWell(
                              onTap: () => Navigator.of(context).pop(),
                              borderRadius: BorderRadius.circular(18),
                              child: const Padding(
                                padding: EdgeInsets.all(10),
                                child: Icon(
                                  Icons.close_rounded,
                                  color: Color(0xFF797979),
                                  size: 32,
                                ),
                              ),
                            ),
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
                                Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height: 54,
                                        child: OutlinedButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          style: OutlinedButton.styleFrom(
                                            side: const BorderSide(
                                              color: Color(0xFF797979),
                                              width: 1,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            backgroundColor: Colors.transparent,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
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
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            if (!mounted) return;
                                            setState(() => _step = 5);
                                          },
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
                                          ),
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              AppLocalizations.of(
                                                context,
                                              )!.confirmAction,
                                              style: GoogleFonts.inter(
                                                color: const Color(0xFF242424),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                height: 1.5,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
                              monthLabel: _monthLabelIt(_selectedDate),
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
                                const SizedBox(height: 15),
                                if (_recurringEnabled)
                                  _Step3RecurringOptions(
                                    options: [
                                      l10n.everyThursday,
                                      l10n.every2Weeks,
                                      l10n.every3Weeks,
                                      l10n.every4Weeks,
                                    ],
                                    selectedIndex: _recurringIndex,
                                    onSelect: (i) =>
                                        setState(() => _recurringIndex = i),
                                  ),
                                const SizedBox(height: 15),
                                _Step3MonthlySummary(
                                  intervalLabel: [
                                    l10n.everyThursday,
                                    l10n.every2Weeks,
                                    l10n.every3Weeks,
                                    l10n.every4Weeks,
                                  ][_recurringIndex.clamp(0, 3)],
                                ),
                                const SizedBox(height: 15),
                                const _Step4HowManyDropdown(),
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
                            final card = _Step4SummaryCard(
                              service: selectedService,
                              barber: selectedBarber,
                              time: _times[_selectedTime],
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
                  child: SizedBox(
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
  });

  final _ServiceItem service;
  final _BarberItem barber;
  final String time;

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
          _Step4KeyValueRow(label: l10n.date, value: 'Gio, Aprile 09'),
          const SizedBox(height: 14),
          _Step4KeyValueRow(label: l10n.time, value: '$time AM'),
          const SizedBox(height: 18),
          const _Step4Divider(),
          const SizedBox(height: 20),
          const _Step4MonthlyRecurrence(),
          const SizedBox(height: 25),
          const _Step4Divider(),
          const SizedBox(height: 20),
          const _Step4ReservationTime(),
          const _Step4Divider(),
          const SizedBox(height: 20),
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
  const _Step4ReservationTime();

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
          l10n.fiveTimes,
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
  const _Step4MonthlyRecurrence();

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
              AppLocalizations.of(context)!.every4Weeks,
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
    required this.selectedTimeIndex,
    required this.times,
    required this.onSelectTime,
    required this.onTapCalendar,
  });

  final String monthLabel;
  final int selectedTimeIndex;
  final List<String> times;
  final ValueChanged<int> onSelectTime;
  final VoidCallback onTapCalendar;

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
            child: Row(
              children: const [
                _DayChip(
                  day: 'Mer',
                  date: '08',
                  selected: false,
                  emphasized: false,
                ),
                SizedBox(width: 14),
                _DayChip(
                  day: 'Gio',
                  date: '09',
                  selected: true,
                  emphasized: true,
                ),
                SizedBox(width: 14),
                _DayChip(
                  day: 'Ven',
                  date: '10',
                  selected: false,
                  emphasized: false,
                ),
                SizedBox(width: 14),
                _DayChip(
                  day: 'Sab',
                  date: '11',
                  selected: false,
                  emphasized: true,
                ),
                SizedBox(width: 14),
                _DayChip(
                  day: 'Dom',
                  date: '12',
                  selected: false,
                  emphasized: true,
                ),
                SizedBox(width: 14),
                _DayChip(
                  day: 'Lun',
                  date: '13',
                  selected: false,
                  emphasized: true,
                ),
                SizedBox(width: 14),
                _DayChip(
                  day: 'Mar',
                  date: '14',
                  selected: false,
                  emphasized: true,
                ),
              ],
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
  });

  final String day;
  final String date;
  final bool selected;
  final bool emphasized;

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

    return Container(
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
              return InkWell(
                onTap: () => onSelect(i),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  alignment: Alignment.centerLeft,
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
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _Step3MonthlySummary extends StatefulWidget {
  const _Step3MonthlySummary({required this.intervalLabel});
  final String intervalLabel;

  @override
  State<_Step3MonthlySummary> createState() => _Step3MonthlySummaryState();
}

class _Step3MonthlySummaryState extends State<_Step3MonthlySummary> {
  bool _waitlist = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const lines = [
      'Giovedì 9 aprile 2026, ore 10:00',
      'Giovedì 16 aprile 2026, ore 10:00',
      'Giovedì 23 aprile 2026, ore 10:00',
      'Giovedì 30 aprile 2026, ore 10:00',
    ];

    Widget entry({required String text, required Widget inner}) {
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
          const SizedBox(height: 14),
          entry(
            text: lines[0],
            inner: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Color(0xFF797979).withValues(alpha: 0.20),
                borderRadius: BorderRadius.circular(10),
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
          ),
          entry(
            text: lines[1],
            inner: Column(
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
            ),
          ),
          entry(
            text: lines[2],
            inner: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Color(0xFF797979).withValues(alpha: 0.20),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFEF4444), width: 1),
              ),
              child: Text(
                'Barbiere alternativo con James\nMartinez',
                style: GoogleFonts.inter(
                  color: const Color(0xFFDDDDDD),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
            ),
          ),
          entry(
            text: lines[3],
            inner: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Color(0xFF797979).withValues(alpha: 0.20),
                borderRadius: BorderRadius.circular(10),
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
          ),
        ],
      ),
    );
  }
}

class _Step4HowManyDropdown extends StatelessWidget {
  const _Step4HowManyDropdown();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
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
              l10n.howManyBookings,
              style: GoogleFonts.inter(
                color: const Color(0xFF797979),
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
