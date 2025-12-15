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
import 'package:fyllens/core/utils/auth_validators.dart';

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

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  /// Animation controller for entrance effects (duration: 600ms)
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation; // Fade in
  late Animation<Offset> _slideAnimation; // Slide up

  /// GlobalKey for ScaffoldMessenger to avoid context issues during navigation
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  /// Form key for validation
  final _formKey = GlobalKey<FormState>();

  /// Form input controllers
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

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
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

    // Validate form fields first (inline validation)
    debugPrint('\n🔍 Running form validation...');
    if (!_formKey.currentState!.validate()) {
      debugPrint('❌ Validation failed - errors shown inline');
      return; // Stop if validation fails - error messages shown inline
    }
    debugPrint('✅ Validation passed');

    // Get form values (already validated)
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Log form data (mask password)
    debugPrint('\n📝 Form Data:');
    debugPrint('   Full Name: $fullName');
    debugPrint('   Email: $email');
    debugPrint(
      '   Password: ${"*" * password.length} (${password.length} characters)',
    );

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
          debugPrint(
            '⚠️ Widget unmounted after profile creation, aborting flow',
          );
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

        // Let GoRouter handle navigation automatically after signOut()
        // GoRouter's refreshListenable will detect auth state change and redirect to splash/login
        // Increase delay slightly to ensure success message is visible
        debugPrint('   Waiting 1.5 seconds for success message display...');
        await Future.delayed(const Duration(milliseconds: 1500));

        debugPrint('✅ Success message displayed');
        debugPrint('   GoRouter will automatically redirect to login');
        debugPrint('\n═══════════════════════════════════════════════════════');
        debugPrint('✅ REGISTRATION FLOW COMPLETED SUCCESSFULLY');
        debugPrint('═══════════════════════════════════════════════════════\n');
      } else {
        debugPrint('❌ ERROR: User ID is null after successful signup');
        debugPrint(
          '   This should never happen - auth account exists but no userId',
        );
        debugPrint('\n═══════════════════════════════════════════════════════');
        debugPrint('❌ REGISTRATION FLOW FAILED - NULL USER ID');
        debugPrint('═══════════════════════════════════════════════════════\n');
        _showError('Registration succeeded but could not create profile');
      }
    } else {
      // Show error message from provider
      debugPrint('❌ Authentication account creation FAILED');
      final error =
          authProvider.errorMessage ?? 'Registration failed. Please try again.';
      debugPrint('   Error message: $error');
      debugPrint(
        '   Auth error type: ${authProvider.errorMessage?.runtimeType}',
      );
      debugPrint('\n═══════════════════════════════════════════════════════');
      debugPrint('❌ REGISTRATION FLOW FAILED - AUTH ERROR');
      debugPrint('═══════════════════════════════════════════════════════\n');
      _showError(error);
    }
  }

  /// Show error message using SnackBar
  void _showError(String message) {
    // Use GlobalKey instead of context to avoid deactivated widget issues
    // No need for mounted check since we're using direct reference
    _scaffoldMessengerKey.currentState?.showSnackBar(
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
    // Use GlobalKey instead of context to avoid deactivated widget issues
    // No need for mounted check since we're using direct reference
    _scaffoldMessengerKey.currentState?.showSnackBar(
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) {
          // Handle back button - go to login instead of exiting
          context.go(AppRoutes.login);
        }
      },
      child: ScaffoldMessenger(
        key: _scaffoldMessengerKey,
        child: Scaffold(
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
    ),
      ),
    );
  }

  /// App logo and branding at top of screen
  Widget _buildLogoSection() {
    return Column(
      children: [
        // Fyllens logo with animation
        FadeTransition(
          opacity: _animationController,
          child: Container(
            width: 160,
            height: 160,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryGreenModern.withValues(alpha: 0.1),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryGreenModern.withValues(alpha: 0.2),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Image.asset(
              'assets/images/fyllens_logo.png',
              fit: BoxFit.contain,
            ),
          ),
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
    return Form(
      key: _formKey,
      child: Container(
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

          // Full Name Field with inline validation
          TextFormField(
            controller: _fullNameController,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            style: AppTextStyles.bodyMedium,
            validator: (value) => AuthValidators.validateFullName(value),
            decoration: InputDecoration(
              labelText: 'Full Name',
              hintText: 'Enter your full name',
              prefixIcon: Icon(
                AppIcons.profile,
                color: AppColors.primaryGreenModern,
              ),
              filled: true,
              fillColor: AppColors.backgroundSoft,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                borderSide: BorderSide(
                  color: AppColors.primaryGreenModern.withValues(alpha: 0.1),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                borderSide: BorderSide(
                  color: AppColors.primaryGreenModern,
                  width: 2,
                ),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Email Field with inline validation
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            style: AppTextStyles.bodyMedium,
            validator: (value) => AuthValidators.validateEmail(value),
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'Enter your email',
              prefixIcon: Icon(
                AppIcons.email,
                color: AppColors.primaryGreenModern,
              ),
              filled: true,
              fillColor: AppColors.backgroundSoft,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                borderSide: BorderSide(
                  color: AppColors.primaryGreenModern.withValues(alpha: 0.1),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                borderSide: BorderSide(
                  color: AppColors.primaryGreenModern,
                  width: 2,
                ),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Password Field with inline validation
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            style: AppTextStyles.bodyMedium,
            validator: (value) => AuthValidators.validatePassword(value),
            onFieldSubmitted: (_) => _handleSignUp(),
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
              prefixIcon: Icon(
                AppIcons.lock,
                color: AppColors.primaryGreenModern,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? AppIcons.visibility
                      : AppIcons.visibilityOff,
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
                borderSide: BorderSide(
                  color: AppColors.primaryGreenModern.withValues(alpha: 0.1),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                borderSide: BorderSide(
                  color: AppColors.primaryGreenModern,
                  width: 2,
                ),
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
          disabledBackgroundColor: AppColors.primaryGreenModern.withValues(
            alpha: 0.6,
          ),
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
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        minimumSize: const Size(0, AppSpacing.touchTarget),
      ),
      child: RichText(
        text: TextSpan(
          text: 'Already have an account? ',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          children: [
            TextSpan(text: 'Sign in!', style: AppTextStyles.linkMedium),
          ],
        ),
      ),
    );
  }
}
