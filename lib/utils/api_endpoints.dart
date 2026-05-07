/// REST paths for the app. Point [AppConfig.apiBaseUrl] at your backend; shapes should match [AuthService].
class ApiEndpoints {
  ApiEndpoints._();

  static const authLogin = '/auth/login';
  static const authRegister = '/auth/register';

  static const shops = '/shops';
  static const barbarList = shops;

  /// Services list (demo: ReqRes `/products` — same `data` list pattern).
  static const barberServices = '/products';
}
