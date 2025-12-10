import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/constants/app_constants.dart';
import 'package:fyllens/core/constants/app_routes.dart';
import 'package:fyllens/providers/auth_provider.dart';
import 'package:fyllens/screens/shared/widgets/floating_circles.dart';
import 'package:fyllens/screens/shared/widgets/modern_icon_container.dart';
import 'package:fyllens/core/theme/app_icons.dart';

/// Modern animated splash screen with floating decorations
/// Shows app branding with smooth animations and auto-navigation
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _iconController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    // Icon scale animation controller
    _iconController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Fade and slide animation controller
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Fade animation for text
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    // Slide up animation for text
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
  }

  Future<void> _startAnimationSequence() async {
    // Start icon animation
    await _iconController.forward();

    // Start text animations
    await _fadeController.forward();

    // Wait for user to enjoy the splash (total ~2.5 seconds)
    await Future.delayed(const Duration(milliseconds: 1000));

    // Navigate to appropriate screen
    if (mounted) {
      await _navigateToNextScreen();
    }
  }

  Future<void> _navigateToNextScreen() async {
    try {
      // Get authentication provider (without listening to changes)
      final authProvider = context.read<AuthProvider>();

      // Small delay to ensure AuthProvider has fully initialized
      // AuthProvider.initialize() is called in main.dart before app starts,
      // but we add a safety check here
      await Future.delayed(const Duration(milliseconds: 100));

      if (!mounted) return;

      // Check authentication status
      final isAuthenticated = authProvider.isAuthenticated;
      final currentUser = authProvider.currentUser;

      // Debug logging
      debugPrint('\n🔍 Splash Screen: Checking auth state');
      debugPrint('   - isAuthenticated: $isAuthenticated');
      debugPrint('   - currentUser: ${currentUser?.email ?? "null"}');

      // Ensure we're still mounted before navigation
      if (!mounted) {
        debugPrint('   ⚠️ Widget unmounted, aborting navigation');
        return;
      }

      // Navigation logic based on auth state
      if (isAuthenticated && currentUser != null) {
        // User is logged in → go to home
        debugPrint('   ✅ User authenticated → Navigating to HOME');
        context.go(AppRoutes.home);
      } else {
        // Not authenticated → show onboarding
        debugPrint('   🔓 Not authenticated → Navigating to ONBOARDING');
        context.go(AppRoutes.onboarding);
      }
    } catch (e, stackTrace) {
      // On error, default to onboarding (safe fallback)
      debugPrint('❌ Splash Navigation Error: $e');
      debugPrint('   Stack trace: $stackTrace');
      debugPrint('   → Navigating to: ONBOARDING (error fallback)');

      if (mounted) {
        context.go(AppRoutes.onboarding);
      }
    }
  }

  @override
  void dispose() {
    _iconController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryGreenDark,
              AppColors.primaryGreen,
              AppColors.primaryGreenModern,
            ],
          ),
        ),
        child: FloatingCirclesBackground(
          circles: [
            FloatingCircleData(
              top: 0.15,
              left: 30,
              size: 80,
              color: Colors.white.withValues(alpha: 0.1),
            ),
            FloatingCircleData(
              top: 0.2,
              right: 40,
              size: 60,
              color: Colors.white.withValues(alpha: 0.08),
            ),
            FloatingCircleData(
              bottom: 0.25,
              left: 50,
              size: 70,
              color: Colors.white.withValues(alpha: 0.12),
            ),
          ],
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Modern animated icon with glow effect
                  ModernIconContainer(
                    icon: AppIcons.leafFilled,
                    iconSize: 80,
                    iconColor: AppColors.primaryGreenModern,
                    primaryColor: Colors.white,
                    secondaryColor: AppColors.accentMint,
                    containerSize: 200,
                    animationController: _iconController,
                  ),

                  const SizedBox(height: 40),

                  // Animated app name with fade and slide
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Text(
                        AppConstants.appName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 8,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Animated description
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Text(
                        AppConstants.appDescription,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 60),

                  // Loading indicator
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: const SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
