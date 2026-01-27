import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/theme/app_text_styles.dart';
import 'package:fyllens/core/constants/app_spacing.dart';
import 'package:fyllens/core/theme/app_icons.dart';
import 'package:fyllens/core/constants/app_routes.dart';
import 'package:fyllens/providers/scan_provider.dart';
import 'package:fyllens/providers/tab_provider.dart';
import 'package:fyllens/providers/auth_provider.dart';
import 'package:fyllens/providers/history_provider.dart';
import 'package:fyllens/providers/notification_provider.dart';
import 'package:fyllens/screens/shared/widgets/image_viewer_dialog.dart';
import 'package:fyllens/core/utils/health_status_helper.dart';

/// Scan results page showing deficiency detection and treatment
/// Displayed after scanning a plant from camera
///
/// Navigation: Camera → ScanResultsScreen
/// Button: "Done" (back to Scan tab to select another plant)
class ScanResultsScreen extends StatelessWidget {
  final String plantName;
  final String? imageAssetPath;
  final String deficiencyName;
  final String severity;
  final List<String> symptoms;
  final List<Map<String, String>> treatments;
  final List<String>? careTips;
  final List<String>? preventiveCare;
  final List<String>? growthOptimization;
  final List<String>? preventionTips; // For deficient plants

  const ScanResultsScreen({
    super.key,
    required this.plantName,
    this.imageAssetPath,
    required this.deficiencyName,
    required this.severity,
    required this.symptoms,
    required this.treatments,
    this.careTips,
    this.preventiveCare,
    this.growthOptimization,
    this.preventionTips,
  });

