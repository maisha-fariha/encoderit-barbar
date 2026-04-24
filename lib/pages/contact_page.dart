import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_pages.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  int _navIndex = 4; // Contatto selected

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _subject = TextEditingController();
  final _message = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _subject.dispose();
    _message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final w = media.size.width;
    final hPad = w >= 900 ? 24.0 : 18.0;
    final maxWidth = w >= 900 ? 560.0 : 520.0;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(hPad, 10, hPad, 140 + media.padding.bottom),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      InkResponse(
                        radius: 24,
                        onTap: () => Get.back(),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Contattaci',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _MapPreviewCard(),
                  const SizedBox(height: 14),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF2B2B2B),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.35),
                          blurRadius: 18,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const _SectionHeader(icon: Icons.location_on_outlined, title: 'Indirizzo'),
                        const SizedBox(height: 10),
                        const Text(
                          'P.za della Signoria,\n50122 Firenze FI,\nItalia',
                          style: TextStyle(
                            color: Color(0xFFEDEDED),
                            fontSize: 13,
                            height: 1.25,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const _InsetDividerLine(),
                        const SizedBox(height: 14),
                        const _SectionHeader(
                          icon: Icons.info_outline_rounded,
                          title: 'Informazioni di collegamento',
                        ),
                        const SizedBox(height: 14),
                        const _InfoRow(icon: Icons.phone_rounded, value: '+390552768325'),
                        const SizedBox(height: 12),
                        const _InfoRow(icon: Icons.mail_rounded, value: 'yourmail@mail.com'),
                        const SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFF0B0B0B),
                                Color(0xFF111111),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(color: const Color(0xFF1F1F1F), width: 1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.55),
                                blurRadius: 30,
                                offset: const Offset(0, 18),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.work_outline_rounded,
                                    color: Color(0xFFB7B7B7),
                                    size: 18,
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'Contattaci',
                                    style: TextStyle(
                                      color: Color(0xFFB7B7B7),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.1,
                                    ),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                              const SizedBox(height: 12),
                              const _InsetDividerLine(darker: true),
                              const SizedBox(height: 16),
                              const _FormLabel('Nome'),
                              const SizedBox(height: 8),
                              _InputBox(controller: _name, hint: 'Inserisci il tuo nome'),
                              const SizedBox(height: 14),
                              const _FormLabel('E-mail'),
                              const SizedBox(height: 8),
                              _InputBox(controller: _email, hint: 'Inserisci la tua email'),
                              const SizedBox(height: 14),
                              const _FormLabel('Soggetta'),
                              const SizedBox(height: 8),
                              _InputBox(
                                controller: _subject,
                                hint: 'Inserisci il tuo argomento',
                              ),
                              const SizedBox(height: 14),
                              const _FormLabel('Massaggio'),
                              const SizedBox(height: 8),
                              _InputBox(
                                controller: _message,
                                hint: 'Scrivi qualcosa...',
                                maxLines: 4,
                              ),
                              const SizedBox(height: 18),
                              SizedBox(
                                height: 54,
                                child: Material(
                                  color: const Color(0xFFF2F2F2),
                                  elevation: 0,
                                  shadowColor: Colors.black.withValues(alpha: 0.35),
                                  borderRadius: BorderRadius.circular(28),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(28),
                                    onTap: () => FocusScope.of(context).unfocus(),
                                    child: const Center(
                                      child: Text(
                                        'Invia il tuo messaggio',
                                        style: TextStyle(
                                          color: Color(0xFF0B0B0B),
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
        currentIndex: _navIndex,
        onTap: (i) {
          setState(() => _navIndex = i);
          if (i == 0) {
            Get.offAllNamed(AppRoutes.home);
          }
          if (i == 1) {
            Get.toNamed(AppRoutes.reservations);
          }
          if (i == 3) {
            Get.toNamed(AppRoutes.profile);
          }
          if (i == 4) {
            // already on contact
          }
        },
      ),
    );
  }
}

class _MapPreviewCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        height: 140,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/onboarding_1.png',
              fit: BoxFit.cover,
              color: Colors.black.withValues(alpha: 0.05),
              colorBlendMode: BlendMode.darken,
            ),
            Positioned(
              left: 10,
              top: 10,
              child: Container(
                width: 230,
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.94),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Palazzo Vecchio',
                      style: TextStyle(
                        color: Color(0xFF1A1A1A),
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'P.za della Signoria, 50122...',
                      style: TextStyle(
                        color: Color(0xFF3A3A3A),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star_rounded, color: Color(0xFF1A1A1A), size: 14),
                        SizedBox(width: 4),
                        Text(
                          '4.7',
                          style: TextStyle(
                            color: Color(0xFF1A1A1A),
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 6),
                        Text(
                          '(21.80)',
                          style: TextStyle(
                            color: Color(0xFF4A4A4A),
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Center(
              child: Icon(Icons.location_pin, color: Color(0xFFD83A3A), size: 34),
            ),
          ],
        ),
      ),
    );
  }
}

class _InputBox extends StatelessWidget {
  const _InputBox({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String hint;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final isMultiline = maxLines > 1;
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFF6F6F6F),
          fontWeight: FontWeight.w600,
        ),
        filled: true,
        fillColor: const Color(0xFF151515),
        contentPadding: EdgeInsets.fromLTRB(16, isMultiline ? 14 : 16, 16, isMultiline ? 14 : 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2B2B2B), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2B2B2B), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3A3A3A), width: 1.2),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFB7B7B7), size: 18),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFFB7B7B7),
            fontSize: 13,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }
}

class _InsetDividerLine extends StatelessWidget {
  const _InsetDividerLine({this.darker = false});
  final bool darker;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Container(
        height: 1,
        color: darker ? const Color(0xFF1E1E1E) : const Color(0xFF3A3A3A),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFB7B7B7), size: 18),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Color(0xFFEDEDED),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _FormLabel extends StatelessWidget {
  const _FormLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFFEDEDED),
        fontSize: 12,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.15,
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
              style: TextStyle(
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
