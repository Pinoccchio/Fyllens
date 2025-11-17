import 'package:flutter/material.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/theme/app_text_styles.dart';
import 'package:fyllens/core/constants/app_spacing.dart';
import 'package:fyllens/core/constants/app_constants.dart';
import 'package:fyllens/presentation/shared/widgets/floating_circles.dart';

/// History page - Past scan results
///
/// View all previous plant scans with their analysis results,
/// timestamps, and recommendations. Currently a placeholder.
///
/// TODO: Implement history features:
/// - List of past scans (newest first)
/// - Tap to view full scan details
/// - Filter by date or plant type
/// - Delete scan history
/// - Export scan data
class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSoft,
      body: FloatingCirclesBackground(
        circles: [
          FloatingCircleData(
            top: 0.1,
            right: 50,
            size: 60,
            color: AppColors.primaryGreenModern.withValues(alpha: 0.08),
          ),
        ],
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 100,
                    color: AppColors.primaryGreenModern.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Scan History',
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
                    'View your past scan results and track plant health',
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
