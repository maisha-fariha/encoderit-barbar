import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gems_data_layer/gems_data_layer.dart';
import 'package:gems_responsive/gems_responsive.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/profile_controller.dart';
import '../gen/l10n/app_localizations.dart';
import '../models/profile/profile_update_request.dart';
import '../routes/app_pages.dart';
import '../services/app_services.dart';
import '../services/profile_avatar_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _navIndex = 3; // Profilo selected

  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _dobCtrl = TextEditingController();
  final _address = TextEditingController();
  final _zip = TextEditingController();
  final _municipality = TextEditingController();
  final _province = TextEditingController();
  final _country = TextEditingController();

  /// Relative avatar URL from session (e.g. after upload); sent on `PUT /profile`.
  String _avatarUrl = '';

  ProfileAvatarService? get _avatarSvc =>
      Get.isRegistered<ProfileAvatarService>()
          ? Get.find<ProfileAvatarService>()
          : null;

  Future<void> _openAvatarPicker() async {
    final l10n = AppLocalizations.of(context)!;
    final svc = _avatarSvc;
    if (svc == null) return;

    final source = await showModalBottomSheet<_AvatarPickSource>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.65),
      isScrollControlled: true,
      builder: (sheetCtx) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF242424),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFFFFFFF).withValues(alpha: 0.10),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 38,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF).withValues(alpha: 0.20),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    l10n.changeProfilePhoto,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _AvatarSheetTile(
                    icon: Icons.photo_camera_outlined,
                    label: l10n.takePhoto,
                    onTap: () =>
                        Navigator.of(sheetCtx).pop(_AvatarPickSource.camera),
                  ),
                  const SizedBox(height: 8),
                  _AvatarSheetTile(
                    icon: Icons.photo_library_outlined,
                    label: l10n.chooseFromGallery,
                    onTap: () =>
                        Navigator.of(sheetCtx).pop(_AvatarPickSource.gallery),
                  ),
                  const SizedBox(height: 14),
                  TextButton(
                    onPressed: () => Navigator.of(sheetCtx).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFDDDDDD),
                    ),
                    child: Text(
                      l10n.cancel,
                      style: GoogleFonts.inter(
                        color: const Color(0xFFDDDDDD),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (source == null) return;

    final result = source == _AvatarPickSource.camera
        ? await svc.pickFromCamera()
        : await svc.pickFromGallery();

    if (!mounted) return;
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    if (result.isCancelled) return;

    if (result.isSuccess) {
      messenger.clearSnackBars();
      messenger.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFFE8E8E8),
          content: Text(
            l10n.photoSavedOffline,
            style: const TextStyle(
              color: Color(0xFF0B0B0B),
              fontWeight: FontWeight.w600,
            ),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    final errMsg = _avatarErrorMessage(l10n, result.error);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFFE8E8E8),
        content: Text(
          errMsg,
          style: const TextStyle(
            color: Color(0xFFB91C1C),
            fontWeight: FontWeight.w600,
          ),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_loadFromSession());
    });
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _phone.dispose();
    _dobCtrl.dispose();
    _address.dispose();
    _zip.dispose();
    _municipality.dispose();
    _province.dispose();
    _country.dispose();
    super.dispose();
  }

  String _stringField(Map<String, dynamic> u, List<String> keys) {
    for (final k in keys) {
      final v = u[k];
      if (v is String && v.trim().isNotEmpty) return v.trim();
    }
    return '';
  }

  Future<void> _loadFromSession() async {
    final auth = await AppServices.getIt<AuthService>().getStoredAuth();
    if (!mounted) return;
    final u = auth?.userData;
    if (u == null) return;
    final name = (u['name'] as String? ?? '').trim();
    final parts = name.isEmpty ? <String>[] : name.split(RegExp(r'\s+'));
    setState(() {
      _firstName.text = parts.isNotEmpty ? parts.first : '';
      _lastName.text = parts.length > 1 ? parts.sublist(1).join(' ') : '';
      _email.text = (u['email'] as String? ?? '').trim();
      _phone.text = (u['phone'] as String? ?? '').trim();
      _dobCtrl.text = _stringField(u, ['dob', 'date_of_birth', 'birthday']);
      _address.text = _stringField(u, ['address']);
      _zip.text = _stringField(u, ['zip_code', 'zip']);
      _municipality.text = _stringField(u, ['municipality', 'city']);
      _province.text = _stringField(u, ['province']);
      _country.text = _stringField(u, ['country']);
      _avatarUrl = (u['avatar_url'] as String? ?? '').trim();
    });
  }

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

  String _two(int n) => n.toString().padLeft(2, '0');

  Future<void> _pickDob() async {
    DateTime initial = DateTime(1990, 1, 1);
    final raw = _dobCtrl.text.trim();
    if (raw.isNotEmpty) {
      final parsed = DateTime.tryParse(raw);
      if (parsed != null) initial = parsed;
    }
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _dobCtrl.text = '${picked.year}-${_two(picked.month)}-${_two(picked.day)}';
    });
  }

  Future<void> _submitProfile() async {
    FocusScope.of(context).unfocus();
    final l10n = AppLocalizations.of(context)!;
    final first = _firstName.text.trim();
    final last = _lastName.text.trim();
    final name = [first, last].where((s) => s.isNotEmpty).join(' ');
    if (name.isEmpty) {
      _showSnack(l10n.profileNameRequired, isError: true);
      return;
    }
    final email = _email.text.trim();
    if (email.isEmpty) {
      _showSnack(l10n.profileEmailRequired, isError: true);
      return;
    }

    final request = ProfileUpdateRequest(
      name: name,
      email: email,
      phone: _phone.text.trim(),
      avatarUrl: _avatarUrl,
      dob: _dobCtrl.text.trim(),
      address: _address.text.trim(),
      zipCode: _zip.text.trim(),
      province: _province.text.trim(),
      municipality: _municipality.text.trim(),
      country: _country.text.trim(),
    );

    final controller = Get.find<ProfileController>();
    final outcome = await controller.updateProfile(request);
    if (!mounted) return;

    if (outcome.success) {
      final msg = outcome.message.isNotEmpty
          ? outcome.message
          : l10n.profileUpdateSuccessFallback;
      _showSnack(msg, isError: false);
      await _loadFromSession();
      if (Get.isRegistered<ProfileAvatarService>()) {
        Get.find<ProfileAvatarService>().revision.value++;
      }
      return;
    }

    if (outcome.isNetworkError) {
      _showSnack(l10n.profileUpdateNetworkError, isError: true);
      return;
    }

    final fromErrors = _firstErrorString(outcome.errors);
    final errMsg = outcome.message.isNotEmpty
        ? outcome.message
        : (fromErrors.isNotEmpty ? fromErrors : l10n.bookingGenericError);
    _showSnack(errMsg, isError: true);
  }

  String _avatarErrorMessage(AppLocalizations l10n, AvatarPickError? err) {
    switch (err) {
      case AvatarPickError.cameraPermissionDenied:
        return l10n.cameraPermissionDenied;
      case AvatarPickError.galleryPermissionDenied:
        return l10n.galleryPermissionDenied;
      case AvatarPickError.cameraUnavailable:
        return l10n.cameraUnavailable;
      case AvatarPickError.missingPlugin:
        return l10n.pickerNotInstalled;
      case AvatarPickError.noUser:
        return l10n.notSignedIn;
      case AvatarPickError.saveFailed:
      case AvatarPickError.unknown:
      case null:
        return l10n.photoPickError;
    }
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
    final avatarSize = ResponsiveHelper.getResponsiveValue<double>(
      context,
      small: 150,
      large: 180,
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
                      l10n.profile,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 18 * fontScale,
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF).withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0xFFFFFFFF).withValues(alpha: 0.18),
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.all(3),
                      child: Builder(
                        builder: (context) {
                          final locale = Get.locale ?? Localizations.localeOf(context);
                          final isEn = locale.languageCode == 'en';
                          return ToggleButtons(
                            isSelected: [isEn, !isEn],
                            onPressed: (index) {
                              final next = index == 0 ? const Locale('en') : const Locale('it');
                              Get.updateLocale(next);
                              setState(() {});
                            },
                            borderRadius: BorderRadius.circular(12),
                            selectedBorderColor: Colors.transparent,
                            borderColor: Colors.transparent,
                            fillColor: const Color(0xFFFFFFFF).withValues(alpha: 0.14),
                            selectedColor: const Color(0xFFFFFFFF),
                            color: const Color(0xFFFFFFFF).withValues(alpha: 0.70),
                            constraints: BoxConstraints(
                              minHeight: 32,
                              minWidth: ResponsiveHelper.getResponsiveValue<double>(
                                context,
                                small: 46,
                                large: 54,
                              ),
                            ),
                            textStyle: GoogleFonts.inter(
                              fontSize: 12 * fontScale,
                              fontWeight: FontWeight.w800,
                              height: 1,
                              letterSpacing: 0.4,
                            ),
                            children: const [
                              Text('EN'),
                              Text('IT'),
                            ],
                          );
                        },
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
                    child: _ProfileAvatar(
                      size: avatarSize,
                      service: _avatarSvc,
                      onTapEdit: _openAvatarPicker,
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
                        _FieldLabel(l10n.nameLabel),
                        const SizedBox(height: 8),
                        _ProfileTextField(
                          controller: _firstName,
                          hint: l10n.enterYourName,
                          fontScale: fontScale,
                        ),
                        const SizedBox(height: 14),
                        _FieldLabel(l10n.lastNameLabel),
                        const SizedBox(height: 8),
                        _ProfileTextField(
                          controller: _lastName,
                          hint: l10n.lastNameLabel,
                          fontScale: fontScale,
                        ),
                        const SizedBox(height: 14),
                        _FieldLabel(l10n.dateOfBirthLabel),
                        const SizedBox(height: 8),
                        _ProfileTextField(
                          controller: _dobCtrl,
                          hint: 'YYYY-MM-DD',
                          fontScale: fontScale,
                          trailing: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 36,
                              minHeight: 36,
                            ),
                            onPressed: _pickDob,
                            icon: Icon(
                              Icons.calendar_today_outlined,
                              color: const Color(0xFFB7B7B7),
                              size: 18 * fontScale,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        _FieldLabel(l10n.phoneNumberLabel),
                        const SizedBox(height: 8),
                        _ProfileTextField(
                          controller: _phone,
                          hint: l10n.phoneHint,
                          fontScale: fontScale,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 14),
                        _FieldLabel(l10n.emailLabel),
                        const SizedBox(height: 8),
                        _ProfileTextField(
                          controller: _email,
                          hint: l10n.enterYourEmail,
                          fontScale: fontScale,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 14),
                        _FieldLabel(l10n.address),
                        const SizedBox(height: 8),
                        _ProfileTextField(
                          controller: _address,
                          hint: l10n.address,
                          fontScale: fontScale,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 14),
                        _FieldLabel(l10n.zipCodeLabel),
                        const SizedBox(height: 8),
                        _ProfileTextField(
                          controller: _zip,
                          hint: l10n.zipCodeLabel,
                          fontScale: fontScale,
                        ),
                        const SizedBox(height: 14),
                        _FieldLabel(l10n.cityLabel),
                        const SizedBox(height: 8),
                        _ProfileTextField(
                          controller: _municipality,
                          hint: l10n.cityLabel,
                          fontScale: fontScale,
                        ),
                        const SizedBox(height: 14),
                        _FieldLabel(l10n.provinceLabel),
                        const SizedBox(height: 8),
                        _ProfileTextField(
                          controller: _province,
                          hint: l10n.provinceLabel,
                          fontScale: fontScale,
                        ),
                        const SizedBox(height: 14),
                        _FieldLabel(l10n.countryLabel),
                        const SizedBox(height: 8),
                        _ProfileTextField(
                          controller: _country,
                          hint: l10n.countryLabel,
                          fontScale: fontScale,
                        ),
                        const SizedBox(height: 30),
                        Obx(() {
                          final busy =
                              Get.find<ProfileController>().isUpdating.value;
                          return SizedBox(
                            height: 48,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: busy
                                    ? Color(0xFFFFFFFF).withValues(alpha: 0.06)
                                    : Color(0xFFFFFFFF).withValues(alpha: 0.10),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.white),
                              ),
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: busy ? null : _submitProfile,
                                child: busy
                                    ? SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white.withValues(
                                            alpha: 0.9,
                                          ),
                                        ),
                                      )
                                    : Text(
                                        l10n.update,
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 16 * fontScale,
                                          fontWeight: FontWeight.w600,
                                          height: 1,
                                        ),
                                      ),
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: 12),
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
                                l10n.logout,
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

