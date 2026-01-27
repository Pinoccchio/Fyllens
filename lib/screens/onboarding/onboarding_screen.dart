import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/theme/app_text_styles.dart';
import 'package:fyllens/core/theme/app_gradients.dart';
import 'package:fyllens/core/constants/app_spacing.dart';
import 'package:fyllens/core/constants/app_routes.dart';
import 'package:fyllens/core/theme/app_icons.dart';
import 'package:fyllens/screens/shared/widgets/custom_button.dart';

/// Onboarding screen - "Organic Luxury" Design
///
/// Premium first impression with:
/// - Full-bleed botanical gradient backgrounds
/// - Frosted glass text cards
/// - Custom leaf page indicators
/// - Warm gold "Continue" button
/// - Elegant animations
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _contentAnimationController;
  late AnimationController _floatingAnimationController;
  late AnimationController _leafAnimationController;

  final List<OnboardingContent> _pages = [
    OnboardingContent(
      icon: AppIcons.camera,
      title: 'Scan Your Plants',
      subtitle: 'Capture leaves with your camera for instant AI-powered nutrient deficiency analysis',
      gradient: AppGradients.forest,
      accentColor: AppColors.accentGold,
    ),
    OnboardingContent(
      icon: AppIcons.checkCircle,
      title: 'Get Expert Diagnosis',
      subtitle: 'Receive accurate identification with confidence scores and detailed symptom breakdown',
      gradient: AppGradients.sage,
      accentColor: AppColors.primaryMint,
    ),
    OnboardingContent(
      icon: AppIcons.sparkle,
      title: 'Heal & Thrive',
      subtitle: 'Follow personalized treatment plans and track your plants\' recovery journey',
      gradient: AppGradients.goldCoral,
      accentColor: AppColors.accentCream,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _contentAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _floatingAnimationController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
    _leafAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _contentAnimationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _contentAnimationController.dispose();
    _floatingAnimationController.dispose();
    _leafAnimationController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    _contentAnimationController.reset();
    _contentAnimationController.forward();
  }

  Future<void> _completeOnboarding() async {
    if (mounted) {
      context.go(AppRoutes.login);
    }
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: AppSpacing.animationPage,
        curve: Curves.easeInOutCubic,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          AnimatedContainer(
            duration: AppSpacing.animationStandard,
            decoration: BoxDecoration(
              gradient: _pages[_currentPage].gradient,
            ),
          ),

          // Floating botanical elements
          ..._buildFloatingElements(),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Skip button
                if (_currentPage < _pages.length - 1)
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: _buildSkipButton(),
                    ),
                  )
                else
                  const SizedBox(height: 56),

                // Page content
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      return _OnboardingPage(
                        content: _pages[index],
                        contentAnimationController: _contentAnimationController,
                        isActive: index == _currentPage,
                      );
                    },
                  ),
                ),

                // Bottom section
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPadding,
                    0,
                    AppSpacing.screenPadding,
                    AppSpacing.xl,
                  ),
                  child: Column(
                    children: [
                      // Leaf page indicators
                      _buildLeafIndicators(),
                      const SizedBox(height: AppSpacing.lg),

                      // Gold CTA button
                      CustomButton.primary(
                        text: _currentPage == _pages.length - 1
                            ? 'Get Started'
                            : 'Continue',
                        icon: _currentPage == _pages.length - 1
                            ? AppIcons.arrowForward
                            : null,
                        iconLeading: false,
                        onPressed: _nextPage,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkipButton() {
    return GestureDetector(
      onTap: _completeOnboarding,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Text(
              'Skip',
              style: AppTextStyles.labelLarge.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFloatingElements() {
    return [
      // Large floating leaf
      Positioned(
        top: 80,
        left: -30,
        child: AnimatedBuilder(
          animation: _floatingAnimationController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(
                math.sin(_floatingAnimationController.value * math.pi) * 15,
                math.cos(_floatingAnimationController.value * math.pi * 2) * 10,
              ),
              child: Transform.rotate(
                angle: math.sin(_floatingAnimationController.value * math.pi) * 0.1,
                child: Opacity(
                  opacity: 0.15,
                  child: Icon(
                    AppIcons.leaf,
                    size: 120,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
        ),
      ),
      // Medium floating leaf
      Positioned(
        top: 200,
        right: -20,
        child: AnimatedBuilder(
          animation: _floatingAnimationController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(
                math.cos(_floatingAnimationController.value * math.pi * 1.5) * 12,
                math.sin(_floatingAnimationController.value * math.pi) * 15,
              ),
              child: Transform.rotate(
                angle: -math.cos(_floatingAnimationController.value * math.pi) * 0.15,
                child: Opacity(
                  opacity: 0.1,
                  child: Icon(
                    AppIcons.leaf,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
        ),
      ),
      // Small floating circle
      Positioned(
        bottom: 250,
        left: 40,
        child: AnimatedBuilder(
          animation: _floatingAnimationController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(
                0,
                math.sin(_floatingAnimationController.value * math.pi * 2) * 8,
              ),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            );
          },
        ),
      ),
      // Another decorative circle
      Positioned(
        bottom: 350,
        right: 50,
        child: AnimatedBuilder(
          animation: _floatingAnimationController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(
                math.sin(_floatingAnimationController.value * math.pi) * 10,
                0,
              ),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            );
          },
        ),
      ),
    ];
  }

  Widget _buildLeafIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_pages.length, (index) {
        final isActive = index == _currentPage;
        return AnimatedContainer(
          duration: AppSpacing.animationStandard,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          child: isActive
              ? _buildActiveLeafIndicator()
              : _buildInactiveIndicator(),
        );
      }),
    );
  }

  Widget _buildActiveLeafIndicator() {
    return AnimatedBuilder(
      animation: _leafAnimationController,
      builder: (context, child) {
        return Transform.rotate(
          angle: math.sin(_leafAnimationController.value * math.pi * 2) * 0.1,
          child: Icon(
            AppIcons.leafFilled,
            size: 24,
            color: AppColors.accentGold,
          ),
        );
      },
    );
  }

  Widget _buildInactiveIndicator() {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.4),
      ),
    );
  }
}

/// Individual onboarding page with frosted glass card
class _OnboardingPage extends StatelessWidget {
  final OnboardingContent content;
  final AnimationController contentAnimationController;
  final bool isActive;

  const _OnboardingPage({
    required this.content,
    required this.contentAnimationController,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated icon container
          ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(
              CurvedAnimation(
                parent: contentAnimationController,
                curve: Curves.elasticOut,
              ),
            ),
            child: _buildIconContainer(),
          ),

          const SizedBox(height: AppSpacing.xxl),

          // Frosted glass card with text content
          FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: contentAnimationController,
                curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
              ),
            ),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.2),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: contentAnimationController,
                  curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
                ),
              ),
              child: _buildGlassCard(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconContainer() {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.15),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: content.accentColor.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Icon(
          content.icon,
          size: 60,
          color: content.accentColor,
        ),
      ),
    );
  }

  Widget _buildGlassCard(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.cardPaddingLg),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              // Title
              Text(
                content.title,
                textAlign: TextAlign.center,
                style: AppTextStyles.displayMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Subtitle
              Text(
                content.subtitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Onboarding content model
class OnboardingContent {
  final IconData icon;
  final String title;
  final String subtitle;
  final LinearGradient gradient;
  final Color accentColor;

  OnboardingContent({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.accentColor,
  });
}
