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
    return items
        .map(
          (e) => _ReservationItem(
            title: e.service.name.isNotEmpty ? e.service.name : 'Service',
            subtitle: e.barber.name.isNotEmpty
                ? 'con ${e.barber.name}'
                : 'con Barber',
            dateText: _formatDateText(e.startsAt),
            price: '€${e.service.price.toStringAsFixed(0)}',
            imageAsset: 'assets/images/barbar_1.jpg',
            recurring: false,
          ),
        )
        .toList(growable: false);
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
    final booked = _mapItems(_controller.byStatus('booked'));
    final completed = _mapItems(_controller.byStatus('completed'));
    final cancelled = _mapItems(_controller.byStatus('cancelled'));
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
    if (_expandedIndex >= list.length) {
      _expandedIndex = list.isEmpty ? 0 : list.length - 1;
    }

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
        builder: (controller) => Center(
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
                                label: 'Booked',
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
                            'No reservations found.',
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
                            final expanded = _expandedIndex == i;
                            return _ReservationCard(
                              item: item,
                              expanded: expanded,
                              mode: mode,
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
        ),
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
    required this.onTap,
  });

  final _ReservationItem item;
  final bool expanded;
  final _ReservationMode mode;
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
      _ReservationMode.booked => 'Booked',
      _ReservationMode.completed => l10n.completed,
      _ReservationMode.cancelled => l10n.cancelled,
    };
    final showDelete = mode == _ReservationMode.booked;
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
                children: const [
                  _HomeDivider(),
                  _ReservationRecurrence(),
                  SizedBox(height: 12),
                  _HomeDivider(),
                  SizedBox(height: 12),
                  _ReservaTime(),
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
  const _ReservaTime();

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
          l10n.fiveTimes,
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
  const _ReservationRecurrence();

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
        const _RecurrenceRow(
          text: 'Giovedì 9 aprile 2026, ore 10:00',
          pillText: 'con Marcus Silva',
        ),
        const _RecurrenceRow(
          text: 'Giovedì 16 aprile 2026, ore 10:00',
          pillText: 'con Marcus Silva',
        ),
        const _RecurrenceAltRow(
          text: 'Giovedì 23 aprile 2026, ore 10:00',
          altText: 'Alternative Barber with James Martinez',
        ),
        const _RecurrenceRow(
          text: 'Giovedì 30 aprile 2026, ore 10:00',
          pillText: 'con Marcus Silva',
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
          const SizedBox(width: 10),
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.close_rounded,
              size: 18,
              color: Color(0xFF797979),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecurrenceAltRow extends StatelessWidget {
  const _RecurrenceAltRow({required this.text, required this.altText});

  final String text;
  final String altText;

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
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFF797979).withValues(alpha: 0.20),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFFEF4444),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    altText,
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
          const SizedBox(width: 10),
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.close_rounded,
              size: 18,
              color: Color(0xFF797979),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReservationItem {
  const _ReservationItem({
    required this.title,
    required this.subtitle,
    required this.dateText,
    required this.price,
    required this.imageAsset,
    required this.recurring,
  });

  final String title;
  final String subtitle;
  final String dateText;
  final String price;
  final String imageAsset;
  final bool recurring;
}

enum _ReservationMode { booked, completed, cancelled }
