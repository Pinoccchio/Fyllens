import 'package:flutter/material.dart';
import 'package:fyllens/core/constants/app_spacing.dart';
import 'package:fyllens/core/utils/health_status_helper.dart';

/// Severity badge widget for plant health status
/// Shows colored badge with severity text (Mild, Moderate, Severe, Healthy)
/// Uses HealthStatusHelper for consistent color coding across the app
class SeverityBadge extends StatelessWidget {
  final String severity;
  final bool isHealthy;

  const SeverityBadge({
    super.key,
    required this.severity,
    this.isHealthy = false,
  });

  @override
  Widget build(BuildContext context) {
    // Get color and text from HealthStatusHelper
    final badgeColor = HealthStatusHelper.getHealthColor(
      isHealthy: isHealthy,
      severity: severity,
    );
    final badgeText = HealthStatusHelper.getHealthBadgeText(
      isHealthy: isHealthy,
      severity: severity,
    );

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Text(
        badgeText,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: badgeColor,
        ),
      ),
    );
  }
}
