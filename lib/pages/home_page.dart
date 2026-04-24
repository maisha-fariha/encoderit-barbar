import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../routes/app_pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tab = 0;
  int _expandedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.paddingOf(context);
    final isWide = MediaQuery.sizeOf(context).width >= 600;
    final hPad = isWide ? 28.0 : 18.0;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(hPad, 10, hPad, 140 + pad.bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: const Color(0xFF2B2B2B),
                    backgroundImage:
                        const AssetImage('assets/images/onboarding_1.png'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Leonardo',
                          style: GoogleFonts.inter(
                            color: const Color(0xFFEDEDED),
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'ID n.: 5630',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF8E8E8E),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '30',
                        style: GoogleFonts.inter(
                          color: const Color(0xFFEDEDED),
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Prenotazioni',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF8E8E8E),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _UpcomingCard(
                expandedIndex: _expandedIndex,
                onToggle: (i) => setState(
                  () => _expandedIndex = _expandedIndex == i ? -1 : i,
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                height: 56,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.35),
                        blurRadius: 28,
                        offset: const Offset(0, 18),
                      ),
                    ],
                  ),
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      'Prenotazione di un servizio',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF0B0B0B),
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: 58,
        height: 58,
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: const Color(0xFF3A3A3A),
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
  const _UpcomingCard({required this.expandedIndex, required this.onToggle});

  final int expandedIndex;
  final ValueChanged<int> onToggle;

  @override
  Widget build(BuildContext context) {
    final items = const <_UpcomingItem>[
      _UpcomingItem(
        title: 'Taglio di capelli',
        subtitle: 'con Silva',
        dateText: '12 aprile 2026, 14:30',
        imageAsset: 'assets/images/onboarding_1.png',
        hasRecurrence: true,
      ),
      _UpcomingItem(
        title: 'Rifinitura della barba',
        subtitle: 'con Rossi',
        dateText: '12 aprile 2026, 14:30',
        imageAsset: 'assets/images/onboarding_1.png',
        hasRecurrence: false,
      ),
      _UpcomingItem(
        title: 'Capelli + Barba',
        subtitle: 'con David',
        dateText: '12 aprile 2026, 14:30',
        imageAsset: 'assets/images/onboarding_1.png',
        hasRecurrence: false,
      ),
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2B2B2B),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Prossimo appuntamento',
            style: GoogleFonts.inter(
              color: const Color(0xFFEDEDED),
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
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
      ),
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: const Color(0xFF3A3A3A),
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      item.imageAsset,
                      width: 44,
                      height: 44,
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
                            fontSize: 13.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${item.subtitle}   •   ${item.dateText}',
                          style: GoogleFonts.inter(
                            color: const Color(0xFFBDBDBD),
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: const Color(0xFFBDBDBD),
                    size: 22,
                  ),
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
                children: const [
                  _HomeDivider(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(14, 12, 14, 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.autorenew_rounded,
                          color: Color(0xFFE6E6E6),
                          size: 18,
                        ),
                        SizedBox(width: 10),
                        Text('Ricorrenza mensile'),
                      ],
                    ),
                  ),
                  _HomeDivider(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
                    child: _RecurrenceRow(
                      text: 'Giovedì 9 aprile 2026, ore 10:00',
                      pillText: 'con Marcus Silva',
                    ),
                  ),
                  _HomeDivider(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
                    child: _RecurrenceRow(
                      text: 'Giovedì 16 aprile 2026, ore 10:00',
                      pillText: 'con Marcus Silva',
                    ),
                  ),
                  _HomeDivider(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
                    child: _RecurrenceAltRow(
                      text: 'Giovedì 23 aprile 2026, ore 10:00',
                      altText: 'Alternative Barber with James Martinez',
                    ),
                  ),
                  _HomeDivider(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(14, 0, 14, 6),
                    child: _RecurrenceRow(
                      text: 'Giovedì 30 aprile 2026, ore 10:00',
                      pillText: 'con Marcus Silva',
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
    return Container(height: 1, color: const Color(0xFF3A3A3A));
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

class _UpcomingItem {
  const _UpcomingItem({
    required this.title,
    required this.subtitle,
    required this.dateText,
    required this.imageAsset,
    required this.hasRecurrence,
  });

  final String title;
  final String subtitle;
  final String dateText;
  final String imageAsset;
  final bool hasRecurrence;
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
                    icon: Icons.home_rounded,
                    selected: currentIndex == 0,
                    onTap: () => onTap(0),
                  ),
                  _NavItem(
                    label: 'Prenotazione',
                    icon: Icons.calendar_month_rounded,
                    selected: currentIndex == 1,
                    onTap: () => onTap(1),
                  ),
                  const SizedBox(width: 58),
                  _NavItem(
                    label: 'Profilo',
                    icon: Icons.person_rounded,
                    selected: currentIndex == 3,
                    onTap: () => onTap(3),
                  ),
                  _NavItem(
                    label: 'Contatto',
                    icon: Icons.mail_rounded,
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
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

