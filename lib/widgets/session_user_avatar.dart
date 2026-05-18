import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/profile_avatar_service.dart';
import '../utils/avatar_url_resolver.dart';

/// Small circular avatar for app bars — uses remote [avatarUrl], then local cache.
class SessionUserAvatar extends StatelessWidget {
  const SessionUserAvatar({
    super.key,
    required this.radius,
    this.avatarUrl,
    this.borderColor = const Color(0xFFDDDDDD),
    this.borderWidth = 2,
  });

  final double radius;
  final String? avatarUrl;
  final Color borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final size = radius * 2;
    return Container(
      width: size + borderWidth * 2,
      height: size + borderWidth * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      child: ClipOval(
        child: SizedBox(
          width: size,
          height: size,
          child: _SessionUserAvatarImage(avatarUrl: avatarUrl),
        ),
      ),
    );
  }
}

class _SessionUserAvatarImage extends StatelessWidget {
  const _SessionUserAvatarImage({this.avatarUrl});

  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final remote = resolveAvatarDisplayUrl(avatarUrl);
    if (remote != null && remote.isNotEmpty) {
      return Image.network(
        remote,
        fit: BoxFit.cover,
        gaplessPlayback: true,
        errorBuilder: (_, __, ___) => const _AvatarPlaceholder(),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const _AvatarPlaceholder(showSpinner: true);
        },
      );
    }

    if (Get.isRegistered<ProfileAvatarService>()) {
      final svc = Get.find<ProfileAvatarService>();
      return ValueListenableBuilder<int>(
        valueListenable: svc.revision,
        builder: (context, _, __) {
          return FutureBuilder<File?>(
            future: svc.currentAvatarFile(),
            builder: (context, snapshot) {
              final file = snapshot.data;
              if (file != null && file.existsSync()) {
                return Image.file(
                  file,
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                  errorBuilder: (_, __, ___) => const _AvatarPlaceholder(),
                );
              }
              return const _AvatarPlaceholder();
            },
          );
        },
      );
    }

    return const _AvatarPlaceholder();
  }
}

class _AvatarPlaceholder extends StatelessWidget {
  const _AvatarPlaceholder({this.showSpinner = false});

  final bool showSpinner;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF2B2B2B),
      child: showSpinner
          ? const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFFCCCCCC),
                ),
              ),
            )
          : Image.asset(
              'assets/images/profile.jpg',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Center(
                child: Icon(
                  Icons.person_rounded,
                  color: Color(0xFF797979),
                  size: 28,
                ),
              ),
            ),
    );
  }
}
