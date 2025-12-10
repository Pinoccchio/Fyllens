import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/constants/app_routes.dart';
import 'package:fyllens/core/theme/app_icons.dart';

/// Modern onboarding with decorative elements and animations
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _iconAnimationController;
  late AnimationController _floatingAnimationController;

  final List<OnboardingContent> _pages = [
    OnboardingContent(
      icon: AppIcons.camera,
      iconColor: AppColors.primaryGreenModern,
      title: 'Scan Your Plants',
      subtitle:
          'Use your camera to detect nutrient deficiencies instantly with AI-powered analysis',
      primaryColor: AppColors.primaryGreenModern,
      secondaryColor: AppColors.accentMint,
    ),
    OnboardingContent(
      icon: AppIcons.checkCircle,
      iconColor: AppColors.accentGreen,
      title: 'Detect Deficiencies',
      subtitle:
          'Get accurate diagnosis and treatment recommendations for healthier plants',
      primaryColor: AppColors.accentGreen,
      secondaryColor: AppColors.primaryGreenLight,
    ),
    OnboardingContent(
      icon: AppIcons.history,
      iconColor: AppColors.success,
      title: 'Track Progress',
      subtitle:
          'Monitor your plants\' health over time with detailed scan history and insights',
      primaryColor: AppColors.success,
      secondaryColor: AppColors.primaryGreen,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _iconAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _floatingAnimationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _iconAnimationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _iconAnimationController.dispose();
    _floatingAnimationController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    // Replay icon animation on page change
    _iconAnimationController.reset();
    _iconAnimationController.forward();
  }

  Future<void> _completeOnboarding() async {
    // Don't save onboarding completion - always show it
    // This allows users to see onboarding every time they launch the app
    if (mounted) {
      context.go(AppRoutes.login);
    }
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSoft,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            Column(
              children: [
                // Skip button
                if (_currentPage < _pages.length - 1)
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextButton(
                        onPressed: _completeOnboarding,
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.borderLight.withValues(
                            alpha: 0.5,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),

                // PageView
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      return _OnboardingScreen(
                        content: _pages[index],
                        iconAnimationController: _iconAnimationController,
                        floatingAnimationController:
                            _floatingAnimationController,
                      );
                    },
                  ),
                ),

                // Bottom navigation
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 0, 32, 40),
                  child: Column(
                    children: [
                      // Page indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _pages.length,
                          (index) => _buildPageIndicator(index),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Next button
                      SizedBox(
                        width: double.infinity,
                        height: 64,
                        child: ElevatedButton(
                          onPressed: _nextPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _pages[_currentPage].primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 8,
                            shadowColor: _pages[_currentPage].primaryColor
                                .withValues(alpha: 0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            _currentPage == _pages.length - 1
                                ? 'Get Started'
                                : 'Next',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator(int index) {
    final isActive = index == _currentPage;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: isActive ? 32 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive
            ? _pages[_currentPage].primaryColor
            : AppColors.borderLight,
        borderRadius: BorderRadius.circular(4),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: _pages[_currentPage].primaryColor.withValues(
                    alpha: 0.3,
                  ),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
    );
  }
}

/// Individual onboarding screen with modern decorations
class _OnboardingScreen extends StatelessWidget {
  final OnboardingContent content;
  final AnimationController iconAnimationController;
  final AnimationController floatingAnimationController;

  const _OnboardingScreen({
    required this.content,
    required this.iconAnimationController,
    required this.floatingAnimationController,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // Floating decorative circles
        _buildFloatingCircle(
          top: screenHeight * 0.1,
          left: 30,
          size: 80,
          color: content.primaryColor.withValues(alpha: 0.1),
          duration: 3.5,
        ),
        _buildFloatingCircle(
          top: screenHeight * 0.15,
          right: 40,
          size: 60,
          color: content.secondaryColor.withValues(alpha: 0.15),
          duration: 4,
        ),
        _buildFloatingCircle(
          bottom: screenHeight * 0.35,
          left: 50,
          size: 50,
          color: content.primaryColor.withValues(alpha: 0.08),
          duration: 3,
        ),
        _buildFloatingCircle(
          bottom: screenHeight * 0.4,
          right: 30,
          size: 70,
          color: content.secondaryColor.withValues(alpha: 0.1),
          duration: 4.5,
        ),

        // Main content
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // Icon with animated glow
              ScaleTransition(
                scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                  CurvedAnimation(
                    parent: iconAnimationController,
                    curve: Curves.elasticOut,
                  ),
                ),
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        content.primaryColor.withValues(alpha: 0.2),
                        content.secondaryColor.withValues(alpha: 0.1),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.6, 1.0],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: content.primaryColor.withValues(alpha: 0.3),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: content.primaryColor.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      content.icon,
                      size: 80,
                      color: content.iconColor,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 60),

              // Title with fade animation
              FadeTransition(
                opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: iconAnimationController,
                    curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
                  ),
                ),
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [content.primaryColor, content.secondaryColor],
                  ).createShader(bounds),
                  child: Text(
                    content.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Subtitle with slide animation
              SlideTransition(
                position:
                    Tween<Offset>(
                      begin: const Offset(0, 0.3),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: iconAnimationController,
                        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
                      ),
                    ),
                child: FadeTransition(
                  opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: iconAnimationController,
                      curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
                    ),
                  ),
                  child: Text(
                    content.subtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 17,
                      color: AppColors.textSecondary,
                      height: 1.6,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingCircle({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double size,
    required Color color,
    required double duration,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: AnimatedBuilder(
        animation: floatingAnimationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
              0,
              math.sin(floatingAnimationController.value * 2 * math.pi) * 10,
            ),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            ),
          );
        },
      ),
    );
  }
}

/// Onboarding content model
class OnboardingContent {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Color primaryColor;
  final Color secondaryColor;

  OnboardingContent({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.primaryColor,
    required this.secondaryColor,
  });
}
