import 'package:gems_core/gems_core.dart';

/// Site origin for avatar/media URLs (no `/api/v1` — backend usually returns full URLs).
const String defaultAvatarAssetOrigin =
    'https://api.iconicohair.it';

/// Reads `avatar` from stored user JSON (falls back to legacy `avatar_url`).
String? sessionAvatarFromUserData(Map<String, dynamic>? userData) {
  if (userData == null) return null;
  final avatar = userData['avatar'];
  if (avatar is String && avatar.trim().isNotEmpty) return avatar.trim();
  final legacy = userData['avatar_url'];
  if (legacy is String && legacy.trim().isNotEmpty) return legacy.trim();
  return null;
}

/// Builds a displayable URL from API `avatar`.
///
/// Backend responses normally include a full `https://…` URL; those are returned
/// unchanged. Relative paths are resolved against the site origin only (not
/// [Environment.apiBaseUrl] / `api/v1`).
String? resolveAvatarDisplayUrl(
  String? raw, {
  String? assetOriginOverride,
}) {
  if (raw == null) return null;
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return null;

  final lower = trimmed.toLowerCase();
  if (lower.startsWith('http://') || lower.startsWith('https://')) {
    return trimmed;
  }

  final origin = _avatarAssetOrigin(assetOriginOverride: assetOriginOverride);

  if (trimmed.startsWith('//')) {
    return '${origin.scheme}:$trimmed';
  }

  if (_alreadyHasOrigin(trimmed, origin)) {
    return trimmed.startsWith('http://') || trimmed.startsWith('https://')
        ? trimmed
        : Uri(
            scheme: origin.scheme,
            host: origin.host,
            port: origin.hasPort ? origin.port : null,
            path: trimmed.startsWith('/') ? trimmed : '/$trimmed',
          ).toString();
  }

  if (_isHostAbsolutePath(trimmed, origin.host)) {
    final path = trimmed.startsWith(origin.host)
        ? trimmed.substring(origin.host.length)
        : trimmed;
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    return Uri(
      scheme: origin.scheme,
      host: origin.host,
      port: origin.hasPort ? origin.port : null,
      path: normalizedPath,
    ).toString();
  }

  if (trimmed.startsWith('/')) {
    return Uri(
      scheme: origin.scheme,
      host: origin.host,
      port: origin.hasPort ? origin.port : null,
      path: trimmed,
    ).toString();
  }

  final rel = trimmed.replaceAll(RegExp(r'^/+'), '');
  return origin.resolve(rel).toString();
}

/// Persists a normalized absolute URL when saving API user payloads.
String? normalizeAvatarUrlForStorage(
  String? raw, {
  String? assetOriginOverride,
}) =>
    resolveAvatarDisplayUrl(raw, assetOriginOverride: assetOriginOverride);

Uri _avatarAssetOrigin({String? assetOriginOverride}) {
  final raw = (assetOriginOverride ?? Environment.instance.apiBaseUrl).trim();
  if (raw.isNotEmpty) {
    final uri = Uri.tryParse(raw);
    if (uri != null && uri.hasScheme && uri.host.isNotEmpty) {
      return Uri(
        scheme: uri.scheme,
        host: uri.host,
        port: uri.hasPort ? uri.port : null,
      );
    }
  }
  return Uri.parse(defaultAvatarAssetOrigin);
}

bool _alreadyHasOrigin(String value, Uri origin) {
  if (value.startsWith(origin.origin)) return true;
  final host = origin.host;
  return value.startsWith('$host/') || value == host || value.startsWith('$host:');
}

bool _isHostAbsolutePath(String value, String host) {
  if (host.isEmpty) return false;
  return value.startsWith('$host/') ||
      value == host ||
      value.startsWith('$host:');
}
