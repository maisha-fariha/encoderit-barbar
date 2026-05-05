import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gems_responsive/gems_responsive.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
    final hPad = ResponsiveHelper.getResponsiveValue<double>(
      context,
      small: 18,
      medium: 22,
      large: 28,
    );
    final maxWidth = ResponsiveHelper.getResponsiveValue<double>(
      context,
      small: 520,
      large: 680,
    );
    final fontScale = ResponsiveHelper.getResponsiveValue<double>(
      context,
      small: 1.0,
      medium: 1.08,
      large: 1.22,
    );
    final avatarSize = ResponsiveHelper.getResponsiveValue<double>(
      context,
      small: 150,
      large: 180,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 68,
        flexibleSpace: SafeArea(
          bottom: false,
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Padding(
                padding: EdgeInsets.fromLTRB(hPad, 16, hPad, 0),
                child: Row(
                  children: [
                    InkResponse(
                      radius: 30,
                      onTap: () => Get.back(),
                      child: SvgPicture.asset(
                        'assets/icons/back_button.svg',
                        width: 20,
                        height: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Profilo',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 18 * fontScale,
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 70 + media.padding.bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 18),
                  Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: avatarSize,
                          height: avatarSize,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: const Color(0xFFDDDDDD), width: 2),
                            image:  DecorationImage(
                              image: const AssetImage('assets/images/profile.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 5,
                          bottom: 5,
                          child: Container(
                            width: ResponsiveHelper.getResponsiveValue<double>(
                              context,
                              small: 34,
                              large: 40,
                            ),
                            height: ResponsiveHelper.getResponsiveValue<double>(
                              context,
                              small: 34,
                              large: 40,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFF797979).withValues(alpha: 0.50),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SvgPicture.asset('assets/icons/edit.svg', width: 20),
                            )
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF242424),
                      borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
                    ),
                    padding: EdgeInsets.fromLTRB(hPad, 30, hPad, 30),
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
                        const _TextFieldBox(text: '16 Agosto 1988', trailing: Icons.calendar_today_outlined),
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
                        const SizedBox(height: 30),
                        SizedBox(
                          height: 48,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F2F2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: () => Get.offAllNamed(AppRoutes.login),
                              child:  Text(
                                'Logout',
                                style: GoogleFonts.inter(
                                  color: Color(0xFF000000),
                                  fontSize: 16 * fontScale,
                                  fontWeight: FontWeight.w600,
                                  height: 1,
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
              style: TextStyle(
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

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final fontScale = ResponsiveHelper.getResponsiveValue<double>(
      context,
      small: 1.0,
      medium: 1.08,
      large: 1.22,
    );
    return Text(
      text,
      style:  GoogleFonts.inter(
        color: Color(0xFFDDDDDD),
        fontSize: 14 * fontScale,
        fontWeight: FontWeight.w700,
        height: 1.5,
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
    final fontScale = ResponsiveHelper.getResponsiveValue<double>(
      context,
      small: 1.0,
      medium: 1.08,
      large: 1.22,
    );
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        16,
        (lines > 1 ? 14 : 15) * fontScale,
        16,
        (lines > 1 ? 14 : 15) * fontScale,
      ),
      decoration: BoxDecoration(
        color: muted ? Color(0xFFFFFFFF).withValues(alpha: 0.05) : Color(0xFFFFFFFF).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: muted ? Color(0xFFFFFFFF).withValues(alpha: 0.10) : Color(0xFFFFFFFF).withValues(alpha: 0.15), width: 1)
      ),
      child: Row(
        crossAxisAlignment: lines > 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              text,
              maxLines: lines,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                color: muted ? Color(0xFFFFFFFF).withValues(alpha: 0.30) : Color(0xFFFFFFFF),
                fontSize: 16 * fontScale,
                height: 1,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 10),
            Icon(trailing, color: const Color(0xFFB7B7B7), size: 18 * fontScale),
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
    final fontScale = ResponsiveHelper.getResponsiveValue<double>(
      context,
      small: 1.0,
      medium: 1.08,
      large: 1.22,
    );
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, 15 * fontScale, 16, 15 * fontScale),
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFFFFFFF).withValues(alpha: 0.15), width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                color: Color(0xFFFFFFFF),
                fontSize: 16 * fontScale,
                fontWeight: FontWeight.w500,
                height: 1,
              ),
            ),
          ),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            color: const Color(0xFF797979),
            size: 20 * fontScale,
          ),
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
    final fontScale = ResponsiveHelper.getResponsiveValue<double>(
      context,
      small: 1.0,
      medium: 1.08,
      large: 1.22,
    );
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, 15 * fontScale, 16, 15 * fontScale),
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFFFFFFF).withValues(alpha: 0.15), width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              obscure ? '******' : 'password',
              style: GoogleFonts.inter(
                color: Color(0xFFFFFFFF),
                fontSize: 16 * fontScale,
                fontWeight: FontWeight.w500,
                height: 1.0,
              ),
            ),
          ),
          InkResponse(
            radius: 16 * fontScale,
            onTap: onToggle,
            child: Icon(
              obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: Color(0xFF999999),
              size: 16 * fontScale,
            ),
          ),
        ],
      ),
    );
  }
}
