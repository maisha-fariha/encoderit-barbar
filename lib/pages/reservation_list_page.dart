import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../routes/app_pages.dart';

class ReservationListPage extends StatefulWidget {
  const ReservationListPage({super.key});

  @override
  State<ReservationListPage> createState() => _ReservationListPageState();
}

class _ReservationListPageState extends State<ReservationListPage> {
  int _tab = 0; // 0 upcoming, 1 completed, 2 cancelled
  int _expandedIndex = 0;
  int _navIndex = 1; // Prenotazione selected

  final _upcoming = const <_ReservationItem>[
    _ReservationItem(
      title: 'Taglio di capelli',
      subtitle: 'con Silva',
      dateText: '12 aprile 2026, 14:30',
      price: '€45',
      imageAsset: 'assets/images/onboarding_1.png',
      recurring: true,
    ),
    _ReservationItem(
      title: 'Rifinitura della barba',
      subtitle: 'con Rossi',
      dateText: '12 aprile 2026, 14:30',
      price: '€60',
      imageAsset: 'assets/images/onboarding_1.png',
      recurring: false,
    ),
    _ReservationItem(
      title: 'Capelli + Barba',
      subtitle: 'con David',
      dateText: '12 aprile 2026, 14:30',
      price: '€30',
      imageAsset: 'assets/images/onboarding_1.png',
      recurring: false,
    ),
  ];

  final _completed = const <_ReservationItem>[
    _ReservationItem(
      title: 'Taglio di capelli',
      subtitle: 'con Silva',
      dateText: '12 aprile 2026, 14:30',
      price: '€45',
      imageAsset: 'assets/images/onboarding_1.png',
      recurring: true,
    ),
    _ReservationItem(
      title: 'Rifinitura della barba',
      subtitle: 'con Rossi',
      dateText: '12 aprile 2026, 14:30',
      price: '€60',
      imageAsset: 'assets/images/onboarding_1.png',
      recurring: false,
    ),
    _ReservationItem(
      title: 'Capelli + Barba',
      subtitle: 'con David',
      dateText: '12 aprile 2026, 14:30',
      price: '€30',
      imageAsset: 'assets/images/onboarding_1.png',
      recurring: false,
    ),
  ];