  @override
  Widget build(BuildContext context) {
    // Detect if plant is healthy
    final isHealthy = deficiencyName.toLowerCase() == 'healthy' ||
        deficiencyName.toLowerCase() == 'no deficiency detected' ||
        deficiencyName.toLowerCase() == 'no deficiency';

    // Get dynamic icon and colors from helper
    final statusIcon = HealthStatusHelper.getHealthIcon(
      isHealthy: isHealthy,
      severity: severity,
    );
    final statusColor = HealthStatusHelper.getHealthColor(
      isHealthy: isHealthy,
      severity: severity,
    );
    final statusBackgroundColor = HealthStatusHelper.getHealthColorWithOpacity(
      isHealthy: isHealthy,
      severity: severity,
      opacity: 0.1,
    );
    final badgeText = HealthStatusHelper.getHealthBadgeText(
      isHealthy: isHealthy,
      severity: severity,
    );
    final descriptionText = HealthStatusHelper.getHealthDescription(
      isHealthy: isHealthy,
      plantName: plantName,
      deficiencyName: deficiencyName,
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundSoft,
      body: SafeArea(
        child: Column(
          children: [
            // Header
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
                  const SizedBox(width: AppSpacing.md),
                  Text('Scan Results', style: AppTextStyles.heading2),
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
                    // Plant image (tap to view full screen)
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: imageAssetPath != null
                              ? () => ImageViewerDialog.show(
                                  context: context,
                                  imageUrl: imageAssetPath!,
                                )
                              : null,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusMd,
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              height: 200,
                              child: imageAssetPath != null
                                  ? Image.network(
                                      imageAssetPath!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              _buildPlaceholder(),
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value:
                                                    loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes!
                                                    : null,
                                              ),
                                            );
                                          },
                                    )
                                  : _buildPlaceholder(),
                            ),
                          ),
                        ),
                        // Tap indicator overlay
                        if (imageAssetPath != null)
                          Positioned(
                            bottom: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                PhosphorIcons.arrowsOutBold,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Health status/deficiency detection card
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusMd,
                        ),
                        border: Border.all(
                          color: AppColors.borderLight,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Dynamic icon with color
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            decoration: BoxDecoration(
                              color: statusBackgroundColor,
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusSm,
                              ),
                            ),
                            child: Icon(
                              statusIcon,
                              color: statusColor,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Dynamic title - always show actual deficiency name
                                Text(
                                  deficiencyName,
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                // Dynamic description
                                Text(
                                  descriptionText,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                // Dynamic badge (only show if not "Unknown Severity")
                                if (badgeText != 'Unknown Severity')
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: statusBackgroundColor.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(
                                        AppSpacing.radiusSm,
                                      ),
                                    ),
                                    child: Text(
                                      badgeText,
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: statusColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Conditional sections based on health status
                    // Only show symptoms and treatments for deficient plants
                    if (!isHealthy) ...[
                      // Symptoms section
                      Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusMd,
                        ),
                        border: Border.all(
                          color: AppColors.borderLight,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Symptoms', style: AppTextStyles.heading3),
                          const SizedBox(height: AppSpacing.sm),
                          ...symptoms.map(
                            (symptom) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 8),
                                    child: Icon(
                                      AppIcons.checkCircle,
                                      size: 6,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Expanded(
                                    child: Text(
                                      symptom,
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.textPrimary,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Treatment Recommendations section
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreenModern.withValues(alpha: 0.1),
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
                            'Treatment Recommendations',
                            style: AppTextStyles.heading3,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          ...treatments.asMap().entries.map((entry) {
                            final treatment = entry.value;
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: entry.key < treatments.length - 1
                                    ? AppSpacing.sm
                                    : 0,
                              ),
                              child: _buildTreatmentItem(
                                treatment['icon'] ?? 'medication',
                                treatment['title'] ?? 'Treatment',
                                treatment['description'] ??
                                    'No details available',
                              ),
                            );
                          }),
                        ],
                      ),
                    ),

                    // Prevention Tips section for deficient plants
                    if (!isHealthy && preventionTips != null && preventionTips!.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.md),
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusMd,
                          ),
                          border: Border.all(
                            color: AppColors.warning.withValues(
                              alpha: 0.5,
                            ),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  PhosphorIcons.shieldCheck,
                                  color: AppColors.warning,
                                  size: 24,
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Text(
                                  'How to Prevent This',
                                  style: AppTextStyles.heading3.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.md),
                            ...preventionTips!.map(
                              (tip) => _buildTipItem(tip),
                            ),
                          ],
                        ),
                      ),
                    ],
                    ],

                    // Care tips sections for healthy plants
                    if (isHealthy) ...[
                      // Care Tips Section
                      if (careTips != null && careTips!.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: HealthStatusHelper.healthyBackgroundColor,
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusMd,
                            ),
                            border: Border.all(
                              color: HealthStatusHelper.healthyColor.withValues(
                                alpha: 0.3,
                              ),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    PhosphorIcons.lightbulb,
                                    color: HealthStatusHelper.healthyColor,
                                    size: 24,
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Text(
                                    'General Care Tips',
                                    style: AppTextStyles.heading3.copyWith(
                                      color: HealthStatusHelper.healthyDarkColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.md),
                              ...careTips!.map(
                                (tip) => _buildTipItem(tip),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],

                      // Preventive Care Section
                      if (preventiveCare != null && preventiveCare!.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusMd,
                            ),
                            border: Border.all(
                              color: AppColors.borderLight,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    PhosphorIcons.shield,
                                    color: HealthStatusHelper.healthyColor,
                                    size: 24,
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Text(
                                    'Preventive Care',
                                    style: AppTextStyles.heading3.copyWith(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.md),
                              ...preventiveCare!.map(
                                (tip) => _buildTipItem(tip),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],

                      // Growth Optimization Section
                      if (growthOptimization != null && growthOptimization!.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusMd,
                            ),
                            border: Border.all(
                              color: AppColors.borderLight,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    PhosphorIcons.trendUp,
                                    color: HealthStatusHelper.healthyColor,
                                    size: 24,
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Text(
                                    'Growth Optimization',
                                    style: AppTextStyles.heading3.copyWith(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.md),
                              ...growthOptimization!.map(
                                (tip) => _buildTipItem(tip),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],

                      // Fallback message if no care tips available
                      if ((careTips == null || careTips!.isEmpty) &&
                          (preventiveCare == null || preventiveCare!.isEmpty) &&
                          (growthOptimization == null || growthOptimization!.isEmpty)) ...[
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: HealthStatusHelper.healthyBackgroundColor,
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusMd,
                            ),
                            border: Border.all(
                              color: HealthStatusHelper.healthyColor.withValues(
                                alpha: 0.3,
                              ),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    PhosphorIcons.checkCircle,
                                    color: HealthStatusHelper.healthyColor,
                                    size: 24,
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Text(
                                    'Keep Up the Good Work!',
                                    style: AppTextStyles.heading3.copyWith(
                                      color: HealthStatusHelper.healthyDarkColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                'Your $plantName is thriving! Continue with your current care routine to maintain its excellent health.',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textPrimary,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                    const SizedBox(height: AppSpacing.lg),

                    // Action button - Camera flow
                    // "Done" → clear scan and go back to Scan tab to select another plant
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          // Get user ID for refreshing data
                          final userId = context.read<AuthProvider>().currentUser?.id;

                          // Refresh history and notifications so new scan appears
                          if (userId != null) {
                            // Fire and forget - don't await to keep UI responsive
                            context.read<HistoryProvider>().loadHistory(userId);
                            context.read<NotificationProvider>().loadNotifications(userId);
                          }

                          // Clear current scan result
                          context.read<ScanProvider>().clearCurrentScan();

                          // Navigate to home and switch to Scan tab via TabProvider
                          context.go(AppRoutes.home);
                          context.read<TabProvider>().setTab(2);
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
                        child: Text(
                          'Done',
                          style: AppTextStyles.buttonMedium,
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

  Widget _buildTreatmentItem(
    String iconName,
    String title,
    String description,
  ) {
    IconData icon;
    switch (iconName) {
      case 'fertilizer':
        icon = AppIcons.plant;
        break;
      case 'organic':
        icon = AppIcons.leaf;
        break;
      case 'spray':
        icon = AppIcons.waterDrop;
        break;
      default:
        icon = AppIcons.checkCircle;
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(
          color: AppColors.primaryGreenModern.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primaryGreenModern.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 20, color: AppColors.primaryGreenModern),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
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

  Widget _buildTipItem(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Icon(
              AppIcons.checkCircle,
              size: 6,
              color: HealthStatusHelper.healthyColor,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              tip,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
