import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fyllens/presentation/shared/widgets/custom_textfield.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/theme/app_text_styles.dart';
import 'package:fyllens/core/constants/app_spacing.dart';
import 'package:fyllens/core/constants/app_constants.dart';
import 'package:fyllens/core/constants/app_routes.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // Text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

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

                    // Login Form
                    _buildLoginForm(context),

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

  /// Build login form section
  Widget _buildLoginForm(BuildContext context) {
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
          // Sign In Heading
          Text(
            AppConstants.signIn,
            style: AppTextStyles.heading1,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSpacing.lg),

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

          const SizedBox(height: AppSpacing.sm),

          // Forgot Password Link
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // TODO: Navigate to forgot password page
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                minimumSize: const Size(0, AppSpacing.touchTarget),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                AppConstants.forgotPassword,
                style: AppTextStyles.linkMedium,
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Login Button
          _buildLoginButton(),

          const SizedBox(height: AppSpacing.md),

          // Sign Up Link
          _buildSignUpLink(),
        ],
      ),
    );
  }

  /// Build primary login button
  Widget _buildLoginButton() {
    return SizedBox(
      height: AppSpacing.buttonHeight,
      child: ElevatedButton(
        onPressed: () {
          // TODO: Implement login logic
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
          AppConstants.login,
          style: AppTextStyles.buttonLarge,
        ),
      ),
    );
  }

  /// Build sign up link at bottom
  Widget _buildSignUpLink() {
    return Builder(
      builder: (context) => TextButton(
        onPressed: () {
          context.go(AppRoutes.register);
        },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
        ),
        minimumSize: const Size(0, AppSpacing.touchTarget),
      ),
      child: RichText(
        text: TextSpan(
          text: "Don't have an account? ",
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          children: [
            TextSpan(
              text: 'Register now!',
              style: AppTextStyles.linkMedium,
            ),
          ],
        ),
      ),
    ),
    );
  }
}
