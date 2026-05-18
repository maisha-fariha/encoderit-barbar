import 'dart:io';

import 'package:flutter/material.dart';

/// Full-screen preview for a profile avatar (file, network, or asset).
Future<void> showAvatarImagePreview(
  BuildContext context, {
  File? file,
  String? networkUrl,
  String? assetPath,
}) {
  assert(
    file != null ||
        (networkUrl != null && networkUrl.isNotEmpty) ||
        (assetPath != null && assetPath.isNotEmpty),
    'Provide file, networkUrl, or assetPath',
  );

  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.92),
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Center(
              child: InteractiveViewer(
                minScale: 0.75,
                maxScale: 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: _PreviewImage(
                    file: file,
                    networkUrl: networkUrl,
                    assetPath: assetPath,
                  ),
                ),
              ),
            ),
            Positioned(
              top: -8,
              right: -8,
              child: Material(
                color: Colors.transparent,
                child: IconButton(
                  tooltip: MaterialLocalizations.of(dialogContext).closeButtonTooltip,
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

class _PreviewImage extends StatelessWidget {
  const _PreviewImage({
    this.file,
    this.networkUrl,
    this.assetPath,
  });

  final File? file;
  final String? networkUrl;
  final String? assetPath;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final maxSide = (size.shortestSide * 0.88).clamp(200.0, 520.0);

    Widget image;
    if (file != null && file!.existsSync()) {
      image = Image.file(
        file!,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
        errorBuilder: (_, __, ___) => const _PreviewError(),
      );
    } else if (networkUrl != null && networkUrl!.isNotEmpty) {
      image = Image.network(
        networkUrl!,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return SizedBox(
            width: maxSide,
            height: maxSide,
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFFCCCCCC),
              ),
            ),
          );
        },
        errorBuilder: (_, __, ___) => const _PreviewError(),
      );
    } else {
      image = Image.asset(
        assetPath!,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
        errorBuilder: (_, __, ___) => const _PreviewError(),
      );
    }

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: maxSide,
        maxHeight: maxSide,
      ),
      child: image,
    );
  }
}

class _PreviewError extends StatelessWidget {
  const _PreviewError();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 200,
      height: 200,
      child: Center(
        child: Icon(
          Icons.broken_image_outlined,
          color: Color(0xFF797979),
          size: 48,
        ),
      ),
    );
  }
}
