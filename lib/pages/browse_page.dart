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
      small: 18,
      medium: 22,
      large: 28,
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
      small: 200,
      medium: 220,
      large: 240,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: hPad,
        title: Text(
          l10n.browseTitle,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 18 * fontScale,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.toNamed(AppRoutes.login),
            child: Text(
              l10n.signIn,
              style: GoogleFonts.inter(
                color: const Color(0xFFE7E7E7),
                fontWeight: FontWeight.w600,
                fontSize: 14 * fontScale,
              ),
            ),
          ),
          SizedBox(width: hPad - 8),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.fromLTRB(0, 8, 0, 20),
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: hPad),
                      child: Text(
                        l10n.shopsSection,
                        style: GoogleFonts.inter(
                          color: const Color(0xFFDDDDDD),
                          fontSize: 14 * fontScale,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    GetBuilder<ShopListController>(
                      id: 'shop-selection',
                      builder: (controller) {
                        if (controller.isLoading.value &&
                            controller.items.isEmpty) {
                          return const SizedBox(
                            height: 220,
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
                            padding: EdgeInsets.symmetric(horizontal: hPad),
                            child: _ErrorBlock(
                              message: controller.errorMessage.value,
                              onRetry: controller.loadItems,
                              retryLabel: l10n.retryLabel,
                            ),
                          );
                        }
                        return SizedBox(
                          height: 236,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: hPad),
                            itemCount: controller.items.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(width: 14),
                            itemBuilder: (context, i) {
                              return SizedBox(
                                width: shopCardWidth,
                                child: _BrowseShopCard(
                                  shop: controller.items[i],
                                  selected: i == controller.selectedIndex,
                                  selectLabel: l10n.select,
                                  onTap: () => _onSelectShop(i),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 26),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: hPad),
                      child: Text(
                        l10n.servicesSection,
                        style: GoogleFonts.inter(
                          color: const Color(0xFFDDDDDD),
                          fontSize: 14 * fontScale,
                          fontWeight: FontWeight.w700,
                        ),
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
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 28),
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
                                  padding: const EdgeInsets.only(bottom: 14),
                                  child: _BrowseServiceCard(
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
              SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(hPad, 8, hPad, 16),
                  child: SizedBox(
                    height: 54,
                    width: double.infinity,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEEEEE),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: _startBooking,
                        child: Text(
                          l10n.bookAppointment,
                          style: GoogleFonts.inter(
                            color: const Color(0xFF000000),
                            fontSize: 16 * fontScale,
                            fontWeight: FontWeight.w600,
                          ),
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

/// Matches appointment shop card theme: white selected / #262626 unselected.
class _BrowseShopCard extends StatelessWidget {
  const _BrowseShopCard({
    required this.shop,
    required this.selected,
    required this.selectLabel,
    required this.onTap,
  });

  final Shop shop;
  final bool selected;
  final String selectLabel;
  final VoidCallback onTap;

  static const _radius = 32.0;
  static const _unselectedBg = Color(0xFF262626);

  @override
  Widget build(BuildContext context) {
    final titleColor =
        selected ? const Color(0xFF000000) : const Color(0xFFFFFFFF);
    final addressColor =
        selected ? const Color(0xFF242424) : const Color(0xFFDDDDDD);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_radius),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: selected ? Colors.white : _unselectedBg,
            borderRadius: BorderRadius.circular(_radius),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/images/shop.png',
                width: 64,
                height: 64,
                fit: BoxFit.contain,
              ),
              Column(
                children: [
                  Text(
                    shop.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: titleColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    shop.addressLine1,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: addressColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
              if (selected)
                SvgPicture.asset('assets/icons/checked.svg', width: 24)
              else
                Container(
                  width: double.infinity,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A3A3C),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    selectLabel,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Matches appointment service card theme: white selected / #242424 unselected.
class _BrowseServiceCard extends StatelessWidget {
  const _BrowseServiceCard({
    required this.service,
    required this.selected,
    required this.onTap,
  });

  final ServiceModel service;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg = selected ? const Color(0xFFFFFFFF) : const Color(0xFF242424);
    final title = selected ? const Color(0xFF000000) : Colors.white;
    final sub = selected ? const Color(0xFF242424) : const Color(0xFFDDDDDD);
    final price = selected ? const Color(0xFF000000) : Colors.white;
    final showPrice = shouldDisplayServicePrice(
      apiShowPrice: service.showPrice,
    );
    final duration = service.durationMinutes;
    final desc = (service.description ?? '').trim();
    final subtitle = desc.isNotEmpty
        ? desc
        : (duration > 0 ? '$duration min' : '');

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: title,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          color: sub,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (showPrice) ...[
                const SizedBox(width: 10),
                Text(
                  '€${service.price.round()}',
                  style: GoogleFonts.inter(
                    color: price,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
              const SizedBox(width: 10),
              SvgPicture.asset(
                selected
                    ? 'assets/icons/checked.svg'
                    : 'assets/icons/non_check.svg',
                width: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
