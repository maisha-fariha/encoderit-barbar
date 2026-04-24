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
  int _step = 1;
  int _selected = 0;
  int _selectedTime = 0;
  bool _recurringEnabled = true;
  int _recurringIndex = 0;

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
    _ServiceItem(
      title: 'Taglio di capelli per bambini',
      minutes: 30,
      priceEuro: 35,
    ),
  ];

  final _barbers = const <_BarberItem>[
    _BarberItem(
      name: 'Marcus Silva',
      subtitle: 'Barbiere',
      imageAsset: 'assets/images/barbar_1.jpg',
    ),
    _BarberItem(
      name: 'Alessandro Rossi',
      subtitle: 'Specialista in sfumature',
      imageAsset: 'assets/images/barbar_2.jpg',
    ),
    _BarberItem(
      name: 'David Chen',
      subtitle: 'Tagli classici',
      imageAsset: 'assets/images/barbar_3.jpg',
    ),
    _BarberItem(
      name: 'James Martinez',
      subtitle: 'Esperto di barba',
      imageAsset: 'assets/images/barbar_4.jpg',
    ),
  ];

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

  void _onContinue() {
    if (_step == 1) {
      setState(() {
        _step = 2;
        _selected = 0;
      });
      return;
    }
    if (_step == 2) {
      setState(() {
        _step = 3;
        _selectedTime = 0;
        _recurringEnabled = true;
        _recurringIndex = 0;
      });
      return;
    }
    if (_step == 3) {
      setState(() => _step = 4);
      return;
    }
    // Next steps can be implemented later.
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
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Material(
                    color: const Color(0xFF2B2B2B),
                    borderRadius: BorderRadius.circular(26),
                    child: Stack(
                      children: [
                        Positioned(
                          right: 14,
                          top: 14,
                          child: InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            borderRadius: BorderRadius.circular(18),
                            child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                Icons.close_rounded,
                                color: Color(0xFF8A8A8A),
                                size: 28,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(22, 26, 22, 22),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 12),
                              Container(
                                width: 86,
                                height: 86,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black.withValues(alpha: 0.12),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.shield_outlined,
                                    size: 54,
                                    color: Color(0xFFE24B4B),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 22),
                              Text(
                                'Sei sicuro?',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  color: const Color(0xFFEDEDED),
                                  fontSize: 36,
                                  fontWeight: FontWeight.w800,
                                  height: 1.05,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                'Questa azione non può essere annullata.\n'
                                'Conferma se desideri procedere.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  color: const Color(0xFFBDBDBD),
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  height: 1.35,
                                ),
                              ),
                              const SizedBox(height: 28),
                              Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 72,
                                      child: OutlinedButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                            color: Color(0xFF5A5A5A),
                                            width: 2,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              28,
                                            ),
                                          ),
                                          backgroundColor: const Color(
                                            0xFF2B2B2B,
                                          ),
                                        ),
                                        child: Text(
                                          'Cancellare',
                                          style: GoogleFonts.inter(
                                            color: const Color(0xFF6E6E6E),
                                            fontSize: 24,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: SizedBox(
                                      height: 72,
                                      child: FilledButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          if (!mounted) return;
                                          // Stay (or return) on step 4 as requested.
                                          setState(() => _step = 4);
                                        },
                                        style: FilledButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFFF2F2F2,
                                          ),
                                          foregroundColor: const Color(
                                            0xFF0B0B0B,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              28,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          'Confermare',
                                          style: GoogleFonts.inter(
                                            color: const Color(0xFF0B0B0B),
                                            fontSize: 24,
                                            fontWeight: FontWeight.w800,
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
        );
      },
    );
  }

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
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Prenota un appuntamento',
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
                children: List.generate(4, (i) {
                  final active = i < _step;
                  return Expanded(
                    child: Container(
                      height: 6,
                      margin: EdgeInsets.only(right: i == 3 ? 0 : 6),
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
              padding: EdgeInsets.fromLTRB(hPad + 4, 10, hPad + 4, 14),
              child: Row(
                children: [
                  Text(
                    _step == 1
                        ? 'Seleziona il servizio'
                        : _step == 2
                        ? 'Scegli il tuo barbiere'
                        : _step == 3
                        ? 'Scegli una data'
                        : 'Riepilogo della prenotazione',
                    style: GoogleFonts.inter(
                      color: Color(0xFFEEEEEE),
                      fontSize: 16 * scale,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _step >= 3 ? 'Passo $_step di 4' : 'Fase $_step di 4',
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
                    ? ListView.separated(
                        key: const ValueKey('services'),
                        padding: EdgeInsets.fromLTRB(hPad + 2, 8, hPad + 2, 18),
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
                      )
                    : _step == 2
                    ? GridView.builder(
                        key: const ValueKey('barbers'),
                        padding: EdgeInsets.fromLTRB(hPad, 0, hPad, 18),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              // Slightly taller tiles to avoid card overflow.
                              childAspectRatio: 0.70,
                            ),
                        itemCount: _barbers.length,
                        itemBuilder: (context, i) {
                          final item = _barbers[i];
                          final selected = i == _selected;
                          return _BarberCard(
                            item: item,
                            selected: selected,
                            onTap: () => setState(() => _selected = i),
                          );
                        },
                      )
                    : _step == 3
                    ? SingleChildScrollView(
                        key: const ValueKey('step3'),
                        padding: EdgeInsets.fromLTRB(hPad, 16, hPad, 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _Step3CalendarCard(
                              selectedTimeIndex: _selectedTime,
                              times: _times,
                              onSelectTime: (i) =>
                                  setState(() => _selectedTime = i),
                            ),
                            const SizedBox(height: 20),
                            _Step3RecurringToggle(
                              value: _recurringEnabled,
                              onChanged: (v) =>
                                  setState(() => _recurringEnabled = v),
                            ),
                            const SizedBox(height: 15),
                            if (_recurringEnabled)
                              _Step3RecurringOptions(
                                selectedIndex: _recurringIndex,
                                onSelect: (i) =>
                                    setState(() => _recurringIndex = i),
                              ),
                            const SizedBox(height: 14),
                            _Step3MonthlySummary(),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        key: const ValueKey('step4'),
                        padding: EdgeInsets.fromLTRB(hPad, 0, hPad, 18),
                        child: _Step4SummaryCard(
                          service: _items[_selected],
                          barber: _barbers[_selected],
                          time: _times[_selectedTime],
                        ),
                      ),
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
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(32),
                      onTap: _step == 4 ? _showConfirmDialog : _onContinue,
                      child: Center(
                        child: Text(
                          _step == 4
                              ? 'Conferma la prenotazione'
                              : 'Continuare',
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
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: const Color(0xFF2B2B2B),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Step4KeyValueRow(label: 'Servizio', value: service.title),
          const SizedBox(height: 14),
          _Step4KeyValueRow(label: 'Barbiera', value: barber.name),
          const SizedBox(height: 14),
          const _Step4KeyValueRow(label: 'Data', value: 'Gio, Aprile 09'),
          const SizedBox(height: 14),
          _Step4KeyValueRow(label: 'Tempo', value: '$time AM'),
          const SizedBox(height: 18),
          const _Step4Divider(),
          const SizedBox(height: 18),
          const _Step4MonthlyRecurrence(),
          const SizedBox(height: 18),
          const _Step4Divider(),
          const SizedBox(height: 18),
          Row(
            children: [
              Text(
                'Totale',
                style: GoogleFonts.inter(
                  color: const Color(0xFFE6E6E6),
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              Text(
                '€${service.priceEuro}',
                style: GoogleFonts.inter(
                  color: const Color(0xFFE6E6E6),
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
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
            color: const Color(0xFFBDBDBD),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              color: const Color(0xFFE6E6E6),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
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
    return Container(height: 2, color: const Color(0xFF3A3A3A));
  }
}

class _Step4MonthlyRecurrence extends StatelessWidget {
  const _Step4MonthlyRecurrence();

  @override
  Widget build(BuildContext context) {
    Widget row(String text, {bool muted = false, bool withPill = true}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: GoogleFonts.inter(
                      color: muted
                          ? const Color(0xFF7A7A7A)
                          : const Color(0xFFE6E6E6),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (withPill) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF232323),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        'con Marcus Silva',
                        style: GoogleFonts.inter(
                          color: const Color(0xFFBDBDBD),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              Icons.close_rounded,
              size: 22,
              color: muted ? const Color(0xFF6B6B6B) : const Color(0xFF8A8A8A),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Icon(
              Icons.autorenew_rounded,
              color: Color(0xFFE6E6E6),
              size: 18,
            ),
            const SizedBox(width: 10),
            Text(
              'Ricorrenza mensile',
              style: GoogleFonts.inter(
                color: const Color(0xFFE6E6E6),
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        row('Giovedì 9 aprile 2026, ore 10:00'),
        const _Step4Divider(),
        row('Giovedì 16 aprile 2026, ore 10:00'),
        const _Step4Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Giovedì 23 aprile 2026, ore 10:00',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF7A7A7A),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0xFFB14A4A),
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        'Alternative Barber with James Martinez',
                        style: GoogleFonts.inter(
                          color: const Color(0xFFE6E6E6),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Icon(
                Icons.close_rounded,
                size: 22,
                color: Color(0xFF6B6B6B),
              ),
            ],
          ),
        ),
        const _Step4Divider(),
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
    final scale = MediaQuery.sizeOf(context).width >= 600 ? 1.12 : 1.0;
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
    final bg = selected ? const Color(0xFFFFFFFF) : const Color(0xFF242424);
    final name = selected ? const Color(0xFF000000) : const Color(0xFFFFFFFF);
    final sub = selected ? const Color(0xFF242424) : const Color(0xFFDDDDDD);
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
                  fontSize: 16,
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
                  fontSize: 12,
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
                    'Selezionare',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF797979),
                      fontSize: 14,
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
    required this.selectedTimeIndex,
    required this.times,
    required this.onSelectTime,
  });

  final int selectedTimeIndex;
  final List<String> times;
  final ValueChanged<int> onSelectTime;

  @override
  Widget build(BuildContext context) {
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
                'Aprile 2026',
                style: GoogleFonts.inter(
                  color: const Color(0xFFDDDDDD),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
              const Spacer(),
              SvgPicture.asset('assets/icons/calendar.svg', width: 24),
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
              ],
            ),
          ),
          const SizedBox(height: 25),
          Text(
            'Seleziona la fascia oraria che preferisci',
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
    return InkWell(
      onTap: () => onChanged(!value),
      child: Row(
        children: [
          value
              ? SvgPicture.asset('assets/icons/checked_box.svg', width: 24)
              : Icon(
                  Icons.check_box_outline_blank_rounded,
                  color: Color(0xFFDDDDDD),
                  size: 24,
                ),
          const SizedBox(width: 10),
          Text(
            'Appuntamenti ricorrenti',
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
    required this.selectedIndex,
    required this.onSelect,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final options = const [
      '1 settimana',
      '2 settimane',
      '3 settimane',
      '1 mese',
      '2 mesi',
      '3 mesi',
    ];
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFF242424),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF185C5C)),
      ),
      child: Column(
        children: List.generate(options.length, (i) {
          return InkWell(
            onTap: () => onSelect(i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: i == options.length - 1
                        ? Colors.transparent
                        : const Color(0xFF797979).withValues(alpha: 0.30),
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      options[i],
                      style: GoogleFonts.inter(
                        color: const Color(0xFFE6E6E6),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _Step3MonthlySummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const lines = [
      'Giovedì 9 aprile 2026, ore 10:00',
      'Giovedì 16 aprile 2026, ore 10:00',
      'Giovedì 23 aprile 2026, ore 10:00',
      'Giovedì 30 aprile 2026, ore 10:00',
    ];
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: const Color(0xFF2B2B2B),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.autorenew_rounded,
                color: Color(0xFFEDEDED),
                size: 28,
              ),
              const SizedBox(width: 14),
              Text(
                'Ricorrenza mensile',
                style: GoogleFonts.inter(
                  color: const Color(0xFFE6E6E6),
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  height: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const _Step3Divider(),
          _Step3MonthlyRow(text: lines[0], muted: false),
          const _Step3Divider(),
          _Step3MonthlyRow(text: lines[1], muted: false),
          const _Step3Divider(),
          _Step3MonthlyRow(text: lines[2], muted: true),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFB14A4A), width: 2),
            ),
            child: Text(
              'Barbiere alternativo con James\nMartinez',
              style: GoogleFonts.inter(
                color: const Color(0xFFE6E6E6),
                fontSize: 24,
                fontWeight: FontWeight.w700,
                height: 1.25,
              ),
            ),
          ),
          const SizedBox(height: 14),
          const _Step3Divider(),
          _Step3MonthlyRow(text: lines[3], muted: false),
        ],
      ),
    );
  }
}

class _Step3MonthlyRow extends StatelessWidget {
  const _Step3MonthlyRow({required this.text, required this.muted});

  final String text;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 22),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                color: muted
                    ? const Color(0xFF7A7A7A)
                    : const Color(0xFFE6E6E6),
                fontSize: 26,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            Icons.close_rounded,
            size: 30,
            color: muted ? const Color(0xFF6B6B6B) : const Color(0xFF8A8A8A),
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
    return Container(height: 2, color: const Color(0xFF3A3A3A));
  }
}