  final _cancelled = const <_ReservationItem>[
    _ReservationItem(
      title: 'Rifinitura della barba',
      subtitle: 'con Rossi',
      dateText: '12 aprile 2026, 14:30',
      price: '€60',
      imageAsset: 'assets/images/onboarding_1.png',
      recurring: false,
    ),
    _ReservationItem(
      title: 'Capelli + Barba',
      subtitle: 'con David',
      dateText: '12 aprile 2026, 14:30',
      price: '€30',
      imageAsset: 'assets/images/onboarding_1.png',
      recurring: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.paddingOf(context);
    final isWide = MediaQuery.sizeOf(context).width >= 600;
    final hPad = isWide ? 28.0 : 18.0;
    final list = _tab == 0
        ? _upcoming
        : _tab == 1
            ? _completed
            : _cancelled;
    final mode = _tab == 0
        ? _ReservationMode.upcoming
        : _tab == 1
            ? _ReservationMode.completed
            : _ReservationMode.cancelled;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(hPad, 14, hPad, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    color: Colors.white,
                    iconSize: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Elenco prenotazioni',
                    style: GoogleFonts.inter(
                      color: const Color(0xFFEDEDED),
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(hPad, 0, hPad, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2B2B2B),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: [
                            _TopPill(
                              label: 'Prossimamente',
                              count: '3',
                              selected: _tab == 0,
                              onTap: () => setState(() => _tab = 0),
                            ),
                            const SizedBox(width: 10),
                            _TopPill(
                              label: 'Completato',
                              count: '25',
                              selected: _tab == 1,
                              onTap: () => setState(() => _tab = 1),
                            ),
                            const SizedBox(width: 10),
                            _TopPill(
                              label: 'Annullata',
                              count: '2',
                              selected: _tab == 2,
                              onTap: () => setState(() => _tab = 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.fromLTRB(hPad, 0, hPad, 120 + pad.bottom),
                itemCount: list.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 14),
                itemBuilder: (context, i) {
                  final item = list[i];
                  final expanded = _expandedIndex == i;
                  return _ReservationCard(
                    item: item,
                    expanded: expanded,
                    mode: mode,
                    onTap: () => setState(
                      () => _expandedIndex = _expandedIndex == i ? -1 : i,
                    ),
                  );
                },
              ),
            ),
          ],
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
          onPressed: () {},
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
              decoration: const BoxDecoration(
                color: Color(0xFF1F1F1F),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(
                    label: 'Casa',
                    activeAsset: 'assets/icons/home_active.svg',
                    inactiveAsset: 'assets/icons/home_inactive.svg',
                    selected: currentIndex == 0,
                    onTap: () => onTap(0),
                  ),
                  _NavItem(
                    label: 'Prenotazione',
                    activeAsset: 'assets/icons/reservation_active.svg',
                    inactiveAsset: 'assets/icons/reservation_inactive.svg',
                    selected: currentIndex == 1,
                    onTap: () => onTap(1),
                  ),
                  const SizedBox(width: 58),
                  _NavItem(
                    label: 'Profilo',
                    activeAsset: 'assets/icons/profile_active.svg',
                    inactiveAsset: 'assets/icons/profile_inactive.svg',
                    selected: currentIndex == 3,
                    onTap: () => onTap(3),
                  ),
                  _NavItem(
                    label: 'Contatto',
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
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF2F2F2) : const Color(0xFF3A3A3A),
          borderRadius: BorderRadius.circular(26),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                color: selected
                    ? const Color(0xFF0B0B0B)
                    : const Color(0xFF8E8E8E),
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color:
                    selected ? const Color(0xFF0B0B0B) : const Color(0xFF2B2B2B),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                count,
                style: GoogleFonts.inter(
                  color: selected
                      ? const Color(0xFFF2F2F2)
                      : const Color(0xFF8E8E8E),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
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
    final statusLabel = switch (mode) {
      _ReservationMode.upcoming => 'Confermato',
      _ReservationMode.completed => 'Completato',
      _ReservationMode.cancelled => 'Annullata',
    };
    final showDelete = mode == _ReservationMode.upcoming;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2B2B2B),
        borderRadius: BorderRadius.circular(22),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      item.imageAsset,
                      width: 52,
                      height: 52,
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
                            color: const Color(0xFFEDEDED),
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${item.subtitle}  •  ${item.dateText}',
                          style: GoogleFonts.inter(
                            color: const Color(0xFFBDBDBD),
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.price,
                          style: GoogleFonts.inter(
                            color: const Color(0xFFEDEDED),
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(height: 1, color: const Color(0xFF3A3A3A)),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
              child: Row(
                children: [
                  _SmallChip(label: statusLabel),
                  const Spacer(),
                  if (item.recurring)
                    _SmallChip(
                      label: 'Ricorrente',
                      trailing: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 18,
                        color: Color(0xFFBDBDBD),
                      ),
                    ),
                  const SizedBox(width: 12),
                  if (showDelete)
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE24B4B),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.delete_rounded,
                          color: Colors.white, size: 18),
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF232323),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              color: const Color(0xFFBDBDBD),
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 6),
            trailing!,
          ],
        ],
      ),
    );
  }
}

class _HomeDivider extends StatelessWidget {
  const _HomeDivider();

  @override
  Widget build(BuildContext context) =>
      Container(height: 1, color: const Color(0xFF3A3A3A));
}

class _ReservationRecurrence extends StatelessWidget {
  const _ReservationRecurrence();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.autorenew_rounded,
                color: Color(0xFFE6E6E6), size: 18),
            const SizedBox(width: 10),
            Text(
              'Ricorrenza mensile',
              style: GoogleFonts.inter(
                color: const Color(0xFFE6E6E6),
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const _HomeDivider(),
        const _RecurrenceRow(
          text: 'Giovedì 9 aprile 2026, ore 10:00',
          pillText: 'con Marcus Silva',
        ),
        const _HomeDivider(),
        const _RecurrenceRow(
          text: 'Giovedì 16 aprile 2026, ore 10:00',
          pillText: 'con Marcus Silva',
        ),
        const _HomeDivider(),
        const _RecurrenceAltRow(
          text: 'Giovedì 23 aprile 2026, ore 10:00',
          altText: 'Alternative Barber with James Martinez',
        ),
        const _HomeDivider(),
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
                    color: const Color(0xFFE0E0E0),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF232323),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    pillText,
                    style: GoogleFonts.inter(
                      color: const Color(0xFFBDBDBD),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
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
              size: 20,
              color: Color(0xFF8A8A8A),
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
                    color: const Color(0xFFE0E0E0),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFFB14A4A),
                      width: 1.2,
                    ),
                  ),
                  child: Text(
                    altText,
                    style: GoogleFonts.inter(
                      color: const Color(0xFFE6E6E6),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
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
              size: 20,
              color: Color(0xFF8A8A8A),
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

enum _ReservationMode { upcoming, completed, cancelled }

