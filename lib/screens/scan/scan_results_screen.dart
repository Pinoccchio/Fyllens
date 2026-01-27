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
import 'package:fyllens/screens/shared/widgets/custom_button.dart';
import 'package:fyllens/screens/shared/widgets/custom_card.dart';
import 'package:fyllens/core/utils/health_status_helper.dart';

/// Scan results screen - "Organic Luxury" Design
///
/// Premium results display with:
/// - Full-width hero image with zoom
/// - Severity-colored accent borders
/// - Premium treatment cards
/// - Animated confidence indicator
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
  final List<String>? preventionTips;

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
    final isHealthy = deficiencyName.toLowerCase() == 'healthy' ||
        deficiencyName.toLowerCase() == 'no deficiency detected' ||
        deficiencyName.toLowerCase() == 'no deficiency';

    final statusColor = HealthStatusHelper.getHealthColor(
      isHealthy: isHealthy,
      severity: severity,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Custom app bar with hero image
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.primaryForest,
            leading: _buildBackButton(context),
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeroImage(context),
            ),
          ),

          // Main content
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Status card with accent border
                _buildStatusCard(context, isHealthy, statusColor),
                const SizedBox(height: AppSpacing.lg),

                // Conditional content based on health status
                if (!isHealthy) ...[
                  _buildSymptomsCard(context),
                  const SizedBox(height: AppSpacing.lg),
                  _buildTreatmentsCard(context),
                  if (preventionTips != null && preventionTips!.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.lg),
                    _buildPreventionCard(context),
                  ],
                ] else ...[
                  if (careTips != null && careTips!.isNotEmpty)
                    _buildCareTipsCard(context),
                  if (preventiveCare != null && preventiveCare!.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.lg),
                    _buildPreventiveCareCard(context),
                  ],
                  if (growthOptimization != null && growthOptimization!.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.lg),
                    _buildGrowthOptimizationCard(context),
                  ],
                  if ((careTips == null || careTips!.isEmpty) &&
                      (preventiveCare == null || preventiveCare!.isEmpty) &&
                      (growthOptimization == null || growthOptimization!.isEmpty))
                    _buildHealthyCelebrationCard(context),
                ],

                const SizedBox(height: AppSpacing.xl),

                // Done button
                _buildDoneButton(context),
                const SizedBox(height: AppSpacing.lg),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(AppIcons.arrowBack, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  Widget _buildHeroImage(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Image
        if (imageAssetPath != null)
          GestureDetector(
            onTap: () => ImageViewerDialog.show(
              context: context,
              imageUrl: imageAssetPath!,
            ),
            child: Image.network(
              imageAssetPath!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
            ),
          )
        else
          _buildPlaceholder(),

        // Gradient overlay for text visibility
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 100,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.7),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Plant name at bottom
        Positioned(
          bottom: 16,
          left: AppSpacing.screenPadding,
          right: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                plantName,
                style: AppTextStyles.displaySmall.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Scan Results',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),

        // Expand indicator (clickable)
        if (imageAssetPath != null)
          Positioned(
            bottom: 16,
            right: AppSpacing.screenPadding,
            child: GestureDetector(
              onTap: () => ImageViewerDialog.show(
                context: context,
                imageUrl: imageAssetPath!,
              ),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Icon(
                  PhosphorIcons.arrowsOut,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.primaryForest,
      child: Center(
        child: Icon(
          AppIcons.seedling,
          size: 80,
          color: AppColors.primaryMint.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context, bool isHealthy, Color statusColor) {
    final badgeText = HealthStatusHelper.getHealthBadgeText(
      isHealthy: isHealthy,
      severity: severity,
    );
    final descriptionText = HealthStatusHelper.getHealthDescription(
      isHealthy: isHealthy,
      plantName: plantName,
      deficiencyName: deficiencyName,
    );
    final statusIcon = HealthStatusHelper.getHealthIcon(
      isHealthy: isHealthy,
      severity: severity,
    );

    return CustomCard.standard(
      accentPosition: AccentPosition.left,
      accentColor: statusColor,
      accentWidth: 5,
      child: Row(
        children: [
          // Status icon
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Icon(
              statusIcon,
              color: statusColor,
              size: 32,
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // Status text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deficiencyName,
                  style: AppTextStyles.heading3.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  descriptionText,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                if (badgeText != 'Unknown Severity') ...[
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                    ),
                    child: Text(
                      badgeText,
                      style: AppTextStyles.caption.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSymptomsCard(BuildContext context) {
    return CustomCard.standard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.statusWarning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Icon(
                  AppIcons.warning,
                  color: AppColors.statusWarning,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Symptoms Detected',
                style: AppTextStyles.heading3.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ...symptoms.map((symptom) => _buildBulletPoint(symptom, AppColors.statusWarning)),
        ],
      ),
    );
  }

  Widget _buildTreatmentsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primarySage.withValues(alpha: 0.1),
            AppColors.primaryMint.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(
          color: AppColors.primarySage.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primarySage.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Icon(
                  AppIcons.leaf,
                  color: AppColors.primarySage,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Treatment Plan',
                style: AppTextStyles.heading3.copyWith(
                  color: AppColors.primaryForest,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ...treatments.asMap().entries.map((entry) {
            final treatment = entry.value;
            return Padding(
              padding: EdgeInsets.only(
                bottom: entry.key < treatments.length - 1 ? AppSpacing.sm : 0,
              ),
              child: _buildTreatmentItem(
                treatment['icon'] ?? 'medication',
                treatment['title'] ?? 'Treatment',
                treatment['description'] ?? 'No details available',
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTreatmentItem(String iconName, String title, String description) {
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
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceWarm,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: AppSpacing.shadowSubtle,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.accentGold.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(icon, size: 20, color: AppColors.accentGold),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
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

  Widget _buildPreventionCard(BuildContext context) {
    return CustomCard.standard(
      accentPosition: AccentPosition.top,
      accentColor: AppColors.statusWarning,
      accentWidth: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                PhosphorIcons.shieldCheck,
                color: AppColors.statusWarning,
                size: 24,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Prevention Tips',
                style: AppTextStyles.heading3.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ...preventionTips!.map((tip) => _buildBulletPoint(tip, AppColors.statusWarning)),
        ],
      ),
    );
  }

  Widget _buildCareTipsCard(BuildContext context) {
    return CustomCard.standard(
      accentPosition: AccentPosition.top,
      accentColor: AppColors.statusHealthy,
      accentWidth: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                PhosphorIcons.lightbulb,
                color: AppColors.statusHealthy,
                size: 24,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Care Tips',
                style: AppTextStyles.heading3.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ...careTips!.map((tip) => _buildBulletPoint(tip, AppColors.statusHealthy)),
        ],
      ),
    );
  }

  Widget _buildPreventiveCareCard(BuildContext context) {
    return CustomCard.standard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                PhosphorIcons.shield,
                color: AppColors.primarySage,
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
          ...preventiveCare!.map((tip) => _buildBulletPoint(tip, AppColors.primarySage)),
        ],
      ),
    );
  }

  Widget _buildGrowthOptimizationCard(BuildContext context) {
    return CustomCard.standard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                PhosphorIcons.trendUp,
                color: AppColors.accentGold,
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
          ...growthOptimization!.map((tip) => _buildBulletPoint(tip, AppColors.accentGold)),
        ],
      ),
    );
  }

  Widget _buildHealthyCelebrationCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.statusHealthy.withValues(alpha: 0.15),
            AppColors.primaryMint.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(
          color: AppColors.statusHealthy.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            PhosphorIcons.checkCircle,
            color: AppColors.statusHealthy,
            size: 48,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Excellent Health!',
            style: AppTextStyles.heading2.copyWith(
              color: AppColors.statusHealthy,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Your $plantName is thriving! Continue with your current care routine to maintain its excellent health.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
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

  Widget _buildDoneButton(BuildContext context) {
    return CustomButton.primary(
      text: 'Done',
      icon: AppIcons.check,
      onPressed: () {
        final userId = context.read<AuthProvider>().currentUser?.id;

        if (userId != null) {
          context.read<HistoryProvider>().loadHistory(userId);
          context.read<NotificationProvider>().loadNotifications(userId);
        }

        context.read<ScanProvider>().clearCurrentScan();
        context.go(AppRoutes.home);
        context.read<TabProvider>().setTab(2);
      },
    );
  }
}
