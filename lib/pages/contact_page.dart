import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gems_responsive/gems_responsive.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

import '../controllers/contact_controller.dart';
import '../controllers/shop_list_controller.dart';
import '../gen/l10n/app_localizations.dart';
import '../models/shop/shop_model.dart';

import '../routes/app_pages.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  int _navIndex = 4; // Contatto selected

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _subject = TextEditingController();
  final _message = TextEditingController();

  void _showSnack(String text, {required bool isError}) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFFE8E8E8),
        content: Text(
          text,
          style: GoogleFonts.inter(
            color: isError ? const Color(0xFFB91C1C) : const Color(0xFF0B0B0B),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  String _firstErrorString(Map<String, dynamic>? errors) {
    if (errors == null || errors.isEmpty) return '';
    for (final value in errors.values) {
      if (value is List && value.isNotEmpty && value.first is String) {
        final v = (value.first as String).trim();
        if (v.isNotEmpty) return v;
      }
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    return '';
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final l10n = AppLocalizations.of(context)!;
    final name = _name.text.trim();
    final email = _email.text.trim();
    final subject = _subject.text.trim();
    final message = _message.text.trim();
    if (name.isEmpty || email.isEmpty || subject.isEmpty || message.isEmpty) {
      _showSnack(l10n.contactFormIncomplete, isError: true);
      return;
    }

    final controller = Get.find<ContactController>();
    final outcome = await controller.submit(
      name: name,
      email: email,
      subject: subject,
      message: message,
    );
    if (!mounted) return;

    if (outcome.success) {
      final msg = outcome.message.isNotEmpty
          ? outcome.message
          : l10n.contactSubmitSuccessFallback;
      _showSnack(msg, isError: false);
      _name.clear();
      _email.clear();
      _subject.clear();
      _message.clear();
      return;
    }

    if (outcome.isNetworkError) {
      _showSnack(l10n.contactSubmitNetworkError, isError: true);
      return;
    }

    final fromErrors = _firstErrorString(outcome.errors);
    final errMsg = outcome.message.isNotEmpty
        ? outcome.message
        : (fromErrors.isNotEmpty ? fromErrors : l10n.bookingGenericError);
    _showSnack(errMsg, isError: true);
  }

  @override
  void initState() {
    super.initState();
    final shops = Get.find<ShopListController>();
    if (shops.items.isEmpty) {
      shops.loadItems();
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _subject.dispose();
    _message.dispose();
    super.dispose();
  }

  String _addressBody(Shop shop) {
    if (shop.address.trim().isEmpty) return '—';
    final line1 = shop.addressLine1;
    final line2 = shop.addressLine2;
    if (line2.isEmpty) return line1;
    return '$line1,\n$line2';
  }

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
    final l10n = AppLocalizations.of(context)!;

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
                padding: EdgeInsets.fromLTRB(hPad, 20, hPad, 0),
                child: Row(
                  children: [
                    InkResponse(
                      radius: 24,
                      onTap: () => Get.back(),
                      child: SvgPicture.asset(
                        'assets/icons/back_button.svg',
                        width: 18 * fontScale,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      l10n.contactUs,
                      style: GoogleFonts.inter(
                        color: Color(0xFFFFFFFF),
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
                const SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 10),
                  child: Obx(() {
                    final shopCtrl = Get.find<ShopListController>();
                    final loading = shopCtrl.isLoading.value;
                    final _ = shopCtrl.items.length;
                    return GetBuilder<ShopListController>(
                      id: 'shop-selection',
                      builder: (c) {
                        if (loading && c.items.isEmpty) {
                          return const SizedBox(
                            height: 182,
                            child: Center(
                              child: SizedBox(
                                width: 28,
                                height: 28,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFFCCCCCC),
                                ),
                              ),
                            ),
                          );
                        }
                        final shop = c.selectedShop;
                        if (shop == null) {
                          return _EmptyShopMapCard(message: l10n.contactNoShopsHint);
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (shop.name.trim().isNotEmpty) ...[
                              Text(
                                shop.name,
                                style: GoogleFonts.inter(
                                  color: const Color(0xFFFFFFFF),
                                  fontSize: 18 * fontScale,
                                  fontWeight: FontWeight.w700,
                                  height: 1.35,
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                            _MapPreviewCard(shop: shop, l10n: l10n),
                          ],
                        );
                      },
                    );
                  }),
                ),
                const SizedBox(height: 14),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF242424),
                    borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
                  ),
                  padding: EdgeInsets.fromLTRB(hPad, 30, hPad, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _SectionHeader(
                        icon: 'assets/icons/location.svg',
                        title: l10n.address,
                      ),
                      const SizedBox(height: 15),
                      const _InsetDividerLine(),
                      const SizedBox(height: 15),
                      GetBuilder<ShopListController>(
                        id: 'shop-selection',
                        builder: (c) {
                          final shop = c.selectedShop;
                          final body = shop == null
                              ? l10n.contactNoShopsHint
                              : _addressBody(shop);
                          return Text(
                            body,
                            style: GoogleFonts.inter(
                              color: Color(0xFFFFFFFF),
                              fontSize: 14 * fontScale,
                              height: 1.5,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 15),
                      _SectionHeader(
                        icon: 'assets/icons/information.svg',
                        title: l10n.connectionInfo,
                      ),
                      const SizedBox(height: 15),
                      const _InsetDividerLine(),
                      const SizedBox(height: 15),
                      GetBuilder<ShopListController>(
                        id: 'shop-selection',
                        builder: (c) {
                          final shop = c.selectedShop;
                          final phone = (shop?.phone ?? '').trim();
                          final email = (shop?.email ?? '').trim();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _InfoRow(
                                icon: 'assets/icons/phone.svg',
                                value: phone.isEmpty ? '—' : phone,
                              ),
                              const SizedBox(height: 15),
                              _InfoRow(
                                icon: 'assets/icons/mail.svg',
                                value: email.isEmpty ? '—' : email,
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 40),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF000000),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/contact.svg',
                                  width: 20,
                                ),
                                  const SizedBox(width: 10),
                                  Text(
                                    l10n.contactUs,
                                    style: GoogleFonts.inter(
                                      color: Color(0xFFFFFFFF).withValues(alpha: 0.60),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              const _InsetDividerLine(darker: true),
                              const SizedBox(height: 16),
                              _FormLabel(l10n.nameLabel),
                              const SizedBox(height: 8),
                              _InputBox(controller: _name, hint: l10n.enterYourName),
                              const SizedBox(height: 14),
                              _FormLabel(l10n.emailLabel),
                              const SizedBox(height: 8),
                              _InputBox(controller: _email, hint: l10n.enterYourEmail),
                              const SizedBox(height: 14),
                              _FormLabel(l10n.subjectLabel),
                              const SizedBox(height: 8),
                              _InputBox(
                                controller: _subject,
                                hint: l10n.enterYourSubject,
                              ),
                              const SizedBox(height: 14),
                              _FormLabel(l10n.messageLabel),
                              const SizedBox(height: 8),
                              _InputBox(
                                controller: _message,
                                hint: l10n.writeSomethingHint,
                                maxLines: 4,
                              ),
                              const SizedBox(height: 30),
                              Obx(() {
                                final busy =
                                    Get.find<ContactController>().isSubmitting.value;
                                return SizedBox(
                                  height: 54,
                                  child: Material(
                                    color: busy
                                        ? const Color(0xFFCCCCCC)
                                        : const Color(0xFFEEEEEE),
                                    elevation: 0,
                                    borderRadius: BorderRadius.circular(30),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(30),
                                      onTap: busy ? null : _submit,
                                      child: Center(
                                        child: busy
                                            ? const SizedBox(
                                                width: 22,
                                                height: 22,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: Color(0xFF000000),
                                                ),
                                              )
                                            : Text(
                                                l10n.sendYourMessage,
                                                style: GoogleFonts.inter(
                                                  color: const Color(0xFF000000),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.5,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ],
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
          onPressed: () => Get.toNamed(AppRoutes.appoinment),
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
            Get.toNamed(AppRoutes.profile);
          }
          if (i == 4) {
            // already on contact
          }
        },
      ),
    );
  }
}

class _EmptyShopMapCard extends StatelessWidget {
  const _EmptyShopMapCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 182,
        color: const Color(0xFF2A2A2A),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            color: const Color(0xFFCCCCCC),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.45,
          ),
        ),
      ),
    );
  }
}

class _MapPreviewCard extends StatelessWidget {
  const _MapPreviewCard({required this.shop, required this.l10n});

  final Shop shop;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: 182,
        child: shop.hasMapCoordinates
            ? _OsmMiniMap(
                key: ValueKey<String>(
                  '${shop.id}-${shop.latitude}-${shop.longitude}',
                ),
                latitude: shop.latitude!,
                longitude: shop.longitude!,
              )
            : Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/map.png',
                    fit: BoxFit.cover,
                    color: Colors.black.withValues(alpha: 0.40),
                    colorBlendMode: BlendMode.darken,
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        l10n.contactMapNoCoordinates,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: const Color(0xFFE8E8E8),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _OsmMiniMap extends StatefulWidget {
  const _OsmMiniMap({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;

  @override
  State<_OsmMiniMap> createState() => _OsmMiniMapState();
}

class _OsmMiniMapState extends State<_OsmMiniMap>
    with AutomaticKeepAliveClientMixin {
  final MapController _mapController = MapController();

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final point = LatLng(widget.latitude, widget.longitude);
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/map.png',
          fit: BoxFit.cover,
          color: Colors.black.withValues(alpha: 0.40),
          colorBlendMode: BlendMode.darken,
        ),
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: point,
            initialZoom: 16,
            minZoom: 4,
            maxZoom: 20,
            keepAlive: true,
            backgroundColor: Colors.transparent,
            interactionOptions: InteractionOptions(
              flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              enableMultiFingerGestureRace: true,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.encoderit.barber',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: point,
                  width: 44,
                  height: 44,
                  alignment: Alignment.topCenter,
                  child: const Icon(
                    Icons.location_on,
                    color: Color(0xFFD83A3A),
                    size: 44,
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 6, bottom: 4),
                child: Text(
                  '© OpenStreetMap',
                  style: GoogleFonts.inter(
                    color: Colors.white.withValues(alpha: 0.55),
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InputBox extends StatelessWidget {
  const _InputBox({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String hint;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final isMultiline = maxLines > 1;
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: GoogleFonts.inter(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(
          color: Color(0xFFFFFFFF).withValues(alpha: 0.4),
          fontWeight: FontWeight.w500,
          fontSize: 16,
          height: 1,
        ),
        filled: true,
        fillColor: Color(0xFFFFFFFF).withValues(alpha: 0.08),
        contentPadding: EdgeInsets.fromLTRB(16, isMultiline ? 14 : 16, 16, isMultiline ? 14 : 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFFFFFFF).withValues(alpha: 0.15), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2B2B2B), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3A3A3A), width: 1.2),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.title});

  final String icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(icon, width: 20),
        const SizedBox(width: 10),
        Text(
          title,
          style: GoogleFonts.inter(
            color: Color(0xFFFFFFFF).withValues(alpha: 0.6),
            fontSize: 16,
            fontWeight: FontWeight.w700,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _InsetDividerLine extends StatelessWidget {
  const _InsetDividerLine({this.darker = false});
  final bool darker;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Container(
        height: 1,
        color: Color(0xFF797979).withValues(alpha: 0.30),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.value});

  final String icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(icon, width: 16),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.inter(
              color: Color(0xFFFFFFFF),
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _FormLabel extends StatelessWidget {
  const _FormLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Color(0xFFDDDDDD),
        fontSize: 14,
        fontWeight: FontWeight.w700,
        height: 1.5,
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
                    label: AppLocalizations.of(context)!.home,
                    activeAsset: 'assets/icons/home_active.svg',
                    inactiveAsset: 'assets/icons/home_inactive.svg',
                    selected: currentIndex == 0,
                    onTap: () => onTap(0),
                  ),
                  _NavItem(
                    label: AppLocalizations.of(context)!.reservations,
                    activeAsset: 'assets/icons/reservation_active.svg',
                    inactiveAsset: 'assets/icons/reservation_inactive.svg',
                    selected: currentIndex == 1,
                    onTap: () => onTap(1),
                  ),
                  const SizedBox(width: 58),
                  _NavItem(
                    label: AppLocalizations.of(context)!.profile,
                    activeAsset: 'assets/icons/profile_active.svg',
                    inactiveAsset: 'assets/icons/profile_inactive.svg',
                    selected: currentIndex == 3,
                    onTap: () => onTap(3),
                  ),
                  _NavItem(
                    label: AppLocalizations.of(context)!.contactUs,
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
