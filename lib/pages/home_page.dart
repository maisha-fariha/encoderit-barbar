import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gems_data_layer/gems_data_layer.dart';
import 'package:gems_responsive/gems_responsive.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/auth_controller.dart';
import '../controllers/appointment_ui_refresh_controller.dart';
import '../gen/l10n/app_localizations.dart';
import '../models/appointment/appointment_model.dart';
import '../repositories/appointment_repository.dart';
import '../routes/app_pages.dart';
import '../services/app_services.dart';
import '../services/profile_avatar_service.dart';
import '../widgets/session_user_avatar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tab = 0;
  int _expandedIndex = 0;
  bool _isLoadingUpcoming = true;
  String _upcomingError = '';
  List<_UpcomingItem> _upcomingItems = const <_UpcomingItem>[];
  int _totalAppointmentsCount = 0;
  Worker? _appointmentRefreshWorker;

  String _userName = '';
  String _userId = '';
  String _avatarUrl = '';

  void _onProfileAvatarRevisionChanged() {
    if (mounted) _loadUserFromSession();
  }

  @override
  void initState() {
    super.initState();
    _loadUserFromSession();
    _loadUpcomingBookedAppointments();
    if (Get.isRegistered<AppointmentUiRefreshController>()) {
      _appointmentRefreshWorker = ever(
        Get.find<AppointmentUiRefreshController>().revision,
        (_) {
          if (mounted) {
            _loadUpcomingBookedAppointments();
          }
        },
      );
    }
    if (Get.isRegistered<ProfileAvatarService>()) {
      Get.find<ProfileAvatarService>().revision.addListener(
        _onProfileAvatarRevisionChanged,
      );
    }
  }

  @override
  void dispose() {
    _appointmentRefreshWorker?.dispose();
    if (Get.isRegistered<ProfileAvatarService>()) {
      Get.find<ProfileAvatarService>().revision.removeListener(
        _onProfileAvatarRevisionChanged,
      );
    }
    super.dispose();
  }

  Future<void> _loadUserFromSession() async {
    final auth = await AppServices.getIt<AuthService>().getStoredAuth();
    if (!mounted) return;
    final u = auth?.userData;
    if (u == null) {
      setState(() {
        _userName = '';
        _userId = '';
        _avatarUrl = '';
      });
      return;
    }
    final name = (u['name'] as String? ?? '').trim();
    final email = (u['email'] as String? ?? '').trim();
    final displayName = name.isNotEmpty
        ? name
        : (email.contains('@') ? email.split('@').first : email);
    final idRaw = u['id'];
    final id = idRaw == null ? '' : idRaw.toString().trim();
    setState(() {
      _userName = displayName;
      _userId = id;
      _avatarUrl = (u['avatar_url'] as String? ?? '').trim();
    });
  }

  Future<bool> _ensureAuthenticated() async {
    final authController = Get.find<AuthController>();
    if (authController.isLoggedIn.value) return true;
    final AuthData? stored = await AppServices.getIt<AuthService>().getStoredAuth();
    final validStored =
        stored != null && stored.accessToken.isNotEmpty && !stored.isExpired;
    if (validStored) {
      authController.isLoggedIn.value = true;
      return true;
    }
    if (!mounted) return false;
    Get.offAllNamed(AppRoutes.login);
    return false;
  }

  Future<void> _loadUpcomingBookedAppointments() async {
    final canProceed = await _ensureAuthenticated();
    if (!canProceed) {
      if (!mounted) return;
      setState(() {
        _isLoadingUpcoming = false;
        _upcomingError = '';
        _upcomingItems = const <_UpcomingItem>[];
        _totalAppointmentsCount = 0;
        _expandedIndex = -1;
      });
      return;
    }

    setState(() {
      _isLoadingUpcoming = true;
      _upcomingError = '';
    });
    final repository = AppServices.getIt<AppointmentRepository>();
    final totalResult = await repository.getPage(1, useCache: false);
    if (!mounted) return;
    totalResult.when(
      success: (page) => _totalAppointmentsCount = page.total,
      failure: (_) => _totalAppointmentsCount = 0,
    );
    final result = await repository.getPage(1, useCache: false);
    if (!mounted) return;
    result.when(
      success: (page) {
        final items = page.items
            .where((item) => _normalizeStatus(item.status) == 'booked')
            .toList(growable: false);
        final mapped = _mapUpcomingItems(items);
        setState(() {
          _upcomingItems = mapped;
          _isLoadingUpcoming = false;
          _expandedIndex = mapped.isEmpty ? -1 : 0;
        });
      },
      failure: (error) {
        setState(() {
          _upcomingItems = const <_UpcomingItem>[];
          _upcomingError = error.message;
          _isLoadingUpcoming = false;
          _expandedIndex = -1;
        });
      },
    );
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

  List<_UpcomingItem> _mapUpcomingItems(List<AppointmentModel> items) {
    final grouped = <String, List<AppointmentModel>>{};
    final singles = <AppointmentModel>[];
    for (final item in items) {
      final groupId = item.recurringGroupId?.trim() ?? '';
      if (groupId.isEmpty) {
        singles.add(item);
      } else {
        grouped.putIfAbsent(groupId, () => <AppointmentModel>[]).add(item);
      }
    }

    final result = <_UpcomingItem>[];
    for (final groupItems in grouped.values) {
      groupItems.sort(
        (a, b) =>
            (a.startsAt ?? DateTime(1970)).compareTo(b.startsAt ?? DateTime(1970)),
      );
      final first = groupItems.first;
      result.add(
        _UpcomingItem(
          title: first.service.name.trim().isNotEmpty
              ? first.service.name.trim()
              : 'Service',
          subtitle: first.barber.name.trim().isNotEmpty
              ? 'con ${first.barber.name.trim()}'
              : 'con Barber',
          dateText: _formatDateText(first.startsAt),
          imageAsset: 'assets/images/barbar_1.jpg',
          hasRecurrence: true,
          sortAt: groupItems
              .map((e) => e.activitySortTime)
              .reduce((a, b) => a.isAfter(b) ? a : b),
          occurrences: groupItems
              .map(
                (e) => _UpcomingOccurrence(
                  dateText: _formatDateText(e.startsAt),
                  barberText: e.barber.name.trim().isNotEmpty
                      ? 'con ${e.barber.name.trim()}'
                      : 'con Barber',
                ),
              )
              .toList(growable: false),
        ),
      );
    }

    for (final item in singles) {
      final serviceName = item.service.name.trim();
      final barberName = item.barber.name.trim();
      result.add(
        _UpcomingItem(
          title: serviceName.isNotEmpty ? serviceName : 'Service',
          subtitle: barberName.isNotEmpty ? 'con $barberName' : 'con Barber',
          dateText: _formatDateText(item.startsAt),
          imageAsset: 'assets/images/barbar_1.jpg',
          hasRecurrence: false,
          sortAt: item.activitySortTime,
          occurrences: <_UpcomingOccurrence>[
            _UpcomingOccurrence(
              dateText: _formatDateText(item.startsAt),
              barberText: barberName.isNotEmpty ? 'con $barberName' : 'con Barber',
            ),
          ],
        ),
      );
    }

    result.sort(
      (a, b) => (b.sortAt ?? DateTime(1970)).compareTo(a.sortAt ?? DateTime(1970)),
    );
    return result;
  }

  String _formatDateText(DateTime? dateTime) {
    if (dateTime == null) return '';
    const months = <String>[
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
    final d = dateTime.toLocal();
    final month = months[(d.month - 1).clamp(0, 11)];
    final minute = d.minute.toString().padLeft(2, '0');
    return '${d.day} $month ${d.year}, ${d.hour}:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final isLarge = ResponsiveHelper.isLargeDevice(context);
    final hPad = ResponsiveHelper.getResponsiveValue<double>(
      context,
      small: 16,
      medium: 22,
      large: 28,
    );
    final contentMaxWidth = ResponsiveHelper.getResponsiveValue<double>(
      context,
      small: double.infinity,
      large: 980,
    );
    final fontScale = ResponsiveHelper.getResponsiveValue<double>(
      context,
      small: 1.0,
      medium: 1.12,
      large: 1.28,
    );
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 86,
        flexibleSpace: SafeArea(
          bottom: false,
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: contentMaxWidth),
              child: Padding(
                padding: EdgeInsets.fromLTRB(hPad, 16, hPad, 0),
                child: Row(
                  children: [
                    SessionUserAvatar(
                      radius: 22,
                      avatarUrl: _avatarUrl.isEmpty ? null : _avatarUrl,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _userName.isEmpty ? '—' : _userName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              color: const Color(0xFFFFFFFF),
                              fontSize: 18 * fontScale,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                            ),
                          ),
                          if (_userId.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              l10n.idNumber(_userId),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                color: const Color(0xFFDDDDDD),
                                fontSize: 14 * fontScale,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$_totalAppointmentsCount',
                          style: GoogleFonts.inter(
                            color: const Color(0xFFFFFFFF),
                            fontSize: 18 * fontScale,
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                            l10n.bookings,
                          style: GoogleFonts.inter(
                            color: const Color(0xFFDDDDDD),
                            fontSize: 14 * fontScale,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: contentMaxWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.all(isLarge ? 34 : 30),
                  decoration: const BoxDecoration(
                    color: Color(0xFF242424),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _UpcomingCard(
                        expandedIndex: _expandedIndex,
                        isLoading: _isLoadingUpcoming,
                        errorMessage: _upcomingError,
                        items: _upcomingItems,
                        onRetry: _loadUpcomingBookedAppointments,
                        onToggle: (i) => setState(
                          () => _expandedIndex = _expandedIndex == i ? -1 : i,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 54,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEEEEE),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () async {
                              final canProceed = await _ensureAuthenticated();
                              if (!canProceed) return;
                              Get.toNamed(AppRoutes.appoinment);
                            },
                            child: Text(
                                l10n.serviceBooking,
                              style: GoogleFonts.inter(
                                color: const Color(0xFF000000),
                                fontSize: 16 * fontScale,
                                fontWeight: FontWeight.w600,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: 62,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(colors: [Color(0xFF797979), Color(0xFF302C2C)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          border: Border.all(
            color: Color(0xFF8E8888).withValues(alpha: 0.7),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF4D4C4C).withValues(alpha: 0.70),
              blurRadius: 10,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () => Get.toNamed(AppRoutes.appoinment),
          backgroundColor: Colors.transparent,
          elevation: 0,
          shape: const CircleBorder(),
          child: const Icon(Icons.add_rounded, size: 30, color: Colors.white),
        ),
      ),
      bottomNavigationBar: _BottomNavBar(
        currentIndex: _tab,
        onTap: (i) {
          setState(() => _tab = i);
          if (i == 1) {
            Get.toNamed(AppRoutes.reservations);
          }
          if (i == 3) {
            Get.toNamed(AppRoutes.profile);
          }
          if (i == 4) {
            Get.toNamed(AppRoutes.contact);
          }
        },
      ),
    );
  }
}

class _UpcomingCard extends StatelessWidget {
  const _UpcomingCard({
    required this.expandedIndex,
    required this.isLoading,
    required this.errorMessage,
    required this.items,
    required this.onRetry,
    required this.onToggle,
  });

  final int expandedIndex;
  final bool isLoading;
  final String errorMessage;
  final List<_UpcomingItem> items;
  final VoidCallback onRetry;
  final ValueChanged<int> onToggle;

  @override
  Widget build(BuildContext context) {
    final fontScale = ResponsiveHelper.getResponsiveValue<double>(
      context,
      small: 1.0,
      medium: 1.08,
      large: 1.22,
    );
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.nextAppointment,
          style: GoogleFonts.inter(
            color: const Color(0xFFEEEEEE),
            fontSize: 18 * fontScale,
            fontWeight: FontWeight.w700,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 15),
        if (isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: CircularProgressIndicator(color: Color(0xFFEEEEEE)),
            ),
          )
        else if (errorMessage.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                errorMessage,
                style: GoogleFonts.inter(
                  color: const Color(0xFFDDDDDD),
                  fontSize: 13 * fontScale,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: onRetry,
                  child: const Text('Retry'),
                ),
              ),
            ],
          )
        else if (items.isEmpty)
          Text(
            l10n.noBookedAppointmentsFound,
            style: GoogleFonts.inter(
              color: const Color(0xFFDDDDDD),
              fontSize: 13 * fontScale,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          )
        else
        ...List.generate(items.length, (i) {
          final item = items[i];
          final expanded = expandedIndex == i;
          return Padding(
            padding: EdgeInsets.only(bottom: i == items.length - 1 ? 0 : 12),
            child: _UpcomingAccordionItem(
              item: item,
              expanded: expanded,
              onTap: () => onToggle(i),
            ),
          );
        }),
      ],
    );
  }
}

class _UpcomingAccordionItem extends StatelessWidget {
  const _UpcomingAccordionItem({
    required this.item,
    required this.expanded,
    required this.onTap,
  });

  final _UpcomingItem item;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final fontScale = ResponsiveHelper.getResponsiveValue<double>(
      context,
      small: 1.0,
      medium: 1.08,
      large: 1.22,
    );
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: item.hasRecurrence ? onTap : null,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      item.imageAsset,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: GoogleFonts.inter(
                            color: const Color(0xFFFFFFFF),
                            fontSize: 16 * fontScale,
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${item.subtitle}   •   ${item.dateText}',
                          style: GoogleFonts.inter(
                            color: const Color(0xFFDDDDDD),
                            fontSize: 13 * fontScale,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (item.hasRecurrence) ...[
                    const SizedBox(width: 8),
                    Icon(
                      expanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: const Color(0xFF797979),
                      size: 20,
                    ),
                  ],
                ],
              ),
            ),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 220),
              firstCurve: Curves.easeOut,
              secondCurve: Curves.easeOut,
              sizeCurve: Curves.easeOut,
              crossFadeState: expanded && item.hasRecurrence
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: const SizedBox.shrink(),
              secondChild: Column(
                children: [
                  _HomeDivider(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/recurrence_icon.svg',
                          width: 18,
                        ),
                        SizedBox(width: 10),
                        Text(
                          l10n.recurring,
                          style: GoogleFonts.inter(
                            color: Color(0xFFFFFFFF),
                            fontSize: 16 * fontScale,
                            fontWeight: FontWeight.w700,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...item.occurrences.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
                      child: _RecurrenceRow(
                        text: entry.dateText,
                        pillText: entry.barberText,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  _HomeDivider(),
                  SizedBox(height: 15),
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 30),
                    child: Row(
                      children: [
                        Text(
                          l10n.howManyBookings,
                          style: GoogleFonts.inter(
                            color: Color(0xFFDDDDDD),
                            fontSize: 16 * fontScale,
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                          ),
                        ),
                        Spacer(),
                        Text(
                          l10n.nTimes(item.occurrences.length),
                          style: GoogleFonts.inter(
                            color: Color(0xFFFFFFFF),
                            fontSize: 16 * fontScale,
                            fontWeight: FontWeight.w700,
                            height: 1.5,
                          ),
                        )
                      ]
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeDivider extends StatelessWidget {
  const _HomeDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: Color(0xFF797979).withValues(alpha: 0.30),
    );
  }
}

class _RecurrenceRow extends StatelessWidget {
  const _RecurrenceRow({required this.text, required this.pillText});

  final String text;
  final String pillText;

  @override
  Widget build(BuildContext context) {
    final fontScale = ResponsiveHelper.getResponsiveValue<double>(
      context,
      small: 1.0,
      medium: 1.08,
      large: 1.22,
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 14, 0, 14),
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
                    color: const Color(0xFFEEEEEE),
                    fontSize: 14 * fontScale,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
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
                  ),
                  child: Text(
                    pillText,
                    style: GoogleFonts.inter(
                      color: const Color(0xFFDDDDDD),
                      fontSize: 14 * fontScale,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UpcomingItem {
  const _UpcomingItem({
    required this.title,
    required this.subtitle,
    required this.dateText,
    required this.imageAsset,
    required this.hasRecurrence,
    required this.sortAt,
    required this.occurrences,
  });

  final String title;
  final String subtitle;
  final String dateText;
  final String imageAsset;
  final bool hasRecurrence;
  final DateTime? sortAt;
  final List<_UpcomingOccurrence> occurrences;
}

class _UpcomingOccurrence {
  const _UpcomingOccurrence({required this.dateText, required this.barberText});

  final String dateText;
  final String barberText;
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.paddingOf(context).bottom;
    return SizedBox(
      height: 82 + pad,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              padding: EdgeInsets.only(bottom: pad),
              decoration: const BoxDecoration(color: Color(0xFF1F1F1F)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(
                    label: AppLocalizations.of(context)!.home,
                    activeAsset: 'assets/icons/home_active.svg',
                    inactiveAsset: 'assets/icons/home_inactive.svg',
                    selected: currentIndex == 0,
                    onTap: () => onTap(0),
                  ),
                  _NavItem(
                    label: AppLocalizations.of(context)!.reservations,
                    activeAsset: 'assets/icons/reservation_active.svg',
                    inactiveAsset: 'assets/icons/reservation_inactive.svg',
                    selected: currentIndex == 1,
                    onTap: () => onTap(1),
                  ),
                  const SizedBox(width: 58),
                  _NavItem(
                    label: AppLocalizations.of(context)!.profile,
                    activeAsset: 'assets/icons/profile_active.svg',
                    inactiveAsset: 'assets/icons/profile_inactive.svg',
                    selected: currentIndex == 3,
                    onTap: () => onTap(3),
                  ),
                  _NavItem(
                    label: AppLocalizations.of(context)!.contactUs,
                    activeAsset: 'assets/icons/contact_active.svg',
                    inactiveAsset: 'assets/icons/contact_inactive.svg',
                    selected: currentIndex == 4,
                    onTap: () => onTap(4),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.activeAsset,
    required this.inactiveAsset,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String activeAsset;
  final String inactiveAsset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? const Color(0xFFFFFFFF)
        : Color(0xFFFFFFFF).withValues(alpha: 0.4);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SvgPicture.asset(
                selected ? activeAsset : inactiveAsset,
                width: 22,
                height: 22,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                height: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
