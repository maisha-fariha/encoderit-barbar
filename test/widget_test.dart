import 'package:flutter_test/flutter_test.dart';

import 'package:encoderit_barbar/utils/api_endpoints.dart';

void main() {
  test('list endpoint constant is wired', () {
    expect(ApiEndpoints.barbarList, '/users');
  });
}
