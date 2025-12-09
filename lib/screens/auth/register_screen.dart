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
import 'package:fyllens/providers/profile_provider.dart';

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
  final _fullNameController = TextEditingController();
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
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  /// Sign up button handler - Creates account, profile, then forces logout
  Future<void> _handleSignUp() async {
    debugPrint('\n═══════════════════════════════════════════════════════');
    debugPrint('🚀 REGISTRATION FLOW STARTED');
    debugPrint('═══════════════════════════════════════════════════════');

    // Get form values
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Log form data (mask password)
    debugPrint('\n📝 Form Data:');
    debugPrint('   Full Name: $fullName');
    debugPrint('   Email: $email');
    debugPrint('   Password: ${"*" * password.length} (${password.length} characters)');

    // Basic validation
    debugPrint('\n🔍 Running validation...');

    if (fullName.isEmpty || email.isEmpty || password.isEmpty) {
      debugPrint('❌ Validation failed: Empty fields detected');
      debugPrint('   Full name empty: ${fullName.isEmpty}');
      debugPrint('   Email empty: ${email.isEmpty}');
      debugPrint('   Password empty: ${password.isEmpty}');
      _showError('Please fill in all fields');
      return;
    }

    if (fullName.length < 2) {
      debugPrint('❌ Validation failed: Full name too short (${fullName.length} characters)');
      _showError('Full name must be at least 2 characters');
      return;
    }

    if (password.length < 6) {
      debugPrint('❌ Validation failed: Password too short (${password.length} characters)');
      _showError('Password must be at least 6 characters');
      return;
    }

    debugPrint('✅ Validation passed');

    // Get providers
    debugPrint('\n🔌 Getting providers...');
    final authProvider = context.read<AuthProvider>();
    final profileProvider = context.read<ProfileProvider>();
    debugPrint('✅ Providers obtained');

    // Attempt sign up
    debugPrint('\n🔐 Step 1: Creating authentication account...');
    debugPrint('   Calling authProvider.signUp()...');

    final success = await authProvider.signUp(
      email: email,
      password: password,
      fullName: fullName,
    );

    if (!mounted) {
      debugPrint('⚠️ Widget unmounted after signUp, aborting flow');
      return;
    }

    if (success) {
      debugPrint('✅ Authentication account created successfully!');

      // Get the newly created user ID
      final userId = authProvider.currentUser?.id;
      debugPrint('   User ID: $userId');

      if (userId != null) {
        // Create user profile in database
        debugPrint('\n💾 Step 2: Creating user profile in database...');
        debugPrint('   User ID: $userId');
        debugPrint('   Email: $email');
        debugPrint('   Full Name: $fullName');
        debugPrint('   Calling profileProvider.createProfile()...');

        await profileProvider.createProfile(
          userId: userId,
          email: email,
          fullName: fullName,
        );

        if (!mounted) {
          debugPrint('⚠️ Widget unmounted after profile creation, aborting flow');
          return;
        }

        debugPrint('✅ User profile created successfully in database!');

        // Force logout - user must log in with new credentials
        debugPrint('\n🚪 Step 3: Forcing logout...');
        debugPrint('   Calling authProvider.signOut()...');

        await authProvider.signOut();

        if (!mounted) {
          debugPrint('⚠️ Widget unmounted after logout, aborting flow');
          return;
        }

        debugPrint('✅ Logout successful!');

        // Show success message
        debugPrint('\n🎉 Registration completed successfully!');
        _showSuccess('Account created successfully! Please log in.');

        // Navigate to login screen
        // Wait for both message display AND auth state sync with GoRouter
        debugPrint('   Waiting 1.1 seconds before navigation...');
        await Future.delayed(const Duration(milliseconds: 1100));

        if (!mounted) {
          debugPrint('⚠️ Widget unmounted before navigation');
          return;
        }

        debugPrint('🔀 Navigating to login screen...');
        context.go(AppRoutes.login);

        debugPrint('\n═══════════════════════════════════════════════════════');
        debugPrint('✅ REGISTRATION FLOW COMPLETED SUCCESSFULLY');
        debugPrint('═══════════════════════════════════════════════════════\n');
      } else {
        debugPrint('❌ ERROR: User ID is null after successful signup');
        debugPrint('   This should never happen - auth account exists but no userId');
        debugPrint('\n═══════════════════════════════════════════════════════');
        debugPrint('❌ REGISTRATION FLOW FAILED - NULL USER ID');
        debugPrint('═══════════════════════════════════════════════════════\n');
        _showError('Registration succeeded but could not create profile');
      }
    } else {
      // Show error message from provider
      debugPrint('❌ Authentication account creation FAILED');
      final error = authProvider.errorMessage ?? 'Registration failed. Please try again.';
      debugPrint('   Error message: $error');
      debugPrint('   Auth error type: ${authProvider.errorMessage?.runtimeType}');
      debugPrint('\n═══════════════════════════════════════════════════════');
      debugPrint('❌ REGISTRATION FLOW FAILED - AUTH ERROR');
      debugPrint('═══════════════════════════════════════════════════════\n');
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

  /// Show success message using SnackBar
  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green[700],
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

            // Full Name Field
            TextFormField(
              controller: _fullNameController,
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              style: AppTextStyles.bodyMedium,
              decoration: InputDecoration(
                labelText: 'Full Name',
                hintText: 'Enter your full name',
                prefixIcon: Icon(AppIcons.profile, color: AppColors.primaryGreenModern),
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

  /// Build primary sign up button with loading state
  Widget _buildSignUpButton() {
    final authProvider = context.watch<AuthProvider>();
    final profileProvider = context.watch<ProfileProvider>();
    final isLoading = authProvider.isLoading || profileProvider.isLoading;

    return SizedBox(
      height: AppSpacing.buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : _handleSignUp,
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
            : Text(AppConstants.signUp, style: AppTextStyles.buttonLarge),
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
