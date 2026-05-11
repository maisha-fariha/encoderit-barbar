/// REST paths for the app. Point [AppConfig.apiBaseUrl] at your backend; shapes should match [AuthService].
class ApiEndpoints {
  ApiEndpoints._();

  static const authLogin = '/auth/login';
  static const authRegister = '/auth/register';

  static const authVerifyOtp = '/auth/verify-otp';
  static const authForgotPassword = '/auth/forgot-password';
  static const authResetPassword = '/auth/reset-password';

  static const shops = '/shops';
  static const services = '/services';
  static const barbers = '/barbers';
  static const barbarList = shops;

  /// Single appointment booking endpoint.
  static const appointments = '/appointments';

  /// Recurring appointments booking endpoint.
  /// Body: `{shop_id, barber_id, service_id, date, time, notes, repeat: {type, value}}`.
  static const appointmentsRecurring = '/appointments/recurring';
  static const appointmentsRecurringPreview = '/appointments/recurring/preview';
  static const availabilitySlots = '/availability/slots';

  /// Multipart upload endpoint for the current user's profile avatar.
  static const profileAvatar = '/profile/avatar';

  /// Authenticated profile update (`Authorization: Bearer …`).
  static const profile = '/profile';

  /// Public contact form submission.
  static const contacts = '/contacts';

  /// Services list (demo: ReqRes `/products` — same `data` list pattern).
  static const barberServices = '/products';
}
