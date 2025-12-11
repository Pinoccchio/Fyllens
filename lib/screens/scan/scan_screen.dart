import 'package:flutter/material.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/theme/app_text_styles.dart';
import 'package:fyllens/core/constants/app_spacing.dart';
import 'package:fyllens/screens/shared/widgets/custom_list_tile.dart';
import 'package:fyllens/core/theme/app_icons.dart';
import 'package:fyllens/core/constants/app_routes.dart';
import 'package:go_router/go_router.dart';

/// Scan page - Camera interface for plant analysis
///
/// This is the core feature of the app. Users select a plant species
/// and take photos to identify nutrient deficiencies.
class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with SingleTickerProviderStateMixin {
  String? _selectedPlant;
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  final List<Map<String, String>> _plants = [
    {'name': 'Rice', 'species': 'Oryza sativa'},
    {'name': 'Corn', 'species': 'Zea mays'},
    {'name': 'Okra', 'species': 'Abelmoschus esculentus'},
    {'name': 'Cucumber', 'species': 'Cucumis sativus'},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onPlantSelected(String plantName) {
    setState(() {
      _selectedPlant = plantName;
    });
  }

  void _startScanning() {
    if (_selectedPlant != null) {
      context.push('${AppRoutes.scan}/camera/$_selectedPlant');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSoft,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundSoft,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: Text('Scan Plant', style: AppTextStyles.heading1),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Subtitle
                Text(
                  'Select plant species to scan',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Camera Preview Square - Hero Section
                Center(
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _selectedPlant != null ? _pulseAnimation.value : 1.0,
                        child: child,
                      );
                    },
                    child: GestureDetector(
                      onTap: _selectedPlant != null ? _startScanning : null,
                      child: Container(
                        width: 280,
                        height: 280,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: _selectedPlant != null
                                ? [
                                    AppColors.primaryGreenModern.withValues(alpha: 0.3),
                                    AppColors.primaryGreenModern.withValues(alpha: 0.1),
                                  ]
                                : [
                                    AppColors.surfaceLight.withValues(alpha: 0.5),
                                    AppColors.surfaceLight.withValues(alpha: 0.3),
                                  ],
                          ),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                          border: Border.all(
                            color: _selectedPlant != null
                                ? AppColors.primaryGreenModern
                                : AppColors.borderLight,
                            width: 3,
                          ),
                          boxShadow: _selectedPlant != null
                              ? [
                                  BoxShadow(
                                    color: AppColors.primaryGreenModern.withValues(alpha: 0.3),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Camera Icon
                            Container(
                              padding: const EdgeInsets.all(AppSpacing.lg),
                              decoration: BoxDecoration(
                                color: _selectedPlant != null
                                    ? AppColors.primaryGreenModern.withValues(alpha: 0.2)
                                    : AppColors.surfaceLight.withValues(alpha: 0.5),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                AppIcons.camera,
                                size: 72,
                                color: _selectedPlant != null
                                    ? AppColors.primaryGreenModern
                                    : AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),

                            // Text
                            Text(
                              _selectedPlant != null
                                  ? 'Tap to Start Scanning'
                                  : 'Select a Plant First',
                              style: AppTextStyles.heading3.copyWith(
                                color: _selectedPlant != null
                                    ? AppColors.primaryGreenModern
                                    : AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (_selectedPlant != null) ...[
                              const SizedBox(height: AppSpacing.xs),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                  vertical: AppSpacing.xs,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryGreenModern.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                ),
                                child: Text(
                                  _selectedPlant!,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.primaryGreenModern,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

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
                      Row(
                        children: [
                          Icon(
                            AppIcons.lightbulb,
                            size: 20,
                            color: AppColors.primaryGreenModern,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'Scanning Tips',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _buildTip('Ensure good lighting conditions'),
                      _buildTip('Focus on affected leaves'),
                      _buildTip('Keep camera steady and clear'),
                      _buildTip('Capture multiple angles if needed'),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Section title
                Row(
                  children: [
                    Icon(
                      AppIcons.seedling,
                      size: 24,
                      color: AppColors.primaryGreenModern,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text('Select Plant Species', style: AppTextStyles.heading3),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // Plant list
                ..._plants.map((plant) {
                  final isSelected = _selectedPlant == plant['name'];
                  return Container(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      border: isSelected
                          ? Border.all(
                              color: AppColors.primaryGreenModern,
                              width: 2,
                            )
                          : null,
                    ),
                    child: CustomListTile(
                      icon: AppIcons.seedling,
                      title: plant['name']!,
                      subtitle: plant['species']!,
                      trailing: isSelected ? 'selected' : null,
                      onTap: () => _onPlantSelected(plant['name']!),
                    ),
                  );
                }),
                const SizedBox(height: AppSpacing.xl),
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
            padding: const EdgeInsets.only(top: 6),
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: AppColors.primaryGreenModern,
                shape: BoxShape.circle,
              ),
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
