import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/profile_avatar_service.dart';
import '../utils/avatar_url_resolver.dart';
import 'initials_avatar.dart';

/// Small circular avatar for app bars — a pending local pick wins over the
/// remote [avatarUrl] so a new photo shows before its upload completes.
///
/// When no photo is available, shows the first letter of [displayName].
class SessionUserAvatar extends StatelessWidget {
  const SessionUserAvatar({
    super.key,
    required this.radius,
    this.avatarUrl,
    this.displayName,
    this.borderColor = const Color(0xFFDDDDDD),
    this.borderWidth = 2,
  });

  final double radius;
  final String? avatarUrl;
  final String? displayName;
  final Color borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final size = radius * 2;
    final initial = avatarInitialFromName(displayName);
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
          child: _SessionUserAvatarImage(
            avatarUrl: avatarUrl,
            initial: initial,
            fontSize: radius * 0.9,
          ),
        ),
      ),
    );
  }
}

class _SessionUserAvatarImage extends StatelessWidget {
  const _SessionUserAvatarImage({
    this.avatarUrl,
    required this.initial,
    required this.fontSize,
  });

  final String? avatarUrl;
  final String initial;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ProfileAvatarService>()) return _buildRemote();
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
                key: ValueKey(file.path),
                fit: BoxFit.cover,
                gaplessPlayback: true,
                errorBuilder: (_, __, ___) => _buildRemote(),
              );
            }
            return _buildRemote();
          },
        );
      },
    );
  }

  Widget _buildRemote() {
    final remote = resolveAvatarDisplayUrl(avatarUrl);
    if (remote == null || remote.isEmpty) {
      return InitialsAvatar(initial: initial, fontSize: fontSize);
    }
    return Image.network(
      remote,
      key: ValueKey(remote),
      fit: BoxFit.cover,
      gaplessPlayback: true,
      errorBuilder: (_, __, ___) =>
          InitialsAvatar(initial: initial, fontSize: fontSize),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return InitialsAvatar(
          initial: initial,
          fontSize: fontSize,
          backgroundColor: const Color(0xFF2B2B2B),
          foregroundColor: const Color(0xFFCCCCCC),
        );
      },
    );
  }
}
