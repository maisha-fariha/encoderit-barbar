import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gems_responsive/gems_responsive.dart';
import '../gen/l10n/app_localizations.dart';

enum _AuthSheetStep { forgot, otp, reset }

class AuthBottomSheet {
  AuthBottomSheet._();

  static Future<void> showForgotPassword(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.65),
      builder: (context) => const _AuthFlowSheet(),
    );
  }
}

class _AuthFlowSheet extends StatefulWidget {
  const _AuthFlowSheet();

  @override
  State<_AuthFlowSheet> createState() => _AuthFlowSheetState();
}

class _AuthFlowSheetState extends State<_AuthFlowSheet> {
  _AuthSheetStep _step = _AuthSheetStep.forgot;

  final _email = TextEditingController();
  final _otp = TextEditingController();
  final _newPassword = TextEditingController();
  final _confirmPassword = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _otp.dispose();
    _newPassword.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  void _next() {
    final l10n = AppLocalizations.of(context)!;
    FocusScope.of(context).unfocus();

    switch (_step) {
      case _AuthSheetStep.forgot:
        final email = _email.text.trim();
        if (email.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.enterYourEmail)),
          );
          return;
        }
        setState(() => _step = _AuthSheetStep.otp);
        return;
      case _AuthSheetStep.otp:
        final code = _otp.text.trim();
        if (code.length < 4) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.otpInvalid)),
          );
          return;
        }
        setState(() => _step = _AuthSheetStep.reset);
        return;
      case _AuthSheetStep.reset:
        final p1 = _newPassword.text;
        final p2 = _confirmPassword.text;
        if (p1.length < 6) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.minChars6)),
          );
          return;
        }
        if (p1 != p2) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.passwordsDoNotMatch)),
          );
          return;
        }
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.passwordResetSuccess)),
        );
        return;
    }
  }

  void _back() {
    FocusScope.of(context).unfocus();
    setState(() {
      _step = switch (_step) {
        _AuthSheetStep.forgot => _AuthSheetStep.forgot,
        _AuthSheetStep.otp => _AuthSheetStep.forgot,
        _AuthSheetStep.reset => _AuthSheetStep.otp,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final fontScale = ResponsiveHelper.getResponsiveValue<double>(
      context,
      small: 1.0,
      medium: 1.08,
      large: 1.22,
    );
    final media = MediaQuery.of(context);

    final (title, subtitle, cta) = switch (_step) {
      _AuthSheetStep.forgot => (
          l10n.forgotPasswordTitle,
          l10n.forgotPasswordSheetSubtitle,
          l10n.sendOtp,
        ),
      _AuthSheetStep.otp => (
          l10n.verifyOtpTitle,
          l10n.verifyOtpSubtitle,
          l10n.verify,
        ),
      _AuthSheetStep.reset => (
          l10n.resetPasswordTitle,
          l10n.resetPasswordSubtitle,
          l10n.resetPasswordCta,
        ),
    };

    return Padding(
      padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: ResponsiveHelper.getResponsiveValue<double>(
              context,
              small: double.infinity,
              large: 680,
            ),
          ),
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            decoration: BoxDecoration(
              color: const Color(0xFF242424),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: const Color(0xFF185C5C),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 46,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF).withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _step == _AuthSheetStep.forgot ? null : _back,
                        icon: SvgPicture.asset(
                          'assets/icons/back_button.svg',
                          color: _step == _AuthSheetStep.forgot
                              ? Colors.white.withValues(alpha: 0.25)
                              : Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 18 * fontScale,
                            fontWeight: FontWeight.w800,
                            height: 1.1,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.close_rounded,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: Colors.white.withValues(alpha: 0.55),
                      fontSize: 13 * fontScale,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    child: _stepBody(context, fontScale),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEEEEE),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onPressed: _next,
                        child: Text(
                          cta,
                          style: GoogleFonts.inter(
                            color: const Color(0xFF0B0B0B),
                            fontSize: 15 * fontScale,
                            fontWeight: FontWeight.w700,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_step == _AuthSheetStep.otp)
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.otpResent)),
                        );
                      },
                      child: Text(
                        l10n.resendCode,
                        style: GoogleFonts.inter(
                          color: const Color(0xFFDDDDDD),
                          fontSize: 13 * fontScale,
                          fontWeight: FontWeight.w600,
                          height: 1,
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
  }

  Widget _stepBody(BuildContext context, double fontScale) {
    final l10n = AppLocalizations.of(context)!;
    switch (_step) {
      case _AuthSheetStep.forgot:
        return _SheetField(
          key: const ValueKey('forgot'),
          controller: _email,
          hint: l10n.emailHint,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icons.mail_outline_rounded,
        );
      case _AuthSheetStep.otp:
        return _SheetField(
          key: const ValueKey('otp'),
          controller: _otp,
          hint: l10n.otpHint,
          keyboardType: TextInputType.number,
          prefixIcon: Icons.verified_outlined,
        );
      case _AuthSheetStep.reset:
        return Column(
          key: const ValueKey('reset'),
          children: [
            _SheetField(
              controller: _newPassword,
              hint: l10n.newPassword,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              prefixIcon: Icons.lock_outline_rounded,
            ),
            const SizedBox(height: 12),
            _SheetField(
              controller: _confirmPassword,
              hint: l10n.confirmPassword,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              prefixIcon: Icons.lock_outline_rounded,
            ),
          ],
        );
    }
  }
}

class _SheetField extends StatelessWidget {
  const _SheetField({
    super.key,
    required this.controller,
    required this.hint,
    required this.keyboardType,
    required this.prefixIcon,
    this.obscureText = false,
  });

  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;
  final IconData prefixIcon;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    final fontScale = ResponsiveHelper.getResponsiveValue<double>(
      context,
      small: 1.0,
      medium: 1.08,
      large: 1.22,
    );
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFFFFFFF).withValues(alpha: 0.12),
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        cursorColor: Colors.white,
        style: GoogleFonts.inter(
          color: Colors.white.withValues(alpha: 0.80),
          fontSize: 14 * fontScale,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: GoogleFonts.inter(
            color: Colors.white.withValues(alpha: 0.45),
            fontSize: 14 * fontScale,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(prefixIcon, color: const Color(0xFFB7B7B7)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        ),
      ),
    );
  }
}

