import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:fyllens/core/theme/app_theme.dart';
import 'package:fyllens/core/constants/app_routes.dart';
import 'package:fyllens/providers/theme_provider.dart';
import 'package:fyllens/providers/auth_provider.dart';

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
///
/// Auth-aware routing:
/// - GoRouter listens to AuthProvider via refreshListenable
/// - Protected routes (/home, /profile, /scan, /history) redirect to /login if not authenticated
/// - Public routes (/, /onboarding, /login, /register) accessible to all
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Get AuthProvider to connect to GoRouter
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp.router(
          title: 'Fyllens',
          debugShowCheckedModeBanner: false,

          // Theme setup - supports light and dark modes
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode, // Reactive to user preference
          // GoRouter handles all navigation with auth state awareness
          routerConfig: _createRouter(authProvider),
        );
      },
    );
  }

  /// App navigation setup using GoRouter with auth-aware redirects
  ///
  /// All routes are defined here. Using GoRouter instead of Navigator for:
  /// - Declarative routing (easier to understand flow)
  /// - Deep linking support
  /// - URL-based navigation (useful for web builds later)
  /// - Auth state-based redirects (listens to AuthProvider changes)
  ///
  /// Protected routes: /home, /editProfile (require authentication)
  /// Public routes: /, /onboarding, /login, /register, /forgot-password
  static GoRouter _createRouter(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: AppRoutes.splash, // Always start with splash
      refreshListenable: authProvider, // Listen to auth state changes
      redirect: (BuildContext context, GoRouterState state) {
        final isAuthenticated = authProvider.isAuthenticated;
        final isGoingToLogin = state.matchedLocation == AppRoutes.login;
        final isGoingToRegister = state.matchedLocation == AppRoutes.register;
        final isGoingToForgotPassword =
            state.matchedLocation == AppRoutes.forgotPassword;
        final isGoingToOnboarding =
            state.matchedLocation == AppRoutes.onboarding;
        final isGoingToSplash = state.matchedLocation == AppRoutes.splash;

        // Define protected routes
        final isGoingToProtectedRoute =
            state.matchedLocation == AppRoutes.home ||
            state.matchedLocation == AppRoutes.editProfile;

        // If user is not authenticated and trying to access protected route
        if (!isAuthenticated && isGoingToProtectedRoute) {
          // Redirect to login
          debugPrint('🔒 Redirect: Not authenticated, redirecting to login');
          return AppRoutes.login;
        }

        // If user IS authenticated and trying to access login/register
        if (isAuthenticated && (isGoingToLogin || isGoingToRegister)) {
          // Already logged in, redirect to home
          debugPrint('✅ Redirect: Already authenticated, redirecting to home');
          return AppRoutes.home;
        }

        // Allow splash and onboarding regardless of auth state
        if (isGoingToSplash || isGoingToOnboarding || isGoingToForgotPassword) {
          return null; // No redirect
        }

        // No redirect needed
        return null;
      },
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
        // PROTECTED: Requires authentication (enforced by redirect logic)
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => const MainScreen(),
        ),

        // Profile sub-routes
        // PROTECTED: Requires authentication (enforced by redirect logic)
        GoRoute(
          path: AppRoutes.editProfile,
          builder: (context, state) => const EditProfileScreen(),
        ),
      ],
    );
  }
}
