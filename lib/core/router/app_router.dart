import 'package:go_router/go_router.dart';
import 'package:perpusku/core/constant/app_constant.dart';
import 'package:perpusku/core/domain/entities/book.dart';
import 'package:perpusku/presentation/pages/book_form/book_form_page.dart';
import 'package:perpusku/presentation/pages/home/home_page.dart';
import 'package:perpusku/presentation/pages/login/login_page.dart';
import 'package:perpusku/presentation/pages/onboarding/onboarding_page.dart';
import 'package:perpusku/presentation/splash/splash_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String addBook = '/books/add';
  static const String editBook = '/books/edit';
  static const String login = '/login';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      name: 'splash',
      builder: (_, _) => const SplashPage(),
    ),
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (_, _) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      name: 'onboarding',
      builder: (_, _) => const OnboardingPage(),
    ),
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (_, _) => const HomePage(),
    ),
    GoRoute(
      path: AppRoutes.addBook,
      name: 'addBook',
      builder: (_, _) => const BookFormPage(),
    ),
    GoRoute(
      path: AppRoutes.editBook,
      name: 'editBook',
      builder: (context, state) {
        final book = state.extra as Book;
        return BookFormPage(book: book);
      },
    ),
  ],
);

Future<bool> isOnboardingComplete() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(AppConstants.keyOnboardingDone) ?? false;
}

Future<void> completeOnboarding() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(AppConstants.keyOnboardingDone, true);
}