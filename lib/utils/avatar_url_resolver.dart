import 'package:gems_core/gems_core.dart';

/// Builds a displayable URL from API `avatar_url` (relative path or absolute).
String? resolveAvatarDisplayUrl(String? raw) {
  if (raw == null) return null;
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return null;
  if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
    return trimmed;
  }

  final apiBase = Environment.instance.apiBaseUrl.trim();
  if (apiBase.isEmpty) return trimmed;

  final baseUri = Uri.tryParse(apiBase);
  if (baseUri == null || !baseUri.hasScheme) return trimmed;

  if (trimmed.startsWith('/')) {
    return Uri(
      scheme: baseUri.scheme,
      host: baseUri.host,
      port: baseUri.hasPort ? baseUri.port : null,
      path: trimmed,
    ).toString();
  }

  final origin = Uri(
    scheme: baseUri.scheme,
    host: baseUri.host,
    port: baseUri.hasPort ? baseUri.port : null,
  );
  return origin.resolve(trimmed).toString();
}
