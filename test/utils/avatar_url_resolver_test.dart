import 'package:encoderit_barbar/utils/avatar_url_resolver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const apiBase = 'https://iconico.encoder-test-vpn.space/api/v1';

  group('resolveAvatarDisplayUrl', () {
    test('returns absolute https URLs unchanged', () {
      const url = 'https://iconico.encoder-test-vpn.space/storage/a.jpg';
      expect(
        resolveAvatarDisplayUrl(url, apiBaseOverride: apiBase),
        url,
      );
    });

    test('does not double-prefix when URL already includes API base', () {
      const url =
          'https://iconico.encoder-test-vpn.space/api/v1/storage/a.jpg';
      expect(
        resolveAvatarDisplayUrl(url, apiBaseOverride: apiBase),
        url,
      );
    });

    test('resolves root-relative storage paths against host', () {
      expect(
        resolveAvatarDisplayUrl('/storage/avatars/a.jpg',
            apiBaseOverride: apiBase),
        'https://iconico.encoder-test-vpn.space/storage/avatars/a.jpg',
      );
    });

    test('resolves relative paths against API base', () {
      expect(
        resolveAvatarDisplayUrl('storage/avatars/a.jpg',
            apiBaseOverride: apiBase),
        'https://iconico.encoder-test-vpn.space/api/v1/storage/avatars/a.jpg',
      );
    });

    test('resolves path that already starts with api segment without doubling',
        () {
      expect(
        resolveAvatarDisplayUrl('api/v1/storage/a.jpg',
            apiBaseOverride: apiBase),
        'https://iconico.encoder-test-vpn.space/api/v1/storage/a.jpg',
      );
    });

    test('returns null for empty input', () {
      expect(resolveAvatarDisplayUrl(null, apiBaseOverride: apiBase), isNull);
      expect(resolveAvatarDisplayUrl('', apiBaseOverride: apiBase), isNull);
    });
  });
}
