import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AppoinmentPage extends StatefulWidget {
  const AppoinmentPage({super.key});

  @override
  State<AppoinmentPage> createState() => _AppoinmentPageState();
}

class _AppoinmentPageState extends State<AppoinmentPage> {
  int _selected = 0;

  final _items = const <_ServiceItem>[
    _ServiceItem(title: 'Taglio di capelli', minutes: 45, priceEuro: 45),
    _ServiceItem(title: 'Rifinitura della barba', minutes: 30, priceEuro: 30),
    _ServiceItem(title: 'Capelli + Barba', minutes: 60, priceEuro: 65),
    _ServiceItem(title: 'Trattamento premium', minutes: 90, priceEuro: 120),
    _ServiceItem(
      title: 'Rasatura con asciugamano caldo',
      minutes: 45,
      priceEuro: 50,
    ),
    _ServiceItem(title: 'Taglio di capelli per bambini', minutes: 30, priceEuro: 35),
  ];

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.paddingOf(context);
    final isWide = MediaQuery.sizeOf(context).width >= 600;
    final scale = isWide ? 1.12 : 1.0;
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
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Prenota un appuntamento',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 18 * scale,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad + 4, vertical: 8),
                  child: Row(
                    children: List.generate(4, (i) {
                      final active = i == 0;
                      return Expanded(
                        child: Container(
                          height: 5,
                          margin: EdgeInsets.only(right: i == 3 ? 0 : 10),
                          decoration: BoxDecoration(
                            color: active
                                ? const Color(0xFFEDEDED)
                                : const Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
            Padding(
              padding: EdgeInsets.fromLTRB(hPad + 4, 10, hPad + 4, 14),
                  child: Row(
                    children: [
                      Text(
                        'Seleziona il servizio',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 18 * scale,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Fase 1 di 4',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF9A9A9A),
                          fontSize: 12 * scale,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
            Expanded(
              child: ListView.separated(
                    padding: EdgeInsets.fromLTRB(hPad, 0, hPad, 18),
                    itemCount: _items.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, i) {
                      final item = _items[i];
                      final selected = i == _selected;
                      return _ServiceCard(
                        item: item,
                        selected: selected,
                        onTap: () => setState(() => _selected = i),
                      );
                    },
                  ),
                ),
            Padding(
              padding: EdgeInsets.fromLTRB(hPad, 6, hPad, 10 + pad.bottom),
                  child: SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: const Color(0xFF2B2B2B),
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Center(
                        child: Text(
                          'Continuare',
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
          ],
        ),
      ),
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
    final bg = selected ? const Color(0xFFF2F2F2) : const Color(0xFF2B2B2B);
    final title = selected ? const Color(0xFF0B0B0B) : Colors.white;
    final sub = selected ? const Color(0xFF2C2C2C) : const Color(0xFFBDBDBD);
    final price = selected ? const Color(0xFF0B0B0B) : Colors.white;
    final scale = MediaQuery.sizeOf(context).width >= 600 ? 1.12 : 1.0;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(18),
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
                      fontSize: 15.5 * scale,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${item.minutes} minuti',
                    style: GoogleFonts.inter(
                      color: sub,
                      fontSize: 13 * scale,
                      fontWeight: FontWeight.w500,
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
                    fontSize: 18 * scale,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
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
      return Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF0B0B0B), width: 2),
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Icon(
            Icons.check_rounded,
            size: 18,
            color: Color(0xFF0B0B0B),
          ),
        ),
      );
    }
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF6B6B6B), width: 2),
        shape: BoxShape.circle,
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

