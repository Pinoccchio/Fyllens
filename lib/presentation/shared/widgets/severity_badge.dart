import 'package:flutter/material.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/constants/app_spacing.dart';

/// Severity badge widget for deficiency levels
/// Shows colored badge with severity text (Mild, Moderate, Severe)
class SeverityBadge extends StatelessWidget {
  final String severity;

  const SeverityBadge({
    super.key,
    required this.severity,
  });

  Color _getBadgeColor() {
    switch (severity.toLowerCase()) {
      case 'mild':
        return const Color(0xFFFFC107); // Amber/yellow
      case 'moderate':
        return const Color(0xFFFF9800); // Orange
      case 'severe':
        return const Color(0xFFF44336); // Red
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: _getBadgeColor().withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Text(
        severity,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: _getBadgeColor(),
        ),
      ),
    );
  }
}