enum _AvatarPickSource { camera, gallery }

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({
    required this.size,
    required this.service,
    required this.onTapEdit,
  });

  final double size;
  final ProfileAvatarService? service;
  final VoidCallback onTapEdit;

  @override
  Widget build(BuildContext context) {
    final badgeSize = ResponsiveHelper.getResponsiveValue<double>(
      context,
      small: 34,
      large: 40,
    );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFDDDDDD), width: 2),
              ),
              child: service == null
                  ? const _FallbackAvatar()
                  : ValueListenableBuilder<int>(
                      valueListenable: service!.revision,
                      builder: (context, _, child) {
                        return FutureBuilder<File?>(
                          future: service!.currentAvatarFile(),
                          builder: (context, snapshot) {
                            final file = snapshot.data;
                            if (file == null) return const _FallbackAvatar();
                            return Image.file(
                              file,
                              key: ValueKey(
                                file.path + file.lengthSync().toString(),
                              ),
                              fit: BoxFit.cover,
                              gaplessPlayback: true,
                              errorBuilder: (context, error, stack) =>
                                  const _FallbackAvatar(),
                            );
                          },
                        );
                      },
                    ),
            ),
          ),
        ),
        Positioned(
          right: 5,
          bottom: 5,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTapEdit,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: badgeSize,
                height: badgeSize,
                decoration: BoxDecoration(
                  color: const Color(0xFF797979).withValues(alpha: 0.50),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SvgPicture.asset(
                    'assets/icons/edit.svg',
                    width: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FallbackAvatar extends StatelessWidget {
  const _FallbackAvatar();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/profile.jpg',
      fit: BoxFit.cover,
      errorBuilder: (context, error, stack) => Container(
        color: const Color(0xFF1A1A1A),
        alignment: Alignment.center,
        child: const Icon(
          Icons.person_rounded,
          size: 64,
          color: Color(0xFF797979),
        ),
      ),
    );
  }
}

class _AvatarSheetTile extends StatelessWidget {
  const _AvatarSheetTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF).withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFFFFFFFF).withValues(alpha: 0.10),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF797979),
                size: 20,
              ),
            ],
          ),
        ),
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

