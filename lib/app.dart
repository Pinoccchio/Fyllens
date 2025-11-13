import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:fyllens/core/theme/app_theme.dart';
import 'package:fyllens/core/constants/app_routes.dart';
import 'package:fyllens/providers/theme_provider.dart';

// Import pages
import 'package:fyllens/presentation/pages/splash/splash_page.dart';
import 'package:fyllens/presentation/pages/onboarding/onboarding_page.dart';
import 'package:fyllens/presentation/pages/auth/login_page.dart';
import 'package:fyllens/presentation/pages/auth/register_page.dart';
import 'package:fyllens/presentation/pages/auth/forgot_password_page.dart';
import 'package:fyllens/presentation/pages/home/home_page.dart';
import 'package:fyllens/presentation/pages/library/library_page.dart';
import 'package:fyllens/presentation/pages/scan/scan_page.dart';
import 'package:fyllens/presentation/pages/history/history_page.dart';
import 'package:fyllens/presentation/pages/profile/profile_page.dart';
import 'package:fyllens/presentation/pages/profile/edit_profile_page.dart';

/// Main app widget
/// Configures MaterialApp with theme and routing
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp.router(
          title: 'Fyllens',
          debugShowCheckedModeBanner: false,

          // Theme configuration
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,

          // Routing configuration
          routerConfig: _router,
        );
      },
    );
  }

  /// Router configuration
  static final GoRouter _router = GoRouter(
    initialLocation: AppRoutes.login, // Start with login page
    routes: [
      // Splash screen
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),

      // Onboarding
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),

      // Auth routes
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordPage(),
      ),

      // Main app routes
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: AppRoutes.library,
        builder: (context, state) => const LibraryPage(),
      ),
      GoRoute(
        path: AppRoutes.scan,
        builder: (context, state) => const ScanPage(),
      ),
      GoRoute(
        path: AppRoutes.history,
        builder: (context, state) => const HistoryPage(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        builder: (context, state) => const EditProfilePage(),
      ),
    ],
  );
}
