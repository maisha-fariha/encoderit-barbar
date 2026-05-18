import 'package:gems_core/gems_core.dart';

/// Builds a displayable URL from API `avatar_url` (relative path or absolute).
///
/// - Absolute `http(s)://…` values are returned unchanged.
/// - Root-relative paths (`/storage/…`) are resolved against the API host only.
/// - Other relative paths (`avatars/…`, `storage/…`) are resolved against
///   [Environment.apiBaseUrl] (e.g. `…/api/v1/avatars/…`).
String? resolveAvatarDisplayUrl(
  String? raw, {
  String? apiBaseOverride,
}) {
  if (raw == null) return null;
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return null;

  final lower = trimmed.toLowerCase();
  if (lower.startsWith('http://') || lower.startsWith('https://')) {
    return trimmed;
  }

  if (trimmed.startsWith('//')) {
    final baseUri = _parseApiBase(apiBaseOverride);
    final scheme =
        baseUri?.scheme.isNotEmpty == true ? baseUri!.scheme : 'https';
    return '$scheme:$trimmed';
  }

  final baseUri = _parseApiBase(apiBaseOverride);
  if (baseUri == null) return trimmed;

  if (_alreadyAbsoluteForBase(trimmed, baseUri)) {
    return trimmed.startsWith('http://') || trimmed.startsWith('https://')
        ? trimmed
        : Uri(
            scheme: baseUri.scheme,
            host: baseUri.host,
            port: baseUri.hasPort ? baseUri.port : null,
            path: trimmed.startsWith('/') ? trimmed : '/$trimmed',
          ).toString();
  }

  if (_isHostAbsolutePath(trimmed, baseUri.host)) {
    final path = trimmed.startsWith(baseUri.host)
        ? trimmed.substring(baseUri.host.length)
        : trimmed;
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    return Uri(
      scheme: baseUri.scheme,
      host: baseUri.host,
      port: baseUri.hasPort ? baseUri.port : null,
      path: normalizedPath,
    ).toString();
  }

  if (trimmed.startsWith('/')) {
    return Uri(
      scheme: baseUri.scheme,
      host: baseUri.host,
      port: baseUri.hasPort ? baseUri.port : null,
      path: trimmed,
    ).toString();
  }

  return _resolveRelativeToApiBase(baseUri, trimmed);
}

/// Persists a normalized absolute URL when saving API user payloads.
String? normalizeAvatarUrlForStorage(
  String? raw, {
  String? apiBaseOverride,
}) =>
    resolveAvatarDisplayUrl(raw, apiBaseOverride: apiBaseOverride);

Uri? _parseApiBase(String? apiBaseOverride) {
  final apiBase =
      (apiBaseOverride ?? Environment.instance.apiBaseUrl).trim();
  if (apiBase.isEmpty) return null;

  final withSlash = apiBase.endsWith('/') ? apiBase : '$apiBase/';
  final uri = Uri.tryParse(withSlash);
  if (uri == null || !uri.hasScheme || uri.host.isEmpty) return null;
  return uri;
}

bool _alreadyAbsoluteForBase(String value, Uri baseUri) {
  final origin = baseUri.origin;
  if (value.startsWith(origin)) return true;

  final baseNoSlash = baseUri.toString().replaceAll(RegExp(r'/+$'), '');
  if (value == baseNoSlash || value.startsWith('$baseNoSlash/')) {
    return true;
  }

  final apiPath = baseUri.path.replaceAll(RegExp(r'^/+|/+$'), '');
  if (apiPath.isEmpty) return false;
  final rel = value.replaceAll(RegExp(r'^/+'), '');
  return rel == apiPath || rel.startsWith('$apiPath/');
}

bool _isHostAbsolutePath(String value, String host) {
  if (host.isEmpty) return false;
  return value.startsWith('$host/') ||
      value == host ||
      value.startsWith('$host:');
}

String _resolveRelativeToApiBase(Uri baseUri, String relative) {
  final rel = relative.replaceAll(RegExp(r'^/+'), '');
  final apiPath = baseUri.path.replaceAll(RegExp(r'^/+|/+$'), '');

  if (apiPath.isNotEmpty && (rel == apiPath || rel.startsWith('$apiPath/'))) {
    return Uri(
      scheme: baseUri.scheme,
      host: baseUri.host,
      port: baseUri.hasPort ? baseUri.port : null,
      path: '/$rel',
    ).toString();
  }

  return baseUri.resolve(rel).toString();
}
