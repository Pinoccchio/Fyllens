import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/theme/app_text_styles.dart';
import 'package:fyllens/core/constants/app_spacing.dart';
import 'package:fyllens/core/constants/app_constants.dart';
import 'package:fyllens/core/constants/app_routes.dart';
import 'package:fyllens/screens/shared/widgets/floating_circles.dart';
import 'package:fyllens/screens/shared/widgets/modern_icon_container.dart';
import 'package:fyllens/core/theme/app_icons.dart';
import 'package:fyllens/providers/auth_provider.dart';

/// Login screen with email and password fields
///
/// Handles user authentication with email and password.
/// Shows loading state during authentication and displays errors if login fails.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  /// Animation controller for fade and slide effects (duration: 600ms)
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation; // Opacity 0 → 1
  late Animation<Offset> _slideAnimation; // Slide up on load

  /// Form input controllers
  /// Fields are optional in this prototype - no validation enforced yet
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  /// Controls password visibility (default: hidden)
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();

    // Setup animations that play when page loads
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Fade in animation - content goes from invisible to visible
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    // Slide up animation - form slides up slightly as it appears
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3), // Start 30% down
      end: Offset.zero, // End at normal position
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

  /// Login button handler - Authenticates user with email and password
  Future<void> _handleLogin() async {
    // Get email and password from controllers
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Basic validation
    if (email.isEmpty || password.isEmpty) {
      _showError('Please enter both email and password');
      return;
    }

    // Get AuthProvider
    final authProvider = context.read<AuthProvider>();

    // Attempt sign in
    final success = await authProvider.signIn(
      email: email,
      password: password,
    );

    if (!mounted) return;

    if (success) {
      // GoRouter will automatically redirect to home when auth state changes
      // No manual navigation needed - let the router redirect handle it
      debugPrint('✅ Login successful - GoRouter will redirect to home');
    } else {
      // Show error message from provider
      final error = authProvider.errorMessage ?? 'Login failed. Please try again.';
      _showError(error);
    }
  }

  /// Show error message using SnackBar
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        margin: const EdgeInsets.all(AppSpacing.md),
      ),
    );
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

                      // Logo Section with animation
                      _buildLogoSection(),

                      const SizedBox(height: AppSpacing.xxl),

                      // Login Form with animation
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: _buildLoginForm(context),
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
        // Animated app icon with gradient glow effect
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

        // App name (fades in)
        FadeTransition(
          opacity: _fadeAnimation,
          child: Text(
            AppConstants.appName,
            style: AppTextStyles.appTitle,
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        // App description (fades in)
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

  /// Login form with email, password, and sign in button
  Widget _buildLoginForm(BuildContext context) {
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
          // Sign In Heading
          Text(
            AppConstants.signIn,
            style: AppTextStyles.heading1,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSpacing.lg),

          // Description
          Text(
            'Welcome back to ${AppConstants.appName}!',
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

          // Password field with show/hide toggle
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

          // Login Button
          _buildLoginButton(),

          const SizedBox(height: AppSpacing.md),

          // Sign Up Link
          _buildSignUpLink(),
        ],
      ),
    );
  }

  /// Build primary login button with loading state
  Widget _buildLoginButton() {
    final authProvider = context.watch<AuthProvider>();
    final isLoading = authProvider.isLoading;

    return SizedBox(
      height: AppSpacing.buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreenModern,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 8,
          shadowColor: AppColors.primaryGreenModern.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          disabledBackgroundColor: AppColors.primaryGreenModern.withValues(alpha: 0.6),
        ),
        child: isLoading
            ? const Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              )
            : Text(AppConstants.login, style: AppTextStyles.buttonLarge),
      ),
    );
  }

  /// Build sign up link at bottom
  Widget _buildSignUpLink() {
    return TextButton(
      onPressed: () {
        context.go(AppRoutes.register);
      },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        minimumSize: const Size(0, AppSpacing.touchTarget),
      ),
      child: RichText(
        text: TextSpan(
          text: "Don't have an account? ",
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          children: [
            TextSpan(text: 'Register now!', style: AppTextStyles.linkMedium),
          ],
        ),
      ),
    );
  }
}
