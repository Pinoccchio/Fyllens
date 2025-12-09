import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:fyllens/core/theme/app_theme.dart';
import 'package:fyllens/core/constants/app_routes.dart';
import 'package:fyllens/providers/theme_provider.dart';

// Import pages
import 'package:fyllens/screens/splash/splash_screen.dart';
import 'package:fyllens/screens/onboarding/onboarding_screen.dart';
import 'package:fyllens/screens/auth/login_screen.dart';
import 'package:fyllens/screens/auth/register_screen.dart';
import 'package:fyllens/screens/auth/forgot_password_screen.dart';
import 'package:fyllens/screens/main/main_screen.dart';
import 'package:fyllens/screens/profile/edit_profile_screen.dart';

/// Root app widget
///
/// Sets up the MaterialApp with GoRouter for navigation and ThemeProvider
/// for light/dark mode switching. This is the entry point for the entire app.
///
/// Navigation flow:
/// - Splash → Onboarding (first time) or Login (returning user)
/// - Login/Register → Main Screen (5 tabs)
/// - Main Screen stays persistent while navigating between tabs
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp.router(
          title: 'Fyllens',
          debugShowCheckedModeBanner: false,

          // Theme setup - supports light and dark modes
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode, // Reactive to user preference

          // GoRouter handles all navigation
          routerConfig: _router,
        );
      },
    );
  }

  /// App navigation setup using GoRouter
  ///
  /// All routes are defined here. Using GoRouter instead of Navigator for:
  /// - Declarative routing (easier to understand flow)
  /// - Deep linking support
  /// - URL-based navigation (useful for web builds later)
  static final GoRouter _router = GoRouter(
    initialLocation: AppRoutes.splash, // Always start with splash
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Auth flow: register → login → main app
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      // Main screen with 5-tab bottom navigation (home, library, scan, history, profile)
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const MainScreen(),
      ),

      // Profile sub-routes
      GoRoute(
        path: AppRoutes.editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),
    ],
  );
}
