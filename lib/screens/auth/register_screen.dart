import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/theme/app_text_styles.dart';
import 'package:fyllens/core/constants/app_spacing.dart';
import 'package:fyllens/core/constants/app_constants.dart';
import 'package:fyllens/core/constants/app_routes.dart';
import 'package:fyllens/screens/shared/widgets/floating_circles.dart';
import 'package:fyllens/screens/shared/widgets/modern_icon_container.dart';
import 'package:fyllens/core/theme/app_icons.dart';

/// Registration screen with email and password fields
///
/// NOTE: This is a UI prototype. The "Sign Up" button currently just navigates
/// to the login screen without creating an account. Fields are optional and
/// have no validation.
///
/// TODO: Integrate with auth service to create actual accounts
/// TODO: Add validation (email format, password strength, etc.)
/// TODO: Show loading state during registration
/// TODO: Handle registration errors
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin {
  /// Animation controller for entrance effects (duration: 600ms)
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation; // Fade in
  late Animation<Offset> _slideAnimation; // Slide up

  /// Form input controllers
  /// Optional fields in this prototype - no validation yet
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  /// Controls password visibility (default: hidden)
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  /// Sign up button handler
  /// TODO: Replace with actual registration logic
  void _handleSignUp() {
    // Currently just goes to login screen (placeholder behavior)
    // Real implementation should create account then navigate
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSoft,
      body: FloatingCirclesBackground(
        circles: [
          FloatingCircleData(
            top: 0.1,
            left: 30,
            size: 80,
            color: AppColors.primaryGreenModern.withValues(alpha: 0.08),
          ),
          FloatingCircleData(
            top: 0.15,
            right: 40,
            size: 60,
            color: AppColors.accentMint.withValues(alpha: 0.1),
          ),
          FloatingCircleData(
            bottom: 0.2,
            left: 50,
            size: 70,
            color: AppColors.primaryGreenLight.withValues(alpha: 0.08),
          ),
        ],
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppSpacing.maxContentWidth,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPaddingHorizontal,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: AppSpacing.xxl),

                      // Logo Section
                      _buildLogoSection(),

                      const SizedBox(height: AppSpacing.xxl),

                      // Register Form with animation
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: _buildRegisterForm(context),
                        ),
                      ),

                      const SizedBox(height: AppSpacing.xxl),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// App logo and branding at top of screen
  Widget _buildLogoSection() {
    return Column(
      children: [
        // Animated app icon with gradient glow
        ModernIconContainer(
          icon: AppIcons.leafFilled,
          iconSize: 60,
          iconColor: AppColors.primaryGreenModern,
          primaryColor: AppColors.primaryGreenModern,
          secondaryColor: AppColors.accentMint,
          containerSize: 160,
          animationController: _animationController,
        ),

        const SizedBox(height: AppSpacing.md),

        // App Name with fade animation
        FadeTransition(
          opacity: _fadeAnimation,
          child: Text(
            AppConstants.appName,
            style: AppTextStyles.appTitle,
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        // App Subtitle with fade animation
        FadeTransition(
          opacity: _fadeAnimation,
          child: Text(
            AppConstants.appDescription,
            style: AppTextStyles.appSubtitle,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  /// Registration form with email, password, and sign up button
  Widget _buildRegisterForm(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGreenModern.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Create Account Heading
            Text(
              AppConstants.createAccount,
              style: AppTextStyles.heading1,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppSpacing.lg),

            // Description
            Text(
              'Join ${AppConstants.appName} to start monitoring your plants!',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppSpacing.xl),

            // Email Field (optional, no validation)
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: AppTextStyles.bodyMedium,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
                prefixIcon: Icon(AppIcons.email, color: AppColors.primaryGreenModern),
                filled: true,
                fillColor: AppColors.backgroundSoft,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  borderSide: BorderSide(color: AppColors.primaryGreenModern.withValues(alpha: 0.1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  borderSide: BorderSide(color: AppColors.primaryGreenModern, width: 2),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Password Field (optional, no validation)
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              style: AppTextStyles.bodyMedium,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                prefixIcon: Icon(AppIcons.lock, color: AppColors.primaryGreenModern),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? AppIcons.visibility : AppIcons.visibilityOff,
                    color: AppColors.primaryGreenModern,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                filled: true,
                fillColor: AppColors.backgroundSoft,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  borderSide: BorderSide(color: AppColors.primaryGreenModern.withValues(alpha: 0.1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  borderSide: BorderSide(color: AppColors.primaryGreenModern, width: 2),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Sign Up Button
            _buildSignUpButton(),

            const SizedBox(height: AppSpacing.md),

            // Sign In Link
            _buildSignInLink(context),
          ],
        ),
      );
  }

  /// Build primary sign up button
  Widget _buildSignUpButton() {
    return SizedBox(
      height: AppSpacing.buttonHeight,
      child: ElevatedButton(
        onPressed: _handleSignUp,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreenModern,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 8,
          shadowColor: AppColors.primaryGreenModern.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
        ),
        child: Text(AppConstants.signUp, style: AppTextStyles.buttonLarge),
      ),
    );
  }

  /// Build sign in link at bottom
  Widget _buildSignInLink(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.go(AppRoutes.login);
      },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
        ),
        minimumSize: const Size(0, AppSpacing.touchTarget),
      ),
      child: RichText(
        text: TextSpan(
          text: 'Already have an account? ',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          children: [
            TextSpan(
              text: 'Sign in!',
              style: AppTextStyles.linkMedium,
            ),
          ],
        ),
      ),
    );
  }
}
