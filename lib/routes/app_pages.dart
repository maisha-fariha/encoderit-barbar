import 'package:get/get.dart';

import '../pages/appoinment_page.dart';
import '../pages/home_page.dart';
import '../pages/login_page.dart';
import '../pages/onboarding_page.dart';
import '../pages/contact_page.dart';
import '../pages/profile_page.dart';
import '../pages/reservation_list_page.dart';
import '../pages/register_page.dart';


class AppRoutes {
  AppRoutes._();

  static const onboarding = '/onboarding';
  static const appoinment = '/appoinment';
  static const home = '/home';
  static const reservations = '/reservations';
  static const profile = '/profile';
  static const contact = '/contact';
  static const login = '/login';
  static const register = '/register';
}

class AppPages {
  AppPages._();

  static final routes = <GetPage>[
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingPage(),
    ),
    GetPage(
      name: AppRoutes.appoinment,
      page: () => const AppoinmentPage(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterPage(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      transition: Transition.noTransition,
      transitionDuration: Duration.zero,
    ),
    GetPage(
      name: AppRoutes.reservations,
      page: () => const ReservationListPage(),
      transition: Transition.noTransition,
      transitionDuration: Duration.zero,
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfilePage(),
      transition: Transition.noTransition,
      transitionDuration: Duration.zero,
    ),
    GetPage(
      name: AppRoutes.contact,
      page: () => const ContactPage(),
      transition: Transition.noTransition,
      transitionDuration: Duration.zero,
    ),
  ];
}
