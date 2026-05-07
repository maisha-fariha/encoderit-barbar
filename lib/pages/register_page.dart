import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../gen/l10n/app_localizations.dart';

import '../controllers/auth_controller.dart';
import '../routes/app_pages.dart';
import '../widgets/auth_bottom_sheet.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _accepted = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  bool _looksLikeEmail(String value) {
    final v = value.trim();
    if (v.isEmpty) return false;
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v);
  }

  String? _validateName(String? value) {
    final v = value?.trim() ?? '';
    final l10n = AppLocalizations.of(context)!;
    if (v.isEmpty) return l10n.enterFullName;
    if (v.length < 2) return l10n.minChars2;
    return null;
  }

  String? _validateEmail(String? value) {
    final v = value?.trim() ?? '';
    final l10n = AppLocalizations.of(context)!;
    if (v.isEmpty) return l10n.enterYourEmail;
    if (!_looksLikeEmail(v)) return l10n.invalidEmail;
    return null;
  }

  String? _validatePhone(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return null;
    final digits = RegExp(r'\d').allMatches(v).length;
    if (digits < 8) return AppLocalizations.of(context)!.invalidNumber;
    return null;
  }

  String? _validatePassword(String? value) {
    final v = value ?? '';
    final l10n = AppLocalizations.of(context)!;
    if (v.isEmpty) return l10n.enterPassword;
    if (v.length < 6) return l10n.minChars6;
    return null;
  }

  void _showTermsSnack() {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFFE8E8E8),
        content: Text(
          l10n.acceptPrivacyAndTermsSnack,
          style: GoogleFonts.inter(
            color: const Color(0xFF0B0B0B),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Future<void> _submitRegister() async {
    FocusScope.of(context).unfocus();
    if (!_accepted) {
      _showTermsSnack();
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final auth = Get.find<AuthController>();
    final email = _email.text.trim();
    final res = await auth.register(
      email: _email.text.trim(),
      password: _password.text,
      fullName: _name.text.trim(),
      phone: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
    );
    if (!mounted || !res.success) return;

    final verified = await AuthBottomSheet.showRegisterOtpVerification(
      context,
      email: email,
    );
    if (!mounted) return;
    if (verified == true) {
      auth.completeRegistrationAfterOtp();
    }
  }

  Widget _registerButton() {
    return Obx(() {
      final auth = Get.find<AuthController>();
      final l10n = AppLocalizations.of(context)!;
      return _PrimaryButton(
        label: l10n.registerTitle,
        isLoading: auth.isBusy.value,
        onPressed: auth.isBusy.value ? null : _submitRegister,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.paddingOf(context);
    final l10n = AppLocalizations.of(context)!;
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
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
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
                                l10n.registerTitle,
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
                                l10n.registerSubtitle,
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
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      _GlassTextField(
                                        controller: _name,
                                        hintText: l10n.fullNameHint,
                                        textInputAction: TextInputAction.next,
                                        validator: _validateName,
                                      ),
                                      const SizedBox(height: 16),
                                      _GlassTextField(
                                        controller: _email,
                                        hintText: l10n.emailHint,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        textInputAction: TextInputAction.next,
                                        validator: _validateEmail,
                                      ),
                                      const SizedBox(height: 16),
                                      _GlassTextField(
                                        controller: _phone,
                                        hintText: l10n.phoneHint,
                                        keyboardType: TextInputType.phone,
                                        textInputAction: TextInputAction.next,
                                        validator: _validatePhone,
                                      ),
                                      const SizedBox(height: 16),
                                      _GlassTextField(
                                        controller: _password,
                                        hintText: l10n.passwordHint,
                                        obscureText: _obscure,
                                        textInputAction: TextInputAction.done,
                                        validator: _validatePassword,
                                        suffix: Padding(
                                          padding: const EdgeInsets.only(
                                            right: 6,
                                          ),
                                          child: IconButton(
                                            onPressed: () => setState(
                                              () => _obscure = !_obscure,
                                            ),
                                            icon: Icon(
                                              _obscure
                                                  ? Icons.visibility_outlined
                                                  : Icons
                                                        .visibility_off_outlined,
                                              color: Colors.white.withValues(
                                                alpha: 0.55,
                                              ),
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 30),
                                      _registerButton(),
                                      const SizedBox(height: 24),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          InkResponse(
                                            onTap: () => setState(
                                              () => _accepted = !_accepted,
                                            ),
                                            radius: 20,
                                            child: Icon(
                                              _accepted
                                                  ? Icons.check_circle
                                                  : Icons
                                                        .radio_button_unchecked,
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
                                                  color: const Color(
                                                    0xFF797979,
                                                  ),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  height: 1.3,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: l10n.acceptThe,
                                                  ),
                                                  TextSpan(
                                                    text: l10n.privacyPolicy,
                                                    style: const TextStyle(
                                                      decoration: TextDecoration
                                                          .underline,
                                                    ),
                                                  ),
                                                  TextSpan(text: l10n.and),
                                                  TextSpan(
                                                    text: l10n.termsOfService,
                                                    style: const TextStyle(
                                                      decoration: TextDecoration
                                                          .underline,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            l10n.alreadyHaveAccount,
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 0,
                                                  ),
                                              minimumSize: Size.zero,
                                              tapTargetSize:
                                                  MaterialTapTargetSize
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
    this.validator,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final Widget? suffix;
  final String? Function(String?)? validator;

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
      child: TextFormField(
        controller: controller,
        validator: validator,
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
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          errorStyle: GoogleFonts.inter(
            color: const Color(0xFFFF8A8A),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          errorMaxLines: 3,
          isDense: true,
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
    required this.isLoading,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

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
            colors: [Color(0xFFEEEEEE), Color(0xFFEEEEEE)],
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
          onPressed: isLoading ? null : onPressed,
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Color(0xFF0B0B0B)),
                  ),
                )
              : Text(
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
