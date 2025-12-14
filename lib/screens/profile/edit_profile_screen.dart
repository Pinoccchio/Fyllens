import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/theme/app_text_styles.dart';
import 'package:fyllens/core/constants/app_spacing.dart';
import 'package:fyllens/providers/auth_provider.dart';
import 'package:fyllens/providers/profile_provider.dart';

/// Edit profile page - Update user's full name
///
/// Allows users to edit their display name (full_name field in user_profiles table).
/// After successful update, refreshes AuthProvider to show new name immediately.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pre-populate with current full name
    final currentUser = context.read<AuthProvider>().currentUser;
    _fullNameController.text = currentUser?.fullName ?? '';
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    super.dispose();
  }

  /// Handle save button - Update full name in database
  Future<void> _handleSave() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final profileProvider = context.read<ProfileProvider>();
    final currentUser = authProvider.currentUser;

    if (currentUser == null) {
      _showError('No user logged in');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Update profile using ProfileProvider
      final success = await profileProvider.updateProfile(
        userId: currentUser.id,
        fullName: _fullNameController.text.trim(),
      );

      if (!mounted) return;

      if (success) {
        // Refresh auth provider to get updated user data
        await authProvider.refreshProfile();

        if (!mounted) return;

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Profile updated successfully!'),
            backgroundColor: AppColors.primaryGreenModern,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            margin: const EdgeInsets.all(AppSpacing.md),
          ),
        );

        // Navigate back to profile
        context.pop();
      } else {
        // Show error from provider
        final errorMessage =
            profileProvider.errorMessage ?? 'Failed to update profile';
        _showError(errorMessage);
      }
    } catch (e) {
      if (!mounted) return;
      _showError('An unexpected error occurred: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
      appBar: AppBar(
        backgroundColor: AppColors.backgroundSoft,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Edit Full Name',
          style: AppTextStyles.heading2,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.md),

                // Description text
                Text(
                  'Update your display name. This is how you\'ll appear throughout the app.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppSpacing.xl),

                // Full Name input field
                TextFormField(
                  controller: _fullNameController,
                  enabled: !_isLoading,
                  style: AppTextStyles.bodyMedium,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    hintText: 'Enter your full name',
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: AppColors.primaryGreenModern,
                    ),
                    filled: true,
                    fillColor: Colors.white,
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
                      borderSide: const BorderSide(
                        color: AppColors.primaryGreenModern,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      borderSide: const BorderSide(
                        color: Colors.red,
                        width: 1,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      borderSide: const BorderSide(
                        color: Colors.red,
                        width: 2,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your full name';
                    }
                    if (value.trim().length < 2) {
                      return 'Name must be at least 2 characters';
                    }
                    if (value.trim().length > 50) {
                      return 'Name must be less than 50 characters';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: AppSpacing.xl),

                // Save button
                SizedBox(
                  height: AppSpacing.buttonHeight,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreenModern,
                      foregroundColor: AppColors.textOnPrimary,
                      elevation: 8,
                      shadowColor:
                          AppColors.primaryGreenModern.withValues(alpha: 0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                      ),
                      disabledBackgroundColor: AppColors.primaryGreenModern
                          .withValues(alpha: 0.6),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            'Save Changes',
                            style: AppTextStyles.buttonLarge,
                          ),
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // Cancel button
                TextButton(
                  onPressed: _isLoading ? null : () => context.pop(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md,
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: AppTextStyles.buttonMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
