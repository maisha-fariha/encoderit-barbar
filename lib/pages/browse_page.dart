import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gems_responsive/gems_responsive.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/service_list_controller.dart';
import '../controllers/shop_list_controller.dart';
import '../gen/l10n/app_localizations.dart';
import '../models/service/service_model.dart';
import '../models/shop/shop_model.dart';
import '../routes/app_pages.dart';
import '../utils/service_price_visibility.dart';

/// Guest-first shops & services browse. Booking continues via login.
class BrowsePage extends StatefulWidget {
  const BrowsePage({super.key});

  @override
  State<BrowsePage> createState() => _BrowsePageState();
}

class _BrowsePageState extends State<BrowsePage> {
  late final ShopListController _shops;
  late final ServiceListController _services;
  int _selectedService = 0;

  static const _surface = Color(0xFF1C1C1E);

  @override
  void initState() {
    super.initState();
    _shops = Get.find<ShopListController>();
    _services = Get.find<ServiceListController>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await _shops.loadItems();
      final shop = _shops.selectedShop;
      if (shop != null) {
        await _services.loadByShop(shop.id);
        if (!mounted) return;
        setState(() => _selectedService = 0);
      }
    });
  }

  Future<void> _onSelectShop(int index) async {
    _shops.selectShop(index);
    final shop = _shops.selectedShop;
    if (shop == null) return;
    await _services.loadByShop(shop.id);
    if (!mounted) return;
    setState(() => _selectedService = 0);
  }

  void _startBooking() {
    Get.toNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hPad = ResponsiveHelper.getResponsiveValue<double>(
      context,
      small: 20,
      medium: 24,
      large: 32,
    );
    final maxWidth = ResponsiveHelper.getResponsiveValue<double>(
      context,
      small: 520,
      large: 720,
    );
    final fontScale = ResponsiveHelper.getResponsiveValue<double>(
      context,
      small: 1.0,
      medium: 1.08,
      large: 1.16,
    );
    final shopCardWidth = ResponsiveHelper.getResponsiveValue<double>(
      context,
      small: 260,
      medium: 280,
      large: 300,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF141414),
              Color(0xFF000000),
              Color(0xFF000000),
            ],
            stops: [0.0, 0.35, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(hPad, 8, hPad - 4, 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.browseTitle,
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 22 * fontScale,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.3,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.browseSelectShopHint,
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF9A9A9A),
                                  fontSize: 12.5 * fontScale,
                                  fontWeight: FontWeight.w500,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () => Get.toNamed(AppRoutes.login),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xFFFFFFFF)
                                .withValues(alpha: 0.08),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: const Color(0xFFFFFFFF)
                                    .withValues(alpha: 0.14),
                              ),
                            ),
                          ),
                          child: Text(
                            l10n.signIn,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 13.5 * fontScale,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.fromLTRB(0, 18, 0, 20),
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: hPad),
                          child: _SectionLabel(
                            label: l10n.shopsSection,
                            fontScale: fontScale,
                          ),
                        ),
                        const SizedBox(height: 14),
                        GetBuilder<ShopListController>(
                          id: 'shop-selection',
                          builder: (controller) {
                            if (controller.isLoading.value &&
                                controller.items.isEmpty) {
                              return const SizedBox(
                                height: 180,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFFEEEEEE),
                                  ),
                                ),
                              );
                            }
                            if (controller.errorMessage.value.isNotEmpty &&
                                controller.items.isEmpty) {
                              return Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: hPad),
                                child: _ErrorBlock(
                                  message: controller.errorMessage.value,
                                  onRetry: controller.loadItems,
                                  retryLabel: l10n.retryLabel,
                                ),
                              );
                            }
                            return SizedBox(
                              height: 188,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                padding:
                                    EdgeInsets.symmetric(horizontal: hPad),
                                itemCount: controller.items.length,
                                separatorBuilder: (_, _) =>
                                    const SizedBox(width: 12),
                                itemBuilder: (context, i) {
                                  return SizedBox(
                                    width: shopCardWidth,
                                    child: _ModernShopCard(
                                      shop: controller.items[i],
                                      selected:
                                          i == controller.selectedIndex,
                                      onTap: () => _onSelectShop(i),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 28),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: hPad),
                          child: _SectionLabel(
                            label: l10n.servicesSection,
                            fontScale: fontScale,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: hPad),
                          child: GetBuilder<ServiceListController>(
                            id: 'service-selection',
                            builder: (controller) {
                              if (controller.isLoading.value &&
                                  controller.items.isEmpty) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 40),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFFEEEEEE),
                                    ),
                                  ),
                                );
                              }
                              if (controller.errorMessage.value.isNotEmpty &&
                                  controller.items.isEmpty) {
                                return _ErrorBlock(
                                  message: controller.errorMessage.value,
                                  onRetry: controller.loadItems,
                                  retryLabel: l10n.retryLabel,
                                );
                              }
                              if (controller.items.isEmpty) {
                                return Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 36,
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _surface,
                                    borderRadius: BorderRadius.circular(22),
                                    border: Border.all(
                                      color: const Color(0xFFFFFFFF)
                                          .withValues(alpha: 0.06),
                                    ),
                                  ),
                                  child: Text(
                                    l10n.browseSelectShopHint,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFF8E8E8E),
                                      fontSize: 13 * fontScale,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              }
                              return Column(
                                children: [
                                  for (var i = 0;
                                      i < controller.items.length;
                                      i++)
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 12),
                                      child: _ModernServiceCard(
                                        service: controller.items[i],
                                        selected: i == _selectedService,
                                        onTap: () => setState(
                                          () => _selectedService = i,
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(hPad, 6, hPad, 12),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.45),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFF2F2F2),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          onPressed: _startBooking,
                          child: Text(
                            l10n.bookAppointment,
                            style: GoogleFonts.inter(
                              fontSize: 16 * fontScale,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
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
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, required this.fontScale});

  final String label;
  final double fontScale;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            color: const Color(0xFF185C5C),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label.toUpperCase(),
          style: GoogleFonts.inter(
            color: const Color(0xFFB8B8B8),
            fontSize: 12 * fontScale,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
          ),
        ),
      ],
    );
  }
}

