import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/theme/app_text_styles.dart';
import 'package:fyllens/core/constants/app_spacing.dart';
import 'package:fyllens/core/constants/app_routes.dart';

/// Modern onboarding flow with icon-based screens
/// Shows app features to first-time users
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Onboarding content data
  final List<OnboardingContent> _pages = [
    OnboardingContent(
      icon: Icons.camera_alt_outlined,
      iconColor: AppColors.primaryGreenModern,
      title: 'Scan Your Plants',
      subtitle: 'Use your camera to detect nutrient deficiencies instantly',
      gradientColors: [
        AppColors.primaryGreenModern.withValues(alpha: 0.2),
        AppColors.accentMint.withValues(alpha: 0.1),
      ],
    ),
    OnboardingContent(
      icon: Icons.local_library_outlined,
      iconColor: AppColors.accentMint,
      title: 'Expert Knowledge',
      subtitle: 'Access detailed guides for 7+ plant species',
      gradientColors: [
        AppColors.accentMint.withValues(alpha: 0.2),
        AppColors.primaryGreenLight.withValues(alpha: 0.1),
      ],
    ),
    OnboardingContent(
      icon: Icons.eco_outlined,
      iconColor: AppColors.primaryGreen,
      title: 'Monitor Progress',
      subtitle: 'Save scan history and watch your plants thrive',
      gradientColors: [
        AppColors.primaryGreen.withValues(alpha: 0.2),
        AppColors.primaryGreenModern.withValues(alpha: 0.1),
      ],
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    // Mark onboarding as completed
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);

    // Navigate to login
    if (mounted) {
      context.go(AppRoutes.login);
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // Skip button
          if (_currentPage < _pages.length - 1)
            TextButton(
              onPressed: _skipOnboarding,
              child: Text(
                'Skip',
                style: AppTextStyles.linkMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Page view with onboarding screens
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                return _OnboardingScreen(content: _pages[index]);
              },
            ),
          ),

          // Bottom section with dots and button
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                // Page indicators (dots)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => _PageIndicator(
                      isActive: index == _currentPage,
                      index: index,
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                // Next/Get Started button
                SizedBox(
                  width: double.infinity,
                  height: AppSpacing.buttonHeight,
                  child: ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreenModern,
                      foregroundColor: AppColors.textOnPrimary,
                      elevation: 3,
                      shadowColor: AppColors.shadowMedium,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                      ),
                    ),
                    child: Text(
                      _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                      style: AppTextStyles.buttonLarge,
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual onboarding screen widget
class _OnboardingScreen extends StatelessWidget {
  final OnboardingContent content;

  const _OnboardingScreen({required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon container with gradient background
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: content.gradientColors,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              content.icon,
              size: 100,
              color: content.iconColor,
            ),
          ),

          const SizedBox(height: AppSpacing.xxl),

          // Title
          Text(
            content.title,
            style: AppTextStyles.heading1.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSpacing.md),

          // Subtitle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Text(
              content.subtitle,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

/// Page indicator dot widget
class _PageIndicator extends StatelessWidget {
  final bool isActive;
  final int index;

  const _PageIndicator({
    required this.isActive,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryGreenModern : AppColors.borderLight,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

/// Onboarding content data model
class OnboardingContent {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final List<Color> gradientColors;

  OnboardingContent({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
  });
}
