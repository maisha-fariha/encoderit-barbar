import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../gen/l10n/app_localizations.dart';

import '../routes/app_pages.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  Timer? _timer;
  int _index = 0;

  final _items = const <_OnboardingItem>[
    _OnboardingItem(
      imageAsset: 'assets/images/onboarding_1.png',
      title: 'onboardingTitle',
      body:
          'Lorem Ipsum è semplicemente un testo fittizio\n'
          'del settore della stampa e della composizione.\n'
          'Lorem Ipsum',
    ),
    _OnboardingItem(
      imageAsset: 'assets/images/onboarding_1.png',
      title: 'onboardingTitle',
      body:
          'Lorem Ipsum è semplicemente un testo fittizio\n'
          'del settore della stampa e della composizione.\n'
          'Lorem Ipsum',
    ),
    _OnboardingItem(
      imageAsset: 'assets/images/onboarding_1.png',
      title: 'onboardingTitle',
      body:
          'Lorem Ipsum è semplicemente un testo fittizio\n'
          'del settore della stampa e della composizione.\n'
          'Lorem Ipsum',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!mounted) return;
      final next = (_index + 1) % _items.length;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.paddingOf(context);
    final size = MediaQuery.sizeOf(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = size.width >= 600;
            final buttonMaxWidth = isWide ? 520.0 : double.infinity;
            final header = Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                children: [
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Get.offNamed(AppRoutes.register),
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 6,
                      ),
                      child: Text(
                        l10n.skip,
                        style: GoogleFonts.inter(
                          color: const Color(0xFF8E8E8E),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );

            final footer = Column(
              children: [
                _PageIndicator(count: _items.length, index: _index),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: buttonMaxWidth),
                      child: _PrimaryButton(
                        label: l10n.continueLabel,
                        onPressed: () => Get.toNamed(AppRoutes.register),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.alreadyHaveAccount,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF8E8E8E),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Get.toNamed(AppRoutes.login),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        l10n.signIn,
                        style: GoogleFonts.inter(
                          color: const Color(0xFFE7E7E7),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12 + pad.bottom),
              ],
            );

            // Always scroll-safe to eliminate any RenderFlex overflow on edge cases.
            final pageViewHeight =
                (constraints.maxHeight * (isWide ? 0.64 : 0.60)).clamp(
                  280.0,
                  isWide ? 620.0 : 520.0,
                );

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  children: [
                    header,
                    SizedBox(
                      height: pageViewHeight,
                      child: PageView.builder(
                        controller: _controller,
                        itemCount: _items.length,
                        onPageChanged: (i) => setState(() => _index = i),
                        itemBuilder: (context, i) =>
                            _OnboardingSlide(item: _items[i]),
                      ),
                    ),
                    footer,
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  const _OnboardingSlide({required this.item});

  final _OnboardingItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final h = constraints.maxHeight;
          final isShort = h < 520;

          // Cap image height to avoid overflow on landscape/tablets.
          final maxImageHeight = (isShort ? h * 0.58 : h * 0.64).clamp(
            200.0,
            520.0,
          );

          final titleStyle = GoogleFonts.inter(
            color: Colors.white,
            fontSize: isShort ? 20 : 22,
            fontWeight: FontWeight.w600,
            height: 1.15,
          );
          final bodyStyle = GoogleFonts.inter(
            color: const Color(0xFFDDDDDD),
            fontSize: isShort ? 11.5 : 12,
            fontWeight: FontWeight.w500,
            height: 1.35,
          );

          return Column(
            children: [
              SizedBox(height: isShort ? 8 : 10),
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    // Large screens: allow a bit wider slide content.
                    maxWidth: MediaQuery.sizeOf(context).width >= 600
                        ? 520
                        : double.infinity,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(26),
                    child: SizedBox(
                      height: maxImageHeight,
                      width: double.infinity,
                      child: Image.asset(item.imageAsset, fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
              SizedBox(height: isShort ? 16 : 26),
              Text(
                item.title == 'onboardingTitle'
                    ? l10n.onboardingTitle
                    : item.title,
                textAlign: TextAlign.center,
                style: titleStyle,
              ),
              SizedBox(height: isShort ? 10 : 16),
              Flexible(
                child: Text(
                  item.body,
                  textAlign: TextAlign.center,
                  style: bodyStyle,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          margin: EdgeInsets.only(right: i == count - 1 ? 0 : 8),
          height: 10,
          width: active ? 42 : 10,
          decoration: BoxDecoration(
            color: active ? const Color(0xFFDDDDDD) : Color(0xFF242424),
            borderRadius: BorderRadius.circular(99),
          ),
        );
      }),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.40),
              blurRadius: 30,
              offset: const Offset(0, 18),
            ),
          ],
        ),
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            label,
            style: GoogleFonts.inter(
              color: const Color(0xFF0B0B0B),
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardingItem {
  const _OnboardingItem({
    required this.imageAsset,
    required this.title,
    required this.body,
  });

  final String imageAsset;
  final String title;
  final String body;
}
