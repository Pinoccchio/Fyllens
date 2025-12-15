import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/theme/app_text_styles.dart';
import 'package:fyllens/core/constants/app_spacing.dart';
import 'package:fyllens/core/constants/app_routes.dart';
import 'package:fyllens/providers/auth_provider.dart';

/// Reset Password Screen
///
/// Accessed via deep link after user clicks email reset link.
/// Allows user to set a new password.
///
/// Flow:
/// 1. User clicks email reset link → App opens via deep link
/// 2. AppLinks handler establishes session via getSessionFromUrl()
/// 3. This screen verifies session is valid
/// 4. User enters new password (twice for confirmation)
/// 5. Calls AuthProvider.updatePassword()
/// 6. Navigates to login screen on success
///
/// Fallback:
/// - If session establishment fails, accepts optional resetCode parameter
class ResetPasswordScreen extends StatefulWidget {
  final String? resetCode;

  const ResetPasswordScreen({
    super.key,
    this.resetCode,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  /// GlobalKey for ScaffoldMessenger to avoid context issues during navigation
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isSessionValid = false;
  bool _isCheckingSession = true;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Check if user has valid session for password reset
  Future<void> _checkSession() async {
    if (kDebugMode) {
      debugPrint('\n🔐 [RESET PASSWORD] Checking session validity...');
    }

    try {
      final session = Supabase.instance.client.auth.currentSession;

      if (kDebugMode) {
        debugPrint('   Session: ${session != null ? "Valid" : "Invalid"}');
        if (session != null) {
          debugPrint('   Access Token: ${session.accessToken.isNotEmpty ? "Present" : "Missing"}');
        }
      }

      setState(() {
        _isSessionValid = session != null && session.accessToken.isNotEmpty;
        _isCheckingSession = false;
      });

      if (!_isSessionValid) {
        if (kDebugMode) {
          debugPrint('❌ [RESET PASSWORD] No valid session found');
        }

        // Show error and redirect to login after delay
        if (mounted) {
          // Use GlobalKey instead of context to avoid deactivated widget issues
          _scaffoldMessengerKey.currentState?.showSnackBar(
            const SnackBar(
              content: Text('Password reset link has expired. Please request a new one.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 4),
            ),
          );

          // Redirect to login after showing error
          Future.delayed(const Duration(seconds: 4), () {
            if (mounted) {
              context.go(AppRoutes.login);
            }
          });
        }
      } else {
        if (kDebugMode) {
          debugPrint('✅ [RESET PASSWORD] Valid session confirmed');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ [RESET PASSWORD] Error checking session: $e');
      }

      setState(() {
        _isSessionValid = false;
        _isCheckingSession = false;
      });
    }
  }

  /// Validate password
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  /// Validate confirm password
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  /// Handle password update
  Future<void> _handleUpdatePassword() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final password = _passwordController.text;
    final authProvider = context.read<AuthProvider>();

    if (kDebugMode) {
      debugPrint('\n🔐 [RESET PASSWORD] Updating password...');
    }

    // Call update password
    final success = await authProvider.updatePassword(newPassword: password);

    if (mounted) {
      if (success) {
        if (kDebugMode) {
          debugPrint('✅ [RESET PASSWORD] Password updated successfully');
        }

        // CRITICAL: Sign out FIRST to prevent auto-login
        // Supabase keeps user logged in after password update, so we force logout
        // This must happen BEFORE navigation to ensure router sees unauthenticated state
        if (kDebugMode) {
          debugPrint('🔐 [RESET PASSWORD] Signing out user to force manual login...');
        }
        await authProvider.signOut();

        if (kDebugMode) {
          debugPrint('✅ [RESET PASSWORD] User signed out successfully');
        }

        // Ensure widget is still mounted after async signout
        if (!mounted) return;

        // Navigate to login immediately (no delay)
        // The router will now see unauthenticated state and allow login navigation
        if (kDebugMode) {
          debugPrint('✅ [RESET PASSWORD] Navigating to login screen');
        }
        context.go(AppRoutes.login);

        // Show success message after navigation using post-frame callback
        // This ensures the message appears on the login screen
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Password reset successful! Please login with your new password.'),
                backgroundColor: AppColors.success,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        });
      } else {
        if (kDebugMode) {
          debugPrint('❌ [RESET PASSWORD] Password update failed');
        }

        // Show error message using GlobalKey
        _scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text(
              authProvider.errorMessage ?? 'Failed to update password',
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

    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Reset Password'),
          backgroundColor: AppColors.primaryGreenModern,
          foregroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false, // No back button
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
              child: _isCheckingSession
                  ? _buildLoadingView()
                  : _isSessionValid
                      ? _buildFormView(authProvider)
                      : _buildErrorView(),
            ),
          ),
        ),
      ),
    ),
    );
  }

  /// Build loading view while checking session
  Widget _buildLoadingView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreenModern),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Verifying reset link...',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  /// Build error view for invalid/expired session
  Widget _buildErrorView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(
          Icons.error_outline_rounded,
          size: AppSpacing.iconXl,
          color: AppColors.error,
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Link Expired',
          style: AppTextStyles.heading2.copyWith(
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'This password reset link has expired or is invalid.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xl),
        ElevatedButton(
          onPressed: () => context.go(AppRoutes.forgotPassword),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreenModern,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            minimumSize: const Size(double.infinity, AppSpacing.buttonHeight),
          ),
          child: const Text(
            'Request New Link',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  /// Build the password reset form
  Widget _buildFormView(AuthProvider authProvider) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Icon
          Icon(
            Icons.lock_open_rounded,
            size: AppSpacing.iconXl,
            color: AppColors.primaryGreenModern,
          ),
          const SizedBox(height: AppSpacing.lg),

          // Title
          Text(
            'Set New Password',
            style: AppTextStyles.heading2.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),

          // Description
          Text(
            'Enter your new password below. Make sure it\'s at least 6 characters long.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),

          // New password field
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.next,
            enabled: !authProvider.isLoading,
            decoration: InputDecoration(
              labelText: 'New Password',
              hintText: 'Enter new password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              filled: true,
              fillColor: AppColors.backgroundLight,
            ),
            validator: _validatePassword,
          ),
          const SizedBox(height: AppSpacing.md),

          // Confirm password field
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            textInputAction: TextInputAction.done,
            enabled: !authProvider.isLoading,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              hintText: 'Re-enter new password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              filled: true,
              fillColor: AppColors.backgroundLight,
            ),
            validator: _validateConfirmPassword,
            onFieldSubmitted: (_) => _handleUpdatePassword(),
          ),
          const SizedBox(height: AppSpacing.md),

          // Password requirements hint
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              border: Border.all(
                color: AppColors.info.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: AppSpacing.iconSm,
                  color: AppColors.info,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Password must be at least 6 characters',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.info,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Update password button
          SizedBox(
            height: AppSpacing.buttonHeight,
            child: ElevatedButton(
              onPressed: authProvider.isLoading ? null : _handleUpdatePassword,
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
                      'Update Password',
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
            onPressed: authProvider.isLoading
                ? null
                : () => context.go(AppRoutes.login),
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
}
