import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// First letter of [name] for avatar placeholders (e.g. "Khaled" → "K").
String avatarInitialFromName(String? name) {
  final trimmed = (name ?? '').trim();
  if (trimmed.isEmpty) return '?';
  return String.fromCharCode(trimmed.runes.first).toUpperCase();
}

/// Letter placeholder used when no profile photo is available.
class InitialsAvatar extends StatelessWidget {
  const InitialsAvatar({
    super.key,
    required this.initial,
    this.fontSize,
    this.backgroundColor = const Color(0xFFEDEDED),
    this.foregroundColor = const Color(0xFF0B0B0B),
  });

  final String initial;
  final double? fontSize;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor,
      child: Center(
        child: Text(
          initial.isEmpty ? '?' : initial,
          style: GoogleFonts.inter(
            color: foregroundColor,
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
        ),
      ),
    );
  }
}
