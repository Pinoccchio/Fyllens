import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Helper utilities for health status display
///
/// Provides centralized logic for:
/// - Icon selection based on health status and severity
/// - Color coding for different health states
/// - Badge text formatting
///
/// This ensures consistent visual representation of plant health
/// across all screens (scan results, history, etc.)
class HealthStatusHelper {
  HealthStatusHelper._(); // Private constructor - static utility class

  // ==================== COLOR PALETTE ====================

  /// Material Green 500 - Used for healthy plants
  static const Color healthyColor = Color(0xFF4CAF50);

  /// Material Green 900 - Dark green for healthy text
  static const Color healthyDarkColor = Color(0xFF2E7D32);

  /// Material Light Green 50 - Background for healthy sections
  static const Color healthyBackgroundColor = Color(0xFFE8F5E9);

  /// Material Orange 500 - Used for mild severity
  static const Color mildColor = Color(0xFFFF9800);

  /// Material Deep Orange 900 - Dark orange for mild text
  static const Color mildDarkColor = Color(0xFFE65100);

  /// Material Orange 50 - Background for mild sections
  static const Color mildBackgroundColor = Color(0xFFFFF3E0);

  /// Material Deep Orange 500 - Used for moderate severity
  static const Color moderateColor = Color(0xFFFF5722);

  /// Material Deep Orange 900 - Dark color for moderate text
  static const Color moderateDarkColor = Color(0xFFD84315);

  /// Material Deep Orange 50 - Background for moderate sections
  static const Color moderateBackgroundColor = Color(0xFFFBE9E7);

  /// Material Red 500 - Used for severe cases
  static const Color severeColor = Color(0xFFF44336);

  /// Material Red 900 - Dark red for severe text
  static const Color severeDarkColor = Color(0xFFC62828);

  /// Material Red 50 - Background for severe sections
  static const Color severeBackgroundColor = Color(0xFFFFEBEE);

  // ==================== ICON SELECTION ====================

  /// Get appropriate icon based on health status
  ///
  /// Returns:
  /// - Green checkmark (✓) for healthy plants
  /// - Orange/red warning (⚠) for deficient plants based on severity
  static IconData getHealthIcon({
    required bool isHealthy,
    String? severity,
  }) {
    if (isHealthy) {
      return PhosphorIcons.checkCircle; // ✓ Checkmark for healthy
    }

    // All deficient plants use warning icon
    // Color differentiation happens via getHealthColor()
    return PhosphorIcons.warning; // ⚠ Warning for deficiencies
  }

  // ==================== COLOR SELECTION ====================

  /// Get primary color based on health status and severity
  ///
  /// Used for icons, badges, and accents
  static Color getHealthColor({
    required bool isHealthy,
    String? severity,
  }) {
    if (isHealthy) {
      return healthyColor; // Green for healthy
    }

    // Color-code deficient plants by severity
    switch (severity?.toLowerCase()) {
      case 'mild':
        return mildColor; // Orange
      case 'moderate':
        return moderateColor; // Deep Orange
      case 'severe':
        return severeColor; // Red
      default:
        return mildColor; // Default to mild/orange if unknown
    }
  }

  /// Get dark variant of health color for text
  ///
  /// Used for badge text and headings
  static Color getHealthDarkColor({
    required bool isHealthy,
    String? severity,
  }) {
    if (isHealthy) {
      return healthyDarkColor;
    }

    switch (severity?.toLowerCase()) {
      case 'mild':
        return mildDarkColor;
      case 'moderate':
        return moderateDarkColor;
      case 'severe':
        return severeDarkColor;
      default:
        return mildDarkColor;
    }
  }

  /// Get background color for health sections
  ///
  /// Used for card backgrounds, info boxes
  static Color getHealthBackgroundColor({
    required bool isHealthy,
    String? severity,
  }) {
    if (isHealthy) {
      return healthyBackgroundColor;
    }

    switch (severity?.toLowerCase()) {
      case 'mild':
        return mildBackgroundColor;
      case 'moderate':
        return moderateBackgroundColor;
      case 'severe':
        return severeBackgroundColor;
      default:
        return mildBackgroundColor;
    }
  }

  /// Get color with custom opacity
  ///
  /// Useful for creating lighter versions of colors
  static Color getHealthColorWithOpacity({
    required bool isHealthy,
    String? severity,
    required double opacity,
  }) {
    final baseColor = getHealthColor(isHealthy: isHealthy, severity: severity);
    return baseColor.withValues(alpha: opacity);
  }

  // ==================== TEXT FORMATTING ====================

  /// Get badge text for health status
  ///
  /// Returns formatted text for status badges:
  /// - "Healthy" or "Healthy (95%)" for healthy plants
  /// - "Mild Severity", "Moderate Severity", "Severe" for deficient plants
  static String getHealthBadgeText({
    required bool isHealthy,
    String? severity,
    double? confidence,
    bool showConfidence = false,
  }) {
    if (isHealthy) {
      if (showConfidence && confidence != null) {
        return 'Healthy (${(confidence * 100).toStringAsFixed(0)}%)';
      }
      return 'Healthy';
    }

    // Format severity badge text
    switch (severity?.toLowerCase()) {
      case 'mild':
        return 'Mild Severity';
      case 'moderate':
        return 'Moderate Severity';
      case 'severe':
        return 'Severe';
      default:
        return 'Unknown Severity';
    }
  }

  /// Get title text for detection card
  ///
  /// Returns appropriate title based on health status
  static String getHealthTitle(bool isHealthy) {
    return isHealthy ? 'Plant Health Status' : 'Deficiency Detected';
  }

  /// Get description text for detection card
  ///
  /// Returns contextual description text
  static String getHealthDescription({
    required bool isHealthy,
    required String plantName,
    String? deficiencyName,
  }) {
    if (isHealthy) {
      return 'Your $plantName is in excellent condition!';
    }

    return 'Detected in $plantName plant';
  }

  // ==================== SEVERITY LEVEL HELPERS ====================

  /// Check if severity level is considered dangerous
  ///
  /// Used to determine when to show urgent warnings
  static bool isSeverityDangerous(String? severity) {
    return severity?.toLowerCase() == 'severe' ||
        severity?.toLowerCase() == 'critical';
  }

  /// Check if severity level requires immediate action
  ///
  /// Includes both moderate and severe levels
  static bool requiresImmediateAction(String? severity) {
    final level = severity?.toLowerCase();
    return level == 'moderate' || level == 'severe' || level == 'critical';
  }

  /// Get urgency level (0-3) from severity
  ///
  /// 0 = Healthy, 1 = Mild, 2 = Moderate, 3 = Severe
  /// Useful for sorting or priority display
  static int getUrgencyLevel({
    required bool isHealthy,
    String? severity,
  }) {
    if (isHealthy) return 0;

    switch (severity?.toLowerCase()) {
      case 'mild':
        return 1;
      case 'moderate':
        return 2;
      case 'severe':
      case 'critical':
        return 3;
      default:
        return 1; // Default to mild if unknown
    }
  }
}
