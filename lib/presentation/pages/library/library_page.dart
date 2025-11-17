import 'package:flutter/material.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/theme/app_text_styles.dart';
import 'package:fyllens/core/constants/app_spacing.dart';
import 'package:fyllens/core/constants/app_constants.dart';
import 'package:fyllens/presentation/shared/widgets/floating_circles.dart';

/// Library page - Plant species database
///
/// Browse and search for plant care information, nutrient requirements,
/// and common deficiency symptoms. Currently a placeholder.
///
/// TODO: Add library features:
/// - Searchable plant database
/// - Plant care guides
/// - Nutrient deficiency reference
/// - Filterable by plant type
class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSoft,
      body: FloatingCirclesBackground(
        circles: [
          FloatingCircleData(
            top: 0.15,
            right: 30,
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
                  Icon(
                    Icons.library_books_outlined,
                    size: 100,
                    color: AppColors.primaryGreenModern.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Plant Library',
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
                    'Browse plant species and deficiency info',
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
