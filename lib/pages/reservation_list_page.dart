import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gems_responsive/gems_responsive.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/reservation_list_controller.dart';
import '../gen/l10n/app_localizations.dart';
import '../models/appointment/appointment_model.dart';

import '../routes/app_pages.dart';

class ReservationListPage extends StatefulWidget {
  const ReservationListPage({super.key});

  @override
  State<ReservationListPage> createState() => _ReservationListPageState();
}

class _ReservationListPageState extends State<ReservationListPage> {
  int _tab = 0; // 0 booked, 1 completed, 2 cancelled
  int _expandedIndex = 0;
  int _navIndex = 1; // Prenotazione selected
  late final ReservationListController _controller;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<ReservationListController>();
    _scrollController = ScrollController()..addListener(_onListScroll);
    _controller.loadItems();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onListScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onListScroll() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 220) {
      _controller.loadNextPage();
    }
  }

  List<_ReservationItem> _mapItems(List<AppointmentModel> items) {
    final grouped = <String, List<AppointmentModel>>{};
    final singles = <AppointmentModel>[];
    for (final item in items) {
      final groupId = item.recurringGroupId?.trim() ?? '';
      if (groupId.isEmpty) {
        singles.add(item);
        continue;
      }
      grouped.putIfAbsent(groupId, () => <AppointmentModel>[]).add(item);
    }

    final result = <_ReservationItem>[];
    for (final groupItems in grouped.values) {
      groupItems.sort(
        (a, b) => (a.startsAt ?? DateTime(1970)).compareTo(
          b.startsAt ?? DateTime(1970),
        ),
      );
      final first = groupItems.first;
      final occurrences = groupItems
          .map(
            (e) => _ReservationOccurrence(
              dateText: _formatDateText(e.startsAt),
              barberText: e.barber.name.isNotEmpty
                  ? 'con ${e.barber.name}'
                  : 'con Barber',
            ),
          )
          .toList(growable: false);
      result.add(
        _ReservationItem(
          id: first.id,
          title: first.service.name.isNotEmpty ? first.service.name : 'Service',
          subtitle: first.barber.name.isNotEmpty
              ? 'con ${first.barber.name}'
              : 'con Barber',
          dateText: _formatDateText(first.startsAt),
          price: '€${first.service.price.toStringAsFixed(0)}',
          imageAsset: 'assets/images/barbar_1.jpg',
          recurring: occurrences.length > 1,
          occurrences: occurrences,
        ),
      );
    }

    for (final e in singles) {
      result.add(
        _ReservationItem(
          id: e.id,
          title: e.service.name.isNotEmpty ? e.service.name : 'Service',
          subtitle: e.barber.name.isNotEmpty ? 'con ${e.barber.name}' : 'con Barber',
          dateText: _formatDateText(e.startsAt),
          price: '€${e.service.price.toStringAsFixed(0)}',
          imageAsset: 'assets/images/barbar_1.jpg',
          recurring: false,
          occurrences: <_ReservationOccurrence>[
            _ReservationOccurrence(
              dateText: _formatDateText(e.startsAt),
              barberText: e.barber.name.isNotEmpty ? 'con ${e.barber.name}' : 'con Barber',
            ),
          ],
        ),
      );
    }
    result.sort((a, b) => a.dateText.compareTo(b.dateText));
    return result;
  }

  Future<void> _deleteReservation(_ReservationItem item) async {
    final confirmed = await _showDeleteConfirmDialog();
    if (confirmed != true) return;

    final result = await _controller.deleteAppointment(item.id);
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    messenger.clearSnackBars();
    result.when(
      success: (_) => messenger.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFFE8E8E8),
          content: Text(
            l10n.appointmentDeleted,
            style: GoogleFonts.inter(
              color: const Color(0xFF0B0B0B),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      failure: (error) => messenger.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFFE8E8E8),
          content: Text(
            error.message,
            style: GoogleFonts.inter(
              color: const Color(0xFFB91C1C),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  /// Dark-themed delete confirmation dialog.
  ///
  /// Matches the booking confirm dialog (`appoinment_page.dart`) so both
  /// destructive actions share the same surface, border, and button styling.
  /// Returns `true` when the user taps "Yes", `false`/`null` otherwise.
  Future<bool?> _showDeleteConfirmDialog() {
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'delete-appointment',
      barrierColor: Colors.black.withValues(alpha: 0.55),
      pageBuilder: (context, anim1, anim2) => const SizedBox.shrink(),
      transitionDuration: const Duration(milliseconds: 180),
      transitionBuilder: (dialogContext, anim, anim2, child) {
        final curve = Curves.easeOutCubic.transform(anim.value);
        final l10n = AppLocalizations.of(dialogContext)!;
        return Transform.scale(
          scale: 0.96 + (0.04 * curve),
          child: Opacity(
            opacity: curve,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
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
                            right: 14,
                            top: 14,
                            child: InkWell(
                              onTap: () =>
                                  Navigator.of(dialogContext).pop(false),
                              borderRadius: BorderRadius.circular(18),
                              child: const Padding(
                                padding: EdgeInsets.all(10),
                                child: Icon(
                                  Icons.close_rounded,
                                  color: Color(0xFF797979),
                                  size: 28,
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
                                Container(
                                  width: 72,
                                  height: 72,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(
                                      0xFFEF4444,
                                    ).withValues(alpha: 0.16),
                                    border: Border.all(
                                      color: const Color(
                                        0xFFEF4444,
                                      ).withValues(alpha: 0.45),
                                      width: 1,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: SvgPicture.asset(
                                    'assets/icons/delete.svg',
                                    width: 30,
                                    height: 30,
                                    colorFilter: const ColorFilter.mode(
                                      Color(0xFFEF4444),
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 22),
                                Text(
                                  l10n.deleteAppointmentTitle,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFFFFFFFF),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  l10n.deleteAppointmentMessage,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFFDDDDDD),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 28),
                                Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height: 52,
                                        child: OutlinedButton(
                                          onPressed: () =>
                                              Navigator.of(
                                                dialogContext,
                                              ).pop(false),
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
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              l10n.noAction,
                                              style: GoogleFonts.inter(
                                                color: const Color(0xFF797979),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                height: 1.5,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: SizedBox(
                                        height: 52,
                                        child: FilledButton(
                                          onPressed: () =>
                                              Navigator.of(
                                                dialogContext,
                                              ).pop(true),
                                          style: FilledButton.styleFrom(
                                            backgroundColor: const Color(
                                              0xFFEF4444,
                                            ),
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              l10n.yesAction,
                                              style: GoogleFonts.inter(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
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
    final pad = MediaQuery.paddingOf(context);
    final hPad = ResponsiveHelper.getResponsiveValue<double>(
      context,
      small: 18,
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
      medium: 1.08,
      large: 1.22,
    );
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 72,
        flexibleSpace: SafeArea(
          bottom: false,
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: contentMaxWidth),
              child: Padding(
                padding: EdgeInsets.fromLTRB(hPad, 20, hPad, 0),
                child: Row(
                  children: [
                    InkResponse(
                      radius: 24,
                      onTap: () => Get.back(),
                      child: SvgPicture.asset(
                        'assets/icons/back_button.svg',
                        width: 18 * fontScale,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      l10n.reservationListTitle,
                      style: GoogleFonts.inter(
                        color: const Color(0xFFFFFFFF),
                        fontSize: 18 * fontScale,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: GetBuilder<ReservationListController>(
        id: 'reservation-list',
        builder: (controller) {
          final booked = _mapItems(controller.byStatus('booked'));
          final completed = _mapItems(controller.byStatus('completed'));
          final cancelled = _mapItems(controller.byStatus('cancelled'));
          final list = _tab == 0
              ? booked
              : _tab == 1
              ? completed
              : cancelled;
          final mode = _tab == 0
              ? _ReservationMode.booked
              : _tab == 1
              ? _ReservationMode.completed
              : _ReservationMode.cancelled;
          final effectiveExpandedIndex = _expandedIndex >= list.length
              ? (list.isEmpty ? -1 : list.length - 1)
              : _expandedIndex;
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: contentMaxWidth),
              child: Column(
                children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(hPad, 15, hPad, 15),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: ResponsiveHelper.getResponsiveValue<double>(
                          context,
                          small: double.infinity,
                          large: 560,
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFFFFF).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                            color: const Color(0xFF242424),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF000000,
                              ).withValues(alpha: 0.15),
                              blurRadius: 4,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: [
                              _TopPill(
                                label: l10n.upcoming,
                                count: '${booked.length}',
                                selected: _tab == 0,
                                onTap: () => setState(() => _tab = 0),
                              ),
                              const SizedBox(width: 10),
                              _TopPill(
                                label: l10n.completed,
                                count: '${completed.length}',
                                selected: _tab == 1,
                                onTap: () => setState(() => _tab = 1),
                              ),
                              const SizedBox(width: 10),
                              _TopPill(
                                label: l10n.cancelled,
                                count: '${cancelled.length}',
                                selected: _tab == 2,
                                onTap: () => setState(() => _tab = 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: controller.isLoading.value && list.isEmpty
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFEEEEEE),
                          ),
                        )
                      : controller.errorMessage.value.isNotEmpty && list.isEmpty
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: hPad),
                            child: Text(
                              controller.errorMessage.value,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                color: const Color(0xFFDDDDDD),
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        )
                      : list.isEmpty
                      ? Center(
                          child: Text(
                            l10n.noReservationsFound,
                            style: GoogleFonts.inter(
                              color: const Color(0xFFDDDDDD),
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        )
                      : ListView.separated(
                          controller: _scrollController,
                          padding: EdgeInsets.fromLTRB(
                            hPad,
                            0,
                            hPad,
                            120 + pad.bottom,
                          ),
                          itemCount:
                              list.length + (controller.isLoadingMore ? 1 : 0),
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 14),
                          itemBuilder: (context, i) {
                            if (i >= list.length) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFFEEEEEE),
                                  ),
                                ),
                              );
                            }
                            final item = list[i];
                            final expanded = effectiveExpandedIndex == i;
                            return _ReservationCard(
                              item: item,
                              expanded: expanded,
                              mode: mode,
                              onDelete: () => _deleteReservation(item),
                              onTap: () => setState(
                                () => _expandedIndex = _expandedIndex == i
                                    ? -1
                                    : i,
                              ),
                            );
                          },
                        ),
                ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: 62,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFF797979), Color(0xFF302C2C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: const Color(0xFF8E8888).withValues(alpha: 0.7),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4D4C4C).withValues(alpha: 0.70),
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
        currentIndex: _navIndex,
        onTap: (i) {
          setState(() => _navIndex = i);
          if (i == 0) {
            Get.offAllNamed(AppRoutes.home);
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
    final color = selected ? const Color(0xFFEDEDED) : const Color(0xFF8E8E8E);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Center(
                child: SvgPicture.asset(
                  selected ? activeAsset : inactiveAsset,
                  width: 22,
                  height: 22,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                height: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopPill extends StatelessWidget {
  const _TopPill({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(26),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFFFFFFF)
              : Color(0xFFFFFFFF).withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                color: selected
                    ? const Color(0xFF000000)
                    : Color(0xFFFFFFFF).withValues(alpha: 0.5),
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF000000)
                    : Color(0xFF000000).withValues(alpha: 0.30),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                count,
                style: GoogleFonts.inter(
                  color: selected
                      ? const Color(0xFFFFFFFF)
                      : Color(0xFFFFFFFF).withValues(alpha: 0.5),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  height: 1.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReservationCard extends StatelessWidget {
  const _ReservationCard({
    required this.item,
    required this.expanded,
    required this.mode,
    required this.onDelete,
    required this.onTap,
  });

  final _ReservationItem item;
  final bool expanded;
  final _ReservationMode mode;
  final VoidCallback onDelete;
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
    final statusLabel = switch (mode) {
      _ReservationMode.booked => l10n.upcoming,
      _ReservationMode.completed => l10n.completed,
      _ReservationMode.cancelled => l10n.cancelled,
    };
    final showDelete = mode == _ReservationMode.booked && !item.recurring;
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFF242424), width: 1),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF000000).withValues(alpha: 0.15),
            blurRadius: 4,
            offset: const Offset(0, 0),
          ),
        ],
      ),
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
                    width: 80,
                    height: 80,
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
                          fontSize: 18 * fontScale,
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${item.subtitle}  •  ${item.dateText}',
                        style: GoogleFonts.inter(
                          color: const Color(0xFFDDDDDD),
                          fontSize: 13 * fontScale,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.price,
                        style: GoogleFonts.inter(
                          color: const Color(0xFFFFFFFF),
                          fontSize: 16 * fontScale,
                          fontWeight: FontWeight.w700,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Divider(
              thickness: 1,
              color: Color(0xFF797979).withValues(alpha: 0.30),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
            child: Row(
              children: [
                _SmallChip(label: statusLabel),
                const Spacer(),
                if (item.recurring)
                  InkWell(
                    onTap: onTap,
                    borderRadius: BorderRadius.circular(18),
                    child: _SmallChip(
                      label: AppLocalizations.of(context)!.recurring,
                      trailing: Icon(
                        expanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        size: 18,
                        color: const Color(0xFF797979),
                      ),
                    ),
                  ),
                const SizedBox(width: 12),
                if (showDelete)
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: InkWell(
                      onTap: onDelete,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          color: Color(0xFFEF4444),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                            'assets/icons/delete.svg',
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 220),
            crossFadeState: expanded && item.recurring
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
              child: Column(
                children: [
                  const _HomeDivider(),
                  _ReservationRecurrence(occurrences: item.occurrences),
                  const SizedBox(height: 12),
                  const _HomeDivider(),
                  const SizedBox(height: 12),
                  _ReservaTime(count: item.occurrences.length),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReservaTime extends StatelessWidget {
  const _ReservaTime({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final fontScale = ResponsiveHelper.getResponsiveValue<double>(
      context,
      small: 1.0,
      medium: 1.08,
      large: 1.22,
    );
    return Row(
      children: [
        Text(
          l10n.howManyBookings,
          style: GoogleFonts.inter(
            color: const Color(0xFFDDDDDD),
            fontSize: 16 * fontScale,
            fontWeight: FontWeight.w600,
            height: 1.5,
          ),
        ),
        const Spacer(),
        Text(
          l10n.nTimes(count),
          style: GoogleFonts.inter(
            color: const Color(0xFFFFFFFF),
            fontSize: 16 * fontScale,
            fontWeight: FontWeight.w700,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _SmallChip extends StatelessWidget {
  const _SmallChip({required this.label, this.trailing});

  final String label;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: Color(0xFF797979).withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Color(0xFF797979)),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              color: const Color(0xFFFFFFFF),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 6), trailing!],
        ],
      ),
    );
  }
}

class _HomeDivider extends StatelessWidget {
  const _HomeDivider();

  @override
  Widget build(BuildContext context) =>
      Container(height: 1, color: Color(0xFF797979).withValues(alpha: 0.30));
}

class _ReservationRecurrence extends StatelessWidget {
  const _ReservationRecurrence({required this.occurrences});

  final List<_ReservationOccurrence> occurrences;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final fontScale = ResponsiveHelper.getResponsiveValue<double>(
      context,
      small: 1.0,
      medium: 1.08,
      large: 1.22,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        Row(
          children: [
            SvgPicture.asset('assets/icons/recurrence_icon.svg', width: 18),
            const SizedBox(width: 10),
            Text(
              l10n.every4Weeks,
              style: GoogleFonts.inter(
                color: const Color(0xFFFFFFFF),
                fontSize: 16 * fontScale,
                fontWeight: FontWeight.w700,
                height: 1.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...occurrences.map(
          (entry) => _RecurrenceRow(
            text: entry.dateText,
            pillText: entry.barberText,
          ),
        ),
      ],
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
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
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
                    borderRadius: BorderRadius.circular(10),
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

class _ReservationOccurrence {
  const _ReservationOccurrence({required this.dateText, required this.barberText});

  final String dateText;
  final String barberText;
}

class _ReservationItem {
  const _ReservationItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.dateText,
    required this.price,
    required this.imageAsset,
    required this.recurring,
    required this.occurrences,
  });

  final String id;
  final String title;
  final String subtitle;
  final String dateText;
  final String price;
  final String imageAsset;
  final bool recurring;
  final List<_ReservationOccurrence> occurrences;
}

enum _ReservationMode { booked, completed, cancelled }