class _ProfileTextField extends StatelessWidget {
  const _ProfileTextField({
    required this.controller,
    required this.hint,
    required this.fontScale,
    this.maxLines = 1,
    this.keyboardType,
    this.trailing,
  });

  final TextEditingController controller;
  final String hint;
  final double fontScale;
  final int maxLines;
  final TextInputType? keyboardType;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final isMultiline = maxLines > 1;
    final suffix = trailing;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        12,
        (isMultiline ? 6 : 2) * fontScale,
        12,
        (isMultiline ? 6 : 2) * fontScale,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFFFFFFF).withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment:
            isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: maxLines,
              keyboardType: keyboardType,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 16 * fontScale,
                fontWeight: FontWeight.w500,
                height: isMultiline ? 1.35 : 1.2,
              ),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: hint,
                hintStyle: GoogleFonts.inter(
                  color: const Color(0xFFFFFFFF).withValues(alpha: 0.35),
                  fontWeight: FontWeight.w500,
                  fontSize: 16 * fontScale,
                ),
                contentPadding: EdgeInsets.fromLTRB(
                  4,
                  isMultiline ? 10 : 12,
                  4,
                  isMultiline ? 10 : 12,
                ),
              ),
            ),
          ),
          if (suffix != null) suffix,
        ],
      ),
    );
  }
}
