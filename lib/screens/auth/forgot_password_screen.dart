import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/theme/app_text_styles.dart';
import 'package:fyllens/core/constants/app_spacing.dart';
import 'package:fyllens/core/constants/app_routes.dart';
import 'package:fyllens/providers/auth_provider.dart';

/// Forgot Password Screen
///
/// Allows users to reset their password by entering their email address.
/// Sends a password reset email with a deep link to the app.
///
/// Flow:
/// 1. User enters email
/// 2. Validates email format
/// 3. Calls AuthProvider.resetPassword() with custom redirect URL
/// 4. Gmail receives email with deep link: io.supabase.fyllens://reset-password
/// 5. User clicks link → App opens → ResetPasswordScreen
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  /// Validate email format
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }

    // Basic email regex
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Handle password reset
  Future<void> _handleResetPassword() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final email = _emailController.text.trim();
    final authProvider = context.read<AuthProvider>();

    // Call reset password
    final success = await authProvider.resetPassword(email: email);

    if (mounted) {
      if (success) {
        setState(() {
          _emailSent = true;
        });
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              authProvider.errorMessage ?? 'Failed to send reset email',
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Forgot Password'),
        backgroundColor: AppColors.primaryGreenModern,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPaddingHorizontal,
              vertical: AppSpacing.lg,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSpacing.maxContentWidth,
              ),
              child: _emailSent ? _buildSuccessView() : _buildFormView(authProvider),
            ),
          ),
        ),
      ),
    );
  }

  /// Build the form view (before email is sent)
  Widget _buildFormView(AuthProvider authProvider) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Icon
          Icon(
            Icons.lock_reset_rounded,
            size: AppSpacing.iconXl,
            color: AppColors.primaryGreenModern,
          ),
          const SizedBox(height: AppSpacing.lg),

          // Title
          Text(
            'Reset Your Password',
            style: AppTextStyles.heading2.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),

          // Description
          Text(
            'Enter your email address and we\'ll send you a link to reset your password.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),

          // Email input field
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            enabled: !authProvider.isLoading,
            decoration: InputDecoration(
              labelText: 'Email Address',
              hintText: 'your.email@example.com',
              prefixIcon: const Icon(Icons.email_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              filled: true,
              fillColor: AppColors.backgroundLight,
            ),
            validator: _validateEmail,
            onFieldSubmitted: (_) => _handleResetPassword(),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Submit button
          SizedBox(
            height: AppSpacing.buttonHeight,
            child: ElevatedButton(
              onPressed: authProvider.isLoading ? null : _handleResetPassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreenModern,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                elevation: AppSpacing.elevation2,
              ),
              child: authProvider.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Send Reset Link',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Back to login
          TextButton(
            onPressed: authProvider.isLoading ? null : () => context.go(AppRoutes.login),
            child: Text(
              'Back to Login',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primaryGreenModern,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build the success view (after email is sent)
  Widget _buildSuccessView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Success icon
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_circle_outline_rounded,
            size: AppSpacing.iconXl,
            color: AppColors.success,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Title
        Text(
          'Check Your Email',
          style: AppTextStyles.heading2.copyWith(
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),

        // Description
        Text(
          'We\'ve sent a password reset link to:',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xs),

        // Email address
        Text(
          _emailController.text,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.primaryGreenModern,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.md),

        // Instructions
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.backgroundLight,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Next steps:',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildInstructionStep('1', 'Check your email inbox (and spam folder)'),
              const SizedBox(height: AppSpacing.xs),
              _buildInstructionStep('2', 'Click the "Reset Password" link'),
              const SizedBox(height: AppSpacing.xs),
              _buildInstructionStep('3', 'The app will open automatically'),
              const SizedBox(height: AppSpacing.xs),
              _buildInstructionStep('4', 'Enter your new password'),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),

        // Resend button
        OutlinedButton(
          onPressed: () {
            setState(() {
              _emailSent = false;
            });
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryGreenModern,
            side: BorderSide(color: AppColors.primaryGreenModern),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            minimumSize: const Size(double.infinity, AppSpacing.buttonHeight),
          ),
          child: const Text(
            'Send Again',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Back to login
        TextButton(
          onPressed: () => context.go(AppRoutes.login),
          child: Text(
            'Back to Login',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primaryGreenModern,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  /// Build instruction step row
  Widget _buildInstructionStep(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: AppColors.primaryGreenModern,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