class _ErrorBlock extends StatelessWidget {
  const _ErrorBlock({
    required this.message,
    required this.onRetry,
    required this.retryLabel,
  });

  final String message;
  final VoidCallback onRetry;
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: const Color(0xFFDDDDDD),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: onRetry,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFEEEEEE),
              foregroundColor: Colors.black,
            ),
            child: Text(retryLabel),
          ),
        ],
      ),
    );
  }
}

class _ModernShopCard extends StatelessWidget {
  const _ModernShopCard({
    required this.shop,
    required this.selected,
    required this.onTap,
  });

  final Shop shop;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: selected
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFFFFFF), Color(0xFFE8E8E8)],
                  )
                : const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2C2C2E), Color(0xFF1A1A1C)],
                  ),
            border: Border.all(
              color: selected
                  ? Colors.white
                  : const Color(0xFFFFFFFF).withValues(alpha: 0.10),
              width: selected ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: selected
                    ? Colors.white.withValues(alpha: 0.12)
                    : Colors.black.withValues(alpha: 0.35),
                blurRadius: selected ? 20 : 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -18,
                top: -18,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected
                        ? const Color(0xFF185C5C).withValues(alpha: 0.12)
                        : const Color(0xFF185C5C).withValues(alpha: 0.18),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xFF185C5C)
                                    .withValues(alpha: 0.12)
                                : const Color(0xFFFFFFFF)
                                    .withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Image.asset(
                            'assets/images/shop.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        const Spacer(),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selected
                                ? const Color(0xFF185C5C)
                                : const Color(0xFFFFFFFF)
                                    .withValues(alpha: 0.08),
                            border: Border.all(
                              color: selected
                                  ? const Color(0xFF185C5C)
                                  : const Color(0xFFFFFFFF)
                                      .withValues(alpha: 0.18),
                            ),
                          ),
                          child: selected
                              ? const Icon(
                                  Icons.check_rounded,
                                  size: 16,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      shop.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: selected ? Colors.black : Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: selected
                              ? const Color(0xFF3A3A3A)
                              : const Color(0xFFA0A0A0),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            shop.addressLine1,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              color: selected
                                  ? const Color(0xFF3A3A3A)
                                  : const Color(0xFFB0B0B0),
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
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
    );
  }
}

class _ModernServiceCard extends StatelessWidget {
  const _ModernServiceCard({
    required this.service,
    required this.selected,
    required this.onTap,
  });

  final ServiceModel service;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final showPrice = shouldDisplayServicePrice(
      apiShowPrice: service.showPrice,
    );
    final duration = service.durationMinutes;
    final desc = (service.description ?? '').trim();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.fromLTRB(16, 15, 14, 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: selected ? Colors.white : const Color(0xFF1C1C1E),
            border: Border.all(
              color: selected
                  ? Colors.white
                  : const Color(0xFFFFFFFF).withValues(alpha: 0.08),
              width: selected ? 1.5 : 1,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: selected
                      ? const Color(0xFF185C5C).withValues(alpha: 0.12)
                      : const Color(0xFF2A2A2C),
                ),
                child: Icon(
                  Icons.content_cut_rounded,
                  size: 20,
                  color: selected
                      ? const Color(0xFF185C5C)
                      : const Color(0xFFCCCCCC),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: selected ? Colors.black : Colors.white,
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                    if (desc.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        desc,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          color: selected
                              ? const Color(0xFF4A4A4A)
                              : const Color(0xFF9A9A9A),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ] else if (duration > 0) ...[
                      const SizedBox(height: 3),
                      Text(
                        '$duration min',
                        style: GoogleFonts.inter(
                          color: selected
                              ? const Color(0xFF4A4A4A)
                              : const Color(0xFF9A9A9A),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (showPrice)
                    Text(
                      '€${service.price.round()}',
                      style: GoogleFonts.inter(
                        color: selected
                            ? const Color(0xFF185C5C)
                            : Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                  const SizedBox(height: 6),
                  if (selected)
                    SvgPicture.asset(
                      'assets/icons/checked.svg',
                      width: 22,
                    )
                  else
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFFFFFFF)
                              .withValues(alpha: 0.22),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
