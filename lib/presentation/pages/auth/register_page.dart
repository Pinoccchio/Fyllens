import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fyllens/presentation/shared/widgets/custom_textfield.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/theme/app_text_styles.dart';
import 'package:fyllens/core/constants/app_spacing.dart';
import 'package:fyllens/core/constants/app_constants.dart';
import 'package:fyllens/core/constants/app_routes.dart';

/// Register page
/// User registration screen with modern flat UI design
class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  // Text editing controllers
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
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

                    // Register Form
                    _buildRegisterForm(context),

                    const SizedBox(height: AppSpacing.xxl),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build logo and app branding section
  Widget _buildLogoSection() {
    return Column(
      children: [
        // App Icon
        Container(
          width: AppSpacing.iconXl,
          height: AppSpacing.iconXl,
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.energy_savings_leaf,
            size: AppSpacing.iconLg,
            color: AppColors.primaryGreen,
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // App Name
        Text(
          AppConstants.appName,
          style: AppTextStyles.appTitle,
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: AppSpacing.sm),

        // App Subtitle
        Text(
          AppConstants.appDescription,
          style: AppTextStyles.appSubtitle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Build register form section
  Widget _buildRegisterForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
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

          // Email TextField
          CustomTextfield(
            controller: emailController,
            obscureText: false,
            hintText: AppConstants.emailHint,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(
              Icons.email_outlined,
              color: AppColors.iconSecondary,
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Username TextField
          CustomTextfield(
            controller: usernameController,
            obscureText: false,
            hintText: AppConstants.usernameHint,
            prefixIcon: const Icon(
              Icons.person_outline,
              color: AppColors.iconSecondary,
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Password TextField
          CustomTextfield(
            controller: passwordController,
            obscureText: true,
            hintText: AppConstants.passwordHint,
            prefixIcon: const Icon(
              Icons.lock_outline,
              color: AppColors.iconSecondary,
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Confirm Password TextField
          CustomTextfield(
            controller: confirmPasswordController,
            obscureText: true,
            hintText: AppConstants.confirmPasswordHint,
            prefixIcon: const Icon(
              Icons.lock_outline,
              color: AppColors.iconSecondary,
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

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
        onPressed: () {
          // TODO: Implement registration logic
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: AppColors.textOnPrimary,
          elevation: AppSpacing.elevation2,
          shadowColor: AppColors.shadowMedium,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          ),
        ),
        child: Text(
          AppConstants.signUp,
          style: AppTextStyles.buttonLarge,
        ),
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
