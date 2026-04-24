import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_pages.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _obscure = true;
  int _navIndex = 3; // Profilo selected

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
                        child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Profilo',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 92,
                          height: 92,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            image: const DecorationImage(
                              image: AssetImage('assets/images/onboarding_1.png'),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.55),
                                blurRadius: 16,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: -6,
                          bottom: -6,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2C2C2C),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFF3A3A3A), width: 1),
                            ),
                            child: const Icon(Icons.edit_outlined, color: Colors.white, size: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const _FieldLabel('Nome'),
                        const SizedBox(height: 8),
                        const _TextFieldBox(text: 'Leonardo'),
                        const SizedBox(height: 14),
                        const _FieldLabel('Cognome'),
                        const SizedBox(height: 8),
                        const _TextFieldBox(text: 'Rossi'),
                        const SizedBox(height: 14),
                        const _FieldLabel('Data di nascita'),
                        const SizedBox(height: 8),
                        const _TextFieldBox(text: '16 Agosto 1988', trailing: Icons.calendar_month_outlined),
                        const SizedBox(height: 14),
                        const _FieldLabel('Numero di Telefono'),
                        const SizedBox(height: 8),
                        const _TextFieldBox(text: '+390552768325'),
                        const SizedBox(height: 14),
                        const _FieldLabel('Email'),
                        const SizedBox(height: 8),
                        const _TextFieldBox(text: 'yourmail@mail.com', muted: true),
                        const SizedBox(height: 14),
                        const _FieldLabel('Indirizzo'),
                        const SizedBox(height: 8),
                        const _TextFieldBox(
                          text: 'P.za della Signoria,\n50122 Firenze FI,\nItalia',
                          lines: 3,
                        ),
                        const SizedBox(height: 14),
                        const _FieldLabel('CAP (zip code)'),
                        const SizedBox(height: 8),
                        const _TextFieldBox(text: '50122'),
                        const SizedBox(height: 14),
                        const _FieldLabel('Comune'),
                        const SizedBox(height: 8),
                        const _SelectFieldBox(text: 'Milan (Milano)'),
                        const SizedBox(height: 14),
                        const _FieldLabel('Provincia'),
                        const SizedBox(height: 8),
                        const _SelectFieldBox(text: 'Lombardy'),
                        const SizedBox(height: 14),
                        const _FieldLabel('Nazione'),
                        const SizedBox(height: 8),
                        const _SelectFieldBox(text: 'Italia'),
                        const SizedBox(height: 14),
                        const _FieldLabel('Password'),
                        const SizedBox(height: 8),
                        _PasswordFieldBox(
                          obscure: _obscure,
                          onToggle: () => setState(() => _obscure = !_obscure),
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
            // already on profile
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

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFFB7B7B7),
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
      ),
    );
  }
}

class _TextFieldBox extends StatelessWidget {
  const _TextFieldBox({
    required this.text,
    this.trailing,
    this.lines = 1,
    this.muted = false,
  });

  final String text;
  final IconData? trailing;
  final int lines;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14, lines > 1 ? 12 : 14, 14, lines > 1 ? 12 : 14),
      decoration: BoxDecoration(
        color: const Color(0xFF3A3A3A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: lines > 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              text,
              maxLines: lines,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: muted ? const Color(0xFF8E8E8E) : Colors.white,
                fontSize: 13,
                height: 1.25,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 10),
            Icon(trailing, color: const Color(0xFFB7B7B7), size: 18),
          ],
        ],
      ),
    );
  }
}

class _SelectFieldBox extends StatelessWidget {
  const _SelectFieldBox({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: const Color(0xFF3A3A3A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFFB7B7B7), size: 22),
        ],
      ),
    );
  }
}

class _PasswordFieldBox extends StatelessWidget {
  const _PasswordFieldBox({required this.obscure, required this.onToggle});

  final bool obscure;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: const Color(0xFF3A3A3A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              obscure ? '******' : 'password',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              ),
            ),
          ),
          InkResponse(
            radius: 20,
            onTap: onToggle,
            child: Icon(
              obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: const Color(0xFFB7B7B7),
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}
