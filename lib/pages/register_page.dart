import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../routes/app_pages.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _accepted = true;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.paddingOf(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/register_bg.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.90),
                    Colors.black.withValues(alpha: 0.90),
                    Colors.black.withValues(alpha: 0.90),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final h = constraints.maxHeight;
                final w = constraints.maxWidth;
                final isWide = w >= 600;
                final isShort = h < 600;
                final topPad = isShort
                    ? 24.0
                    : isWide
                        ? 32.0
                        : 80.0;
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Padding(
                      padding: EdgeInsets.only(top: topPad),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: isWide ? 560 : double.infinity,
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: isWide ? 18 : 26),
                              SizedBox(
                                height: 58,
                                child: ClipRect(
                                  child: Align(
                                    alignment: const Alignment(0, 0.21),
                                    heightFactor: 0.21,
                                    child: Image.asset(
                                      'assets/images/app_icon.png',
                                      filterQuality: FilterQuality.high,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: isWide ? 18 : 30),
                              Text(
                                'Creare un account',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  height: 1.08,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Unisciti a noi ed esplora nuove possibilità!',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  color: Colors.white.withValues(alpha: 0.50),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(
                                height: isShort
                                    ? 28
                                    : isWide
                                        ? 28
                                        : 50,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isWide ? 24 : 18,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    _GlassTextField(
                                      controller: _name,
                                      hintText: 'Nome e cognome',
                                      textInputAction: TextInputAction.next,
                                    ),
                                    const SizedBox(height: 16),
                                    _GlassTextField(
                                      controller: _email,
                                      hintText: 'tuaemail@mail.com',
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                    ),
                                    const SizedBox(height: 16),
                                    _GlassTextField(
                                      controller: _phone,
                                      hintText: '+39 333 12 4564',
                                      keyboardType: TextInputType.phone,
                                      textInputAction: TextInputAction.next,
                                    ),
                                    const SizedBox(height: 16),
                                    _GlassTextField(
                                      controller: _password,
                                      hintText: 'Password',
                                      obscureText: _obscure,
                                      textInputAction: TextInputAction.done,
                                      suffix: Padding(
                                        padding: const EdgeInsets.only(right: 6),
                                        child: IconButton(
                                          onPressed: () => setState(
                                            () => _obscure = !_obscure,
                                          ),
                                          icon: Icon(
                                            _obscure
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                            color:
                                                Colors.white.withValues(alpha: 0.55),
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    _PrimaryButton(
                                      label: 'Creare un account',
                                      onPressed: () => Get.offNamed(AppRoutes.login),
                                    ),
                                    const SizedBox(height: 24),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        InkResponse(
                                          onTap: () => setState(
                                            () => _accepted = !_accepted,
                                          ),
                                          radius: 20,
                                          child: Icon(
                                            _accepted
                                                ? Icons.check_circle
                                                : Icons.radio_button_unchecked,
                                            size: 18,
                                            color: _accepted
                                                ? const Color(0xFFECECEC)
                                                : const Color(0xFF797979),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: RichText(
                                            text: TextSpan(
                                              style: GoogleFonts.inter(
                                                color: const Color(0xFF797979),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                height: 1.3,
                                              ),
                                              children: const [
                                                TextSpan(text: 'Accetto il '),
                                                TextSpan(
                                                  text:
                                                      'politica sulla riservatezza',
                                                  style: TextStyle(
                                                    decoration:
                                                        TextDecoration.underline,
                                                  ),
                                                ),
                                                TextSpan(text: ' e '),
                                                TextSpan(
                                                  text: 'Termini di servizio',
                                                  style: TextStyle(
                                                    decoration:
                                                        TextDecoration.underline,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 18),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Hai già un account? ',
                                          style: GoogleFonts.inter(
                                            color: const Color(0xFF797979),
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Get.offNamed(AppRoutes.login),
                                          style: TextButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 0,
                                            ),
                                            minimumSize: Size.zero,
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap,
                                            foregroundColor: Colors.white,
                                          ),
                                          child: Text(
                                            'Login',
                                            style: GoogleFonts.inter(
                                              color: const Color(0xFFDDDDDD),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8 + pad.bottom),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassTextField extends StatelessWidget {
  const _GlassTextField({
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.suffix,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    final hint = Colors.white.withValues(alpha: 0.50);
    final text = Colors.white.withValues(alpha: 0.60);
    final border = Colors.white.withValues(alpha: 0.08);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        obscureText: obscureText,
        style: GoogleFonts.inter(
          color: text,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        cursorColor: Colors.white,
        autocorrect: false,
        enableSuggestions: false,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.inter(
            color: hint,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
          suffixIcon: suffix,
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFEEEEEE),
              Color(0xFFEEEEEE),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 26,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            label,
            style: GoogleFonts.inter(
              color: const Color(0xFF0B0B0B),
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
