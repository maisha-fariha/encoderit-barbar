/// REST paths for the app. Point [AppConfig.apiBaseUrl] at your backend; shapes should match [AuthService].
class ApiEndpoints {
  ApiEndpoints._();

  static const authLogin = '/login';
  static const authRegister = '/register';

  /// List endpoint (ReqRes wraps items in `data`).
  static const barbarList = '/users';
}
