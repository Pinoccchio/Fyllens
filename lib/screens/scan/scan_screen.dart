import 'package:flutter/material.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/theme/app_text_styles.dart';
import 'package:fyllens/core/constants/app_spacing.dart';
import 'package:fyllens/screens/shared/widgets/custom_list_tile.dart';
import 'package:fyllens/core/theme/app_icons.dart';

/// Scan page - Camera interface for plant analysis
///
/// This is the core feature of the app. Users select a plant species
/// and take photos to identify nutrient deficiencies.
class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSoft,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text('Scan Plant', style: AppTextStyles.heading1),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Select plant species to scan',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                // Info box
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreenModern.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Scan Your Plant',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _buildTip('Ensure good lighting'),
                      _buildTip('Focus on affected leaves'),
                      _buildTip('Keep camera steady'),
                      _buildTip('Capture clear images'),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                // Section title
                Text('Select Plant', style: AppTextStyles.heading3),
                const SizedBox(height: AppSpacing.md),
                // Plant list
                CustomListTile(
                  icon: AppIcons.seedling,
                  title: 'Rice',
                  subtitle: 'Oryza sativa',
                  onTap: () {
                    // TODO: Navigate to camera with Rice selected
                  },
                ),
                CustomListTile(
                  icon: AppIcons.seedling,
                  title: 'Corn',
                  subtitle: 'Zea mays',
                  onTap: () {
                    // TODO: Navigate to camera with Corn selected
                  },
                ),
                CustomListTile(
                  icon: AppIcons.seedling,
                  title: 'Okra',
                  subtitle: 'Abelmoschus esculentus',
                  onTap: () {
                    // TODO: Navigate to camera with Okra selected
                  },
                ),
                CustomListTile(
                  icon: AppIcons.seedling,
                  title: 'Cucumber',
                  subtitle: 'Cucumis sativus',
                  onTap: () {
                    // TODO: Navigate to camera with Cucumber selected
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(
              AppIcons.checkCircle,
              size: 6,
              color: AppColors.primaryGreenModern,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
