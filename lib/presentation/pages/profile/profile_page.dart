import 'package:flutter/material.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/theme/app_text_styles.dart';
import 'package:fyllens/core/constants/app_spacing.dart';
import 'package:fyllens/core/constants/app_constants.dart';
import 'package:fyllens/presentation/shared/widgets/floating_circles.dart';

/// Profile page - User account and settings
///
/// Manage user profile, app preferences, and account settings.
/// Currently a placeholder.
///
/// TODO: Add profile features:
/// - User info (name, email, photo)
/// - Edit profile button
/// - App settings (notifications, theme)
/// - Account actions (logout, delete account)
/// - About app and version info
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSoft,
      body: FloatingCirclesBackground(
        circles: [
          FloatingCircleData(
            top: 0.15,
            left: 40,
            size: 70,
            color: AppColors.accentMint.withValues(alpha: 0.1),
          ),
        ],
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryGreenModern.withValues(alpha: 0.1),
                      border: Border.all(
                        color: AppColors.primaryGreenModern.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: AppColors.primaryGreenModern.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'User Profile',
                    style: AppTextStyles.heading1.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    AppConstants.comingSoon,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Manage your account and app settings',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
