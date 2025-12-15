import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:app_links/app_links.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fyllens/core/theme/app_theme.dart';
import 'package:fyllens/core/constants/app_routes.dart';
import 'package:fyllens/providers/auth_provider.dart';

// Import pages
import 'package:fyllens/screens/splash/splash_screen.dart';
import 'package:fyllens/screens/onboarding/onboarding_screen.dart';
import 'package:fyllens/screens/auth/login_screen.dart';
import 'package:fyllens/screens/auth/register_screen.dart';
import 'package:fyllens/screens/auth/forgot_password_screen.dart';
import 'package:fyllens/screens/auth/reset_password_screen.dart';
import 'package:fyllens/screens/main/main_screen.dart';
import 'package:fyllens/screens/profile/edit_profile_screen.dart';
import 'package:fyllens/screens/scan/camera_screen.dart';
import 'package:fyllens/screens/scan/scan_results_screen.dart';
import 'package:fyllens/screens/chat/chat_screen.dart';
import 'package:fyllens/screens/notifications/notification_center_screen.dart';

// Import providers for scan data
import 'package:fyllens/providers/scan_provider.dart';

/// Root app widget
///
/// Sets up the MaterialApp with GoRouter for navigation.
/// This is the entry point for the entire app.
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
///
/// Deep linking:
/// - Handles password reset deep links via AppLinks
/// - URL scheme: io.supabase.fyllens://reset-password
/// - Establishes session and navigates to reset password screen
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppLinks _appLinks;
  late final GoRouter _router;
  bool _hasProcessedInitialLink = false;

  @override
  void initState() {
    super.initState();

    // Get AuthProvider to connect to GoRouter
    final authProvider = context.read<AuthProvider>();

    // Create router
    _router = _createRouter(authProvider);

    // Initialize deep link handling
    _initDeepLinks();
  }

  /// Initialize deep link handling for password reset
  ///
  /// Listens for incoming deep links and handles them appropriately:
  /// - Cold start: App is closed, user clicks email link
  /// - Hot start: App is running, user clicks email link
  ///
  /// URL scheme: io.supabase.fyllens://reset-password
  ///
  /// Note: On hot reload, this will skip processing the initial link to prevent
  /// showing "Link Expired" error. The app will follow normal routing instead.
  Future<void> _initDeepLinks() async {
    _appLinks = AppLinks();

    // Handle app launch from deep link (cold start)
    // Skip if already processed (e.g., on hot reload)
    try {
      final initialLink = await _appLinks.getInitialLink();
      if (initialLink != null && !_hasProcessedInitialLink) {
        if (kDebugMode) {
          debugPrint('🔗 [DEEP LINK] Initial link received (cold start): $initialLink');
        }
        _handleDeepLink(initialLink);
        _hasProcessedInitialLink = true;
      } else if (initialLink != null && _hasProcessedInitialLink) {
        if (kDebugMode) {
          debugPrint('🔄 [DEEP LINK] Initial link already processed, skipping (hot reload detected)');
          debugPrint('   App will follow normal routing flow');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ [DEEP LINK] Error getting initial link: $e');
      }
    }

    // Handle deep links when app is running (hot start)
    _appLinks.uriLinkStream.listen(
      (Uri uri) {
        if (kDebugMode) {
          debugPrint('🔗 [DEEP LINK] Link received (hot start): $uri');
        }
        _handleDeepLink(uri);
      },
      onError: (err) {
        if (kDebugMode) {
          debugPrint('❌ [DEEP LINK] Stream error: $err');
        }
      },
    );
  }

  /// Handle incoming deep link
  ///
  /// Validates the link scheme and host, establishes session with Supabase,
  /// and navigates to the reset password screen.
  void _handleDeepLink(Uri uri) async {
    if (kDebugMode) {
      debugPrint('🔗 [DEEP LINK] Processing deep link...');
      debugPrint('   Scheme: ${uri.scheme}');
      debugPrint('   Host: ${uri.host}');
      debugPrint('   Path: ${uri.path}');
      debugPrint('   Query: ${uri.query}');
    }

    // Check if this is a password reset link
    if (uri.scheme == 'io.supabase.fyllens' && uri.host == 'reset-password') {
      try {
        if (kDebugMode) {
          debugPrint('🔐 [DEEP LINK] Password reset link detected');
          debugPrint('   Attempting to establish session...');
        }

        // Try to establish session from URL
        final response = await Supabase.instance.client.auth.getSessionFromUrl(uri);

        if (kDebugMode) {
          debugPrint('✅ [DEEP LINK] Session established successfully');
          debugPrint('   Access Token: ${response.session.accessToken.isNotEmpty ? "Present" : "Missing"}');
        }

        // Navigate to reset password screen
        if (mounted) {
          _router.go(AppRoutes.resetPassword);

          if (kDebugMode) {
            debugPrint('✅ [DEEP LINK] Navigated to reset password screen');
          }
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint('❌ [DEEP LINK] Error establishing session: $e');
        }

        // Fallback: Try to extract code from query params and pass to screen
        final code = uri.queryParameters['code'];
        if (code != null && mounted) {
          if (kDebugMode) {
            debugPrint('🔄 [DEEP LINK] Fallback: Using code parameter');
          }
          _router.go('${AppRoutes.resetPassword}?code=$code');
        }
      }
    } else {
      if (kDebugMode) {
        debugPrint('⚠️  [DEEP LINK] Unknown deep link scheme/host, ignoring');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Fyllens',
      debugShowCheckedModeBanner: false,

      // Theme setup - light mode only
      theme: AppTheme.lightTheme,

      // GoRouter handles all navigation with auth state awareness
      routerConfig: _router,
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
        final isGoingToResetPassword =
            state.matchedLocation == AppRoutes.resetPassword;
        final isGoingToOnboarding =
            state.matchedLocation == AppRoutes.onboarding;
        final isGoingToSplash = state.matchedLocation == AppRoutes.splash;

        // Define auth-related routes (public routes that don't need auth)
        final isGoingToAuthRoute = isGoingToLogin ||
            isGoingToRegister ||
            isGoingToForgotPassword ||
            isGoingToResetPassword ||
            isGoingToOnboarding ||
            isGoingToSplash;

        // Define protected routes
        final isGoingToProtectedRoute =
            state.matchedLocation == AppRoutes.home ||
            state.matchedLocation == AppRoutes.editProfile ||
            state.matchedLocation == AppRoutes.chat ||
            state.matchedLocation == AppRoutes.notifications;

        // If not authenticated and not going to auth-related route, redirect to splash
        // This ensures logout → splash → onboarding flow
        if (!isAuthenticated && !isGoingToAuthRoute) {
          debugPrint('🔄 Redirect: Not authenticated, redirecting to splash');
          return AppRoutes.splash;
        }

        // If user is not authenticated and trying to access protected route
        if (!isAuthenticated && isGoingToProtectedRoute) {
          // Redirect to splash (splash will then route to onboarding)
          debugPrint('🔒 Redirect: Not authenticated, redirecting to splash');
          return AppRoutes.splash;
        }

        // If user IS authenticated and trying to access login/register/onboarding
        if (isAuthenticated && (isGoingToLogin || isGoingToRegister || isGoingToOnboarding)) {
          // Already logged in, redirect to home
          debugPrint('✅ Redirect: Already authenticated, redirecting to home');
          return AppRoutes.home;
        }

        // Allow splash, forgot password, and reset password regardless of auth state
        if (isGoingToSplash || isGoingToForgotPassword || isGoingToResetPassword) {
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
        GoRoute(
          path: AppRoutes.resetPassword,
          builder: (context, state) {
            // Get optional reset code from query parameters (fallback mechanism)
            final resetCode = state.uri.queryParameters['code'];
            return ResetPasswordScreen(resetCode: resetCode);
          },
        ),

        // Main screen with 5-tab bottom navigation (home, library, scan, history, profile)
        // PROTECTED: Requires authentication (enforced by redirect logic)
        // Supports optional 'tab' query parameter to open specific tab
        // Example: /home?tab=2 opens Scan tab (0=Home, 1=Library, 2=Scan, 3=History, 4=Profile)
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) {
            // LOG: Route parameter parsing
            debugPrint('🛣️  [APP ROUTER] /home route builder called');
            debugPrint('   Full URI: ${state.uri}');
            debugPrint('   Query parameters: ${state.uri.queryParameters}');

            final tabParam = state.uri.queryParameters['tab'];
            final initialTab = tabParam != null ? int.tryParse(tabParam) ?? 0 : 0;

            debugPrint('   tab parameter: $tabParam');
            debugPrint('   initialTab parsed: $initialTab');
            debugPrint('✅ [APP ROUTER] Creating MainScreen with initialTab=$initialTab');

            return MainScreen(initialTab: initialTab);
          },
        ),

        // Profile sub-routes
        // PROTECTED: Requires authentication (enforced by redirect logic)
        GoRoute(
          path: AppRoutes.editProfile,
          builder: (context, state) => const EditProfileScreen(),
        ),

        // Chat screen for AI conversation
        // PROTECTED: Requires authentication (enforced by redirect logic)
        GoRoute(
          path: AppRoutes.chat,
          builder: (context, state) => const ChatScreen(),
        ),

        // Notification Center screen
        // PROTECTED: Requires authentication (enforced by redirect logic)
        GoRoute(
          path: AppRoutes.notifications,
          builder: (context, state) => const NotificationCenterScreen(),
        ),

        // Camera screen for plant scanning
        // PROTECTED: Requires authentication (enforced by redirect logic)
        GoRoute(
          path: '${AppRoutes.scanCamera}/:plantName',
          builder: (context, state) {
            final plantName = state.pathParameters['plantName'] ?? 'Unknown';
            return CameraScreen(plantName: plantName);
          },
        ),

        // Scan result screen showing ML analysis results
        // PROTECTED: Requires authentication (enforced by redirect logic)
        GoRoute(
          path: AppRoutes.scanResult,
          builder: (context, state) {
            // Get scan result from provider
            final scanProvider = Provider.of<ScanProvider>(context, listen: false);
            final scanResult = scanProvider.currentScanResult;

            // Handle case where no scan data is available
            if (scanResult == null) {
              return const Scaffold(
                body: Center(
                  child: Text('No scan data available'),
                ),
              );
            }

            // Use Gemini-enhanced severity or calculate from confidence
            // IMPORTANT: Don't calculate severity for healthy plants
            String severity = scanResult.severity ?? 'Unknown';
            if (severity == 'Unknown' && !scanResult.isHealthy) {
              // Only calculate severity for deficient plants
              final confidence = scanResult.confidence;
              if (confidence != null) {
                if (confidence >= 0.8) {
                  severity = 'Severe';
                } else if (confidence >= 0.6) {
                  severity = 'Moderate';
                } else {
                  severity = 'Mild';
                }
              }
            }

            // Use Gemini-enhanced symptoms or fallback to empty list
            final symptoms = scanResult.symptoms ?? <String>[];

            // Use Gemini-enhanced treatments or fallback to ML recommendations
            final treatments = scanResult.geminiTreatments?.map((t) {
              return {
                'title': t['title']?.toString() ?? 'Treatment',
                'description': t['description']?.toString() ?? 'No details available',
                'icon': t['icon']?.toString() ?? 'fertilizer',
              };
            }).toList() ?? [
              {
                'title': 'ML Recommendation',
                'description': scanResult.recommendations ?? 'No recommendations available',
                'icon': 'fertilizer',
              },
            ];

            // Extract care tips for healthy plants
            final careTips = scanResult.isHealthy ? scanResult.careTips : null;
            final preventiveCare = scanResult.isHealthy ? scanResult.preventiveCare : null;
            final growthOptimization = scanResult.isHealthy ? scanResult.growthOptimization : null;

            // Extract prevention tips for deficient plants
            final preventionTips = !scanResult.isHealthy ? scanResult.preventionTips : null;

            return ScanResultsScreen(
              plantName: scanResult.plantName,
              imageAssetPath: scanResult.imageUrl,
              deficiencyName: scanResult.deficiencyDetected ?? 'Unknown Deficiency',
              severity: severity,
              symptoms: symptoms,
              treatments: treatments,
              careTips: careTips,
              preventiveCare: preventiveCare,
              growthOptimization: growthOptimization,
              preventionTips: preventionTips,
            );
          },
        ),
      ],
    );
  }
}
