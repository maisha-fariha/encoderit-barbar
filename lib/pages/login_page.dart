import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../gen/l10n/app_localizations.dart';

import '../controllers/auth_controller.dart';
import '../routes/app_pages.dart';
import '../widgets/auth_bottom_sheet.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  bool _looksLikeEmail(String value) {
    final v = value.trim();
    if (v.isEmpty) return false;
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v);
  }

  String? _validateEmail(String? value) {
    final v = value?.trim() ?? '';
    final l10n = AppLocalizations.of(context)!;
    if (v.isEmpty) return l10n.enterYourEmail;
    if (!_looksLikeEmail(v)) return l10n.invalidEmail;
    return null;
  }

  String? _validatePassword(String? value) {
    final v = value ?? '';
    final l10n = AppLocalizations.of(context)!;
    if (v.isEmpty) return l10n.enterPassword;
    if (v.length < 6) return l10n.minChars6;
    return null;
  }

  void _submitLogin() {
    FocusScope.of(context).unfocus();
    final auth = Get.find<AuthController>();
    auth.login(_email.text.trim(), _password.text);
  }

  Widget _loginButton() {
    return Obx(() {
      final auth = Get.find<AuthController>();
      return _PrimaryLoginButton(
        onPressed: auth.isBusy.value ? null : _submitLogin,
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
            child: Image.asset('assets/images/login_bg.jpg', fit: BoxFit.cover),
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
                final usePhoneLayout = w < 600 && h >= 650;

                // Phone/portrait layout: keep original look (form pushed down).
                if (usePhoneLayout) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            const SizedBox(height: 28),
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
                            const SizedBox(height: 18),
                            Text(
                              l10n.loginTitle,
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
                              l10n.loginSubtitle,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                color: Colors.white.withValues(alpha: 0.50),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                _GlassTextField(
                                  controller: _email,
                                  hintText: l10n.emailHint,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  validator: _validateEmail,
                                ),
                                const SizedBox(height: 16),
                                _GlassTextField(
                                  controller: _password,
                                  hintText: l10n.passwordHint,
                                  obscureText: _obscure,
                                  textInputAction: TextInputAction.done,
                                  validator: _validatePassword,
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
                                const SizedBox(height: 16),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 6),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      onTap: () => AuthBottomSheet.showForgotPassword(context),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                                        child: Text(
                                          l10n.forgotPassword,
                                          style: GoogleFonts.inter(
                                            color: Color(0xFF797979),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                            height: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                _loginButton(),
                                const SizedBox(height: 24),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      l10n.dontHaveAccount,
                                      style: GoogleFonts.inter(
                                        color: Color(0xFF797979),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Get.toNamed(AppRoutes.register),
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 0,
                                        ),
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: Text(
                                        l10n.signUp,
                                        style: GoogleFonts.inter(
                                          color: Color(0xFFDDDDDD),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10 + pad.bottom),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                // Tablet/landscape layout: overflow-safe + centered with max width.
                final topPad = h < 600 ? 18.0 : 28.0;
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: isWide ? 560 : double.infinity,
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: topPad),
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
                            const SizedBox(height: 18),
                            Text(
                              l10n.loginTitle,
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
                              l10n.loginSubtitle,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                color: Colors.white.withValues(alpha: 0.50),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: h < 600 ? 22 : 56),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: isWide ? 24 : 18,
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                  _GlassTextField(
                                    controller: _email,
                                  hintText: l10n.emailHint,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    validator: _validateEmail,
                                  ),
                                  const SizedBox(height: 16),
                                  _GlassTextField(
                                    controller: _password,
                                  hintText: l10n.passwordHint,
                                    obscureText: _obscure,
                                    textInputAction: TextInputAction.done,
                                    validator: _validatePassword,
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
                                          color: Colors.white
                                              .withValues(alpha: 0.55),
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 6),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(10),
                                        onTap: () => AuthBottomSheet.showForgotPassword(context),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                                          child: Text(
                                            l10n.forgotPassword,
                                            style: GoogleFonts.inter(
                                              color: Color(0xFF797979),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                              height: 1,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  _loginButton(),
                                  const SizedBox(height: 24),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        l10n.dontHaveAccount,
                                        style: GoogleFonts.inter(
                                          color: Color(0xFF797979),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Get.toNamed(AppRoutes.register),
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 0,
                                          ),
                                          minimumSize: Size.zero,
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          foregroundColor: Colors.white,
                                        ),
                                        child: Text(
                                          l10n.signUp,
                                          style: GoogleFonts.inter(
                                            color: Color(0xFFDDDDDD),
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10 + pad.bottom),
                                  ],
                                ),
                              ),
                            ),
                          ],
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
    final border = Colors.white.withValues(alpha: 0.15);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        obscureText: obscureText,
        style: GoogleFonts.inter(color: text, fontWeight: FontWeight.w600, fontSize: 14),
        cursorColor: Colors.white,
        autocorrect: false,
        enableSuggestions: false,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.inter(color: hint, fontWeight: FontWeight.w400, fontSize: 14),
          border: InputBorder.none,
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

class _PrimaryLoginButton extends StatelessWidget {
  const _PrimaryLoginButton({required this.onPressed});

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
            AppLocalizations.of(context)!.logIn,
            style: GoogleFonts.inter(
              color: Color(0xFF0B0B0B),
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
