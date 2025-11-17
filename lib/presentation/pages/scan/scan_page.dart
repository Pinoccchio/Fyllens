import 'package:flutter/material.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/theme/app_text_styles.dart';
import 'package:fyllens/core/constants/app_spacing.dart';
import 'package:fyllens/core/constants/app_constants.dart';
import 'package:fyllens/presentation/shared/widgets/floating_circles.dart';

/// Scan page - Camera interface for plant analysis
///
/// This is the core feature of the app. Users take photos of their plants
/// and the app identifies nutrient deficiencies. Currently a placeholder.
///
/// TODO: Implement camera functionality:
/// - Camera preview
/// - Photo capture and storage
/// - Image upload to backend
/// - ML model integration for deficiency detection
/// - Results display with recommendations
class ScanPage extends StatelessWidget {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSoft,
      body: FloatingCirclesBackground(
        circles: [
          FloatingCircleData(
            top: 0.1,
            left: 40,
            size: 60,
            color: AppColors.primaryGreenModern.withValues(alpha: 0.08),
          ),
          FloatingCircleData(
            bottom: 0.2,
            right: 40,
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
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryGreenModern.withValues(alpha: 0.1),
                      border: Border.all(
                        color: AppColors.primaryGreenModern.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      size: 60,
                      color: AppColors.primaryGreenModern.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    'Plant Scanner',
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
                    'Take photos to identify nutrient deficiencies',
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
