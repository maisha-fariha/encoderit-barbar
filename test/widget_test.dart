import 'package:flutter_test/flutter_test.dart';

import 'package:iconico_hair/utils/api_endpoints.dart';

void main() {
  test('API path constants are wired', () {
    expect(ApiEndpoints.barbarList, '/users');
    expect(ApiEndpoints.authLogin, '/login');
    expect(ApiEndpoints.authRegister, '/register');
    expect(ApiEndpoints.barberServices, '/products');
  });
}
