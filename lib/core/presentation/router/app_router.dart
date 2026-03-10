import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:webant_gallery/features/auth/infrastructure/repos/token_manager.dart';
import 'package:webant_gallery/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:webant_gallery/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:webant_gallery/features/auth/presentation/screens/splash_screen.dart';
import 'package:webant_gallery/features/auth/presentation/screens/welcome_screen.dart';
import 'package:webant_gallery/features/gallery/presentation/screens/home/home_page.dart';
import 'package:webant_gallery/features/gallery/presentation/screens/photo_detail/photo_detail_page.dart';

abstract class AppRoutes {
  static const root = '/';
  static const splash = '/splash';
  static const welcome = '/welcome';
  static const signIn = '/sign-in';
  static const signUp = '/sign-up';
  static const home = '/home';
  static const photoDetail = '/photo/:id';

  static String photoDetailPath(int id) => '/photo/$id';

  static const _authRoutes = {welcome, signIn, signUp};
  static const _protectedRoutes = {home};

  static bool isAuthRoute(String location) =>
      _authRoutes.any((r) => location.startsWith(r));

  static bool isProtectedRoute(String location) =>
      _protectedRoutes.any((r) => location.startsWith(r)) ||
      location.startsWith('/photo/');
}

GoRouter createRouter() {
  final tokenManager = GetIt.I<TokenManager>();

  return GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (BuildContext context, GoRouterState state) {
      final isAuthenticated = tokenManager.isAuthenticated;
      final location = state.matchedLocation;

      if (location == AppRoutes.splash) return null;

      if (location == AppRoutes.root) {
        return isAuthenticated ? AppRoutes.home : AppRoutes.welcome;
      }

      if (isAuthenticated && AppRoutes.isAuthRoute(location)) {
        return AppRoutes.home;
      }

      if (!isAuthenticated && AppRoutes.isProtectedRoute(location)) {
        return AppRoutes.welcome;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.root,
        redirect: (_, __) => AppRoutes.home,
      ),
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.signIn,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: AppRoutes.photoDetail,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return PhotoDetailPage(photoId: id);
        },
      ),
    ],
  );
}
