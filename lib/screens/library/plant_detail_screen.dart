import 'package:flutter/material.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/theme/app_text_styles.dart';
import 'package:fyllens/core/constants/app_spacing.dart';
import 'package:fyllens/core/theme/app_icons.dart';

/// Plant detail page showing comprehensive plant information
/// Displays overview, deficiencies, and growing conditions
class PlantDetailScreen extends StatelessWidget {
  final String plantName;
  final String scientificName;
  final String? imageAssetPath;

  const PlantDetailScreen({
    super.key,
    required this.plantName,
    required this.scientificName,
    this.imageAssetPath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSoft,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and plant name
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(AppIcons.arrowBack),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          plantName,
                          style: AppTextStyles.heading2,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          scientificName,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 40), // Balance for back button
                ],
              ),
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Plant image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      child: SizedBox(
                        width: double.infinity,
                        height: 200,
                        child: imageAssetPath != null
                            ? Image.asset(
                                imageAssetPath!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    _buildPlaceholder(),
                              )
                            : _buildPlaceholder(),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Overview section
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusMd,
                        ),
                        border: Border.all(
                          color: AppColors.textSecondary.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Overview', style: AppTextStyles.heading3),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            _getPlantOverview(plantName),
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textPrimary,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Common Nutrient Deficiencies
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusMd,
                        ),
                        border: Border.all(
                          color: AppColors.textSecondary.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Common Nutrient Deficiencies',
                            style: AppTextStyles.heading3,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          _buildDeficiencyItem(
                            'Nitrogen Deficiency',
                            'Common',
                            const Color(0xFFFFB84D),
                          ),
                          const Divider(height: AppSpacing.md),
                          _buildDeficiencyItem(
                            'Phosphorus Deficiency',
                            'Moderate',
                            const Color(0xFFFFEB99),
                          ),
                          const Divider(height: AppSpacing.md),
                          _buildDeficiencyItem(
                            'Potassium Deficiency',
                            'Common',
                            const Color(0xFFFFB84D),
                          ),
                          const Divider(height: AppSpacing.md),
                          _buildDeficiencyItem(
                            'Iron Deficiency',
                            'Rare',
                            const Color(0xFFB3D9FF),
                            isLast: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Ideal Growing Conditions
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusMd,
                        ),
                        border: Border.all(
                          color: AppColors.primaryGreenModern.withValues(
                            alpha: 0.3,
                          ),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ideal Growing Conditions',
                            style: AppTextStyles.heading3,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          ..._getGrowingConditions(plantName),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Scan This Plant button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Navigate to scan page with this plant selected
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreenModern,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusMd,
                            ),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(AppIcons.camera, size: 20),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              'Scan This Plant',
                              style: AppTextStyles.buttonMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.primaryGreenModern.withValues(alpha: 0.1),
      child: Center(
        child: Icon(
          AppIcons.flower,
          size: 64,
          color: AppColors.primaryGreenModern,
        ),
      ),
    );
  }

  Widget _buildDeficiencyItem(
    String name,
    String severity,
    Color color, {
    bool isLast = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            name,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          child: Text(
            severity,
            style: AppTextStyles.bodySmall.copyWith(
              color: severity == 'Moderate'
                  ? Colors.black87
                  : severity == 'Rare'
                  ? const Color(0xFF1976D2)
                  : const Color(0xFFE65100),
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConditionItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primaryGreenModern),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getPlantOverview(String plant) {
    switch (plant.toLowerCase()) {
      case 'rice':
        return 'Rice is a staple crop grown worldwide, particularly in Asia. It requires specific nutrient management for optimal growth and yield. Understanding its nutrient requirements is crucial for successful cultivation.';
      case 'corn':
        return 'Corn is a versatile cereal grain widely cultivated for food, livestock feed, and industrial products. It has high nutrient demands and requires careful management for optimal productivity.';
      case 'okra':
        return 'Okra is a warm-season vegetable known for its edible green pods. It is relatively easy to grow but requires balanced nutrition and proper care to produce abundant harvests.';
      case 'cucumber':
        return 'Cucumber is a popular vegetable crop grown for fresh consumption and pickling. It requires consistent moisture and balanced nutrition for healthy growth and fruit production.';
      default:
        return 'This plant requires specific care and nutrient management for optimal growth and productivity.';
    }
  }

  List<Widget> _getGrowingConditions(String plant) {
    switch (plant.toLowerCase()) {
      case 'rice':
        return [
          _buildConditionItem(
            AppIcons.sun,
            'Sunlight',
            'Full sun (6-8 hours daily)',
          ),
          _buildConditionItem(
            AppIcons.waterDrop,
            'Water',
            'Flooded conditions preferred',
          ),
          _buildConditionItem(
            AppIcons.seedling,
            'Soil pH',
            '5.5 to 6.5 (slightly acidic)',
          ),
        ];
      case 'corn':
        return [
          _buildConditionItem(
            AppIcons.sun,
            'Sunlight',
            'Full sun (8+ hours daily)',
          ),
          _buildConditionItem(
            AppIcons.waterDrop,
            'Water',
            'Regular watering, 1-2 inches weekly',
          ),
          _buildConditionItem(
            AppIcons.seedling,
            'Soil pH',
            '6.0 to 7.0 (neutral to slightly acidic)',
          ),
        ];
      case 'okra':
        return [
          _buildConditionItem(
            AppIcons.sun,
            'Sunlight',
            'Full sun (6-8 hours daily)',
          ),
          _buildConditionItem(
            AppIcons.waterDrop,
            'Water',
            'Moderate, consistent moisture',
          ),
          _buildConditionItem(
            AppIcons.seedling,
            'Soil pH',
            '6.5 to 7.0 (slightly acidic to neutral)',
          ),
        ];
      case 'cucumber':
        return [
          _buildConditionItem(
            AppIcons.sun,
            'Sunlight',
            'Full sun (6-8 hours daily)',
          ),
          _buildConditionItem(
            AppIcons.waterDrop,
            'Water',
            'Consistent moisture, avoid waterlogging',
          ),
          _buildConditionItem(
            AppIcons.seedling,
            'Soil pH',
            '6.0 to 7.0 (slightly acidic to neutral)',
          ),
        ];
      default:
        return [
          _buildConditionItem(AppIcons.sun, 'Sunlight', 'Full sun recommended'),
          _buildConditionItem(AppIcons.waterDrop, 'Water', 'Regular watering'),
          _buildConditionItem(
            AppIcons.seedling,
            'Soil pH',
            '6.5 to 7.0 (neutral)',
          ),
        ];
    }
  }
}
