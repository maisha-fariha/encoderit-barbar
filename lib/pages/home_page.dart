import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gems_responsive/gems_responsive.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../gen/l10n/app_localizations.dart';

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
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFDDDDDD),
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: const Color(0xFF2B2B2B),
                        backgroundImage:
                            const AssetImage('assets/images/profile.jpg'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Leonardo',
                            style: GoogleFonts.inter(
                              color: const Color(0xFFFFFFFF),
                              fontSize: 18 * fontScale,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.idNumber('5630'),
                            style: GoogleFonts.inter(
                              color: const Color(0xFFDDDDDD),
                              fontSize: 14 * fontScale,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '30',
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
                            onPressed: () {},
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
          onPressed: () {},
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
  const _UpcomingCard({required this.expandedIndex, required this.onToggle});

  final int expandedIndex;
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
    final items = const <_UpcomingItem>[
      _UpcomingItem(
        title: 'Taglio di capelli',
        subtitle: 'con Silva',
        dateText: '12 aprile 2026, 14:30',
        imageAsset: 'assets/images/barbar_1.jpg',
        hasRecurrence: true,
      ),
      _UpcomingItem(
        title: 'Rifinitura della barba',
        subtitle: 'con Rossi',
        dateText: '12 aprile 2026, 14:30',
        imageAsset: 'assets/images/barbar_2.jpg',
        hasRecurrence: false,
      ),
      _UpcomingItem(
        title: 'Capelli + Barba',
        subtitle: 'con David',
        dateText: '12 aprile 2026, 14:30',
        imageAsset: 'assets/images/barbar_3.jpg',
        hasRecurrence: false,
      ),
    ];

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
        onTap: onTap,
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
                  const SizedBox(width: 8),
                  Icon(
                    expanded ? Icons.keyboard_arrow_up_rounded : null,
                    color: const Color(0xFF797979),
                    size: 20,
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
                          l10n.every4Weeks,
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
                  Padding(
                    padding: EdgeInsets.only(bottom: 8, left: 16, right: 16),
                    child: _RecurrenceRow(
                      text: 'Giovedì 9 aprile 2026, ore 10:00',
                      pillText: 'con Marcus Silva',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8, left: 16, right: 16),
                    child: _RecurrenceRow(
                      text: 'Giovedì 16 aprile 2026, ore 10:00',
                      pillText: 'con Marcus Silva',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8, left: 16, right: 16),
                    child: _RecurrenceAltRow(
                      text: 'Giovedì 23 aprile 2026, ore 10:00',
                      altText: 'Alternative Barber with James Martinez',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8, left: 16, right: 16),
                    child: _RecurrenceRow(
                      text: 'Giovedì 30 aprile 2026, ore 10:00',
                      pillText: 'con Marcus Silva',
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
                          l10n.fiveTimes,
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
          const SizedBox(width: 10),
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.close_rounded,
              size: 16,
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
                    color: Color(0xFFEEEEEE),
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
                    borderRadius: BorderRadius.circular(14),
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
              size: 16,
              color: Color(0xFF797979),
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
