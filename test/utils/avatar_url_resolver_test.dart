import 'package:encoderit_barbar/utils/avatar_url_resolver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const apiBase = 'https://iconico.encoder-test-vpn.space/api/v1';

  group('resolveAvatarDisplayUrl', () {
    test('returns full backend https URLs unchanged', () {
      const url =
          'https://iconico.encoder-test-vpn.space/storage/avatars/a.jpg';
      expect(
        resolveAvatarDisplayUrl(url, assetOriginOverride: apiBase),
        url,
      );
    });

    test('does not double-prefix when URL already absolute', () {
      const url =
          'https://iconico.encoder-test-vpn.space/api/v1/storage/a.jpg';
      expect(
        resolveAvatarDisplayUrl(url, assetOriginOverride: apiBase),
        url,
      );
    });

    test('resolves root-relative paths against site origin not api/v1', () {
      expect(
        resolveAvatarDisplayUrl(
          '/storage/avatars/a.jpg',
          assetOriginOverride: apiBase,
        ),
        'https://iconico.encoder-test-vpn.space/storage/avatars/a.jpg',
      );
    });

    test('resolves relative paths against site origin not api/v1', () {
      expect(
        resolveAvatarDisplayUrl(
          'storage/avatars/a.jpg',
          assetOriginOverride: apiBase,
        ),
        'https://iconico.encoder-test-vpn.space/storage/avatars/a.jpg',
      );
    });

    test('uses default origin when override is empty', () {
      expect(
        resolveAvatarDisplayUrl('/storage/a.jpg', assetOriginOverride: ''),
        'https://iconico.encoder-test-vpn.space/storage/a.jpg',
      );
    });

    test('returns null for empty input', () {
      expect(
        resolveAvatarDisplayUrl(null, assetOriginOverride: apiBase),
        isNull,
      );
      expect(
        resolveAvatarDisplayUrl('', assetOriginOverride: apiBase),
        isNull,
      );
    });
  });
}
