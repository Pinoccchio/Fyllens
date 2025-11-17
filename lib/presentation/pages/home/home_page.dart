import 'package:flutter/material.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/theme/app_text_styles.dart';
import 'package:fyllens/core/constants/app_spacing.dart';
import 'package:fyllens/core/constants/app_constants.dart';
import 'package:fyllens/presentation/shared/widgets/floating_circles.dart';

/// Home page - Main dashboard
///
/// This will be the main landing screen when users log in. Currently a placeholder.
///
/// TODO: Add dashboard widgets:
/// - Recent plant scans
/// - Quick scan button
/// - Plant health summary
/// - Care reminders
/// - Nutrient deficiency alerts
class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
            top: 0.2,
            right: 40,
            size: 60,
            color: AppColors.accentMint.withValues(alpha: 0.1),
          ),
        ],
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'Welcome to ${AppConstants.appName}!',
                  style: AppTextStyles.heading1.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  AppConstants.appDescription,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),

                const Spacer(),

                // Coming Soon Icon
                Center(
                  child: Icon(
                    Icons.dashboard_outlined,
                    size: 100,
                    color: AppColors.primaryGreenModern.withValues(alpha: 0.3),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Center(
                  child: Text(
                    'Dashboard ${AppConstants.comingSoon}',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),

                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
