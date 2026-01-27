import 'package:flutter/material.dart';
import 'package:fyllens/core/theme/app_colors.dart';

/// App-wide gradient definitions - "Organic Luxury" Design System
///
/// Centralized gradient configurations for consistent visual depth
/// and premium aesthetic across the application.
class AppGradients {
  // Prevent instantiation
  AppGradients._();

  // ============================================================
  // PRIMARY GRADIENTS (Forest Theme)
  // Deep botanical greens for hero elements
  // ============================================================

  /// Forest gradient - Deep hero backgrounds
  /// Use for: Hero cards, feature sections, premium elements
  static const LinearGradient forest = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.primaryForest,
      AppColors.primarySage,
    ],
  );

  /// Forest vertical - Top to bottom gradient
  static const LinearGradient forestVertical = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.primaryForest,
      AppColors.primarySage,
    ],
  );

  /// Forest light - Softer version for overlays
  static LinearGradient get forestLight => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.primaryForest.withValues(alpha: 0.9),
          AppColors.primarySage.withValues(alpha: 0.8),
        ],
      );

  // ============================================================
  // SAGE GRADIENTS
  // Muted green for action elements
  // ============================================================

  /// Sage gradient - Primary action backgrounds
  /// Use for: Scan cards, primary actions
  static const LinearGradient sage = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.primarySage,
      AppColors.primaryMint,
    ],
  );

  /// Sage vertical
  static const LinearGradient sageVertical = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.primarySage,
      AppColors.primaryMint,
    ],
  );

  // ============================================================
  // MINT GRADIENTS
  // Fresh light greens for highlights
  // ============================================================

  /// Mint gradient - Fresh accents
  /// Use for: Success states, highlights, badges
  static const LinearGradient mint = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.primaryMint,
      AppColors.primaryCelery,
    ],
  );

  // ============================================================
  // GOLD GRADIENTS (Warm Accent)
  // Premium warm tones for CTAs
  // ============================================================

  /// Gold gradient - Primary CTA background
  /// Use for: Main buttons, premium features, highlights
  static const LinearGradient gold = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.accentGold,
      Color(0xFFE5B68A), // Lighter gold
    ],
  );

  /// Gold to coral - Warm accent gradient
  /// Use for: AI features, special elements
  static const LinearGradient goldCoral = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.accentGold,
      AppColors.accentCoral,
    ],
  );

  /// Gold subtle - For hover states
  static LinearGradient get goldSubtle => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.accentGold.withValues(alpha: 0.9),
          AppColors.accentGold.withValues(alpha: 0.7),
        ],
      );

  // ============================================================
  // CORAL GRADIENTS
  // Warm coral for notifications and alerts
  // ============================================================

  /// Coral gradient - Alert/notification backgrounds
  static const LinearGradient coral = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.accentCoral,
      AppColors.accentTerracotta,
    ],
  );

  // ============================================================
  // BACKGROUND GRADIENTS
  // Subtle gradients for surfaces
  // ============================================================

  /// Cream gradient - Premium card backgrounds
  static const LinearGradient cream = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.backgroundWhite,
      AppColors.accentCream,
    ],
  );

  /// Warm background - Subtle warmth
  static const LinearGradient warmBackground = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.neutralMist,
      AppColors.neutralWarm,
    ],
  );

  /// Mist gradient - Cool subtle background
  static const LinearGradient mist = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.backgroundWhite,
      AppColors.neutralMist,
    ],
  );

  // ============================================================
  // OVERLAY GRADIENTS
  // For image overlays and fades
  // ============================================================

  /// Dark overlay - Bottom fade for images
  static LinearGradient get darkOverlay => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          Colors.black.withValues(alpha: 0.7),
        ],
      );

  /// Dark overlay full - Stronger fade
  static LinearGradient get darkOverlayFull => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.black.withValues(alpha: 0.1),
          Colors.black.withValues(alpha: 0.8),
        ],
      );

  /// Forest overlay - Green tinted overlay
  static LinearGradient get forestOverlay => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.primaryForest.withValues(alpha: 0.3),
          AppColors.primaryForest.withValues(alpha: 0.9),
        ],
      );

  /// Gold overlay - Warm tinted overlay
  static LinearGradient get goldOverlay => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.accentGold.withValues(alpha: 0.2),
          AppColors.accentGold.withValues(alpha: 0.6),
        ],
      );

  // ============================================================
  // STATUS GRADIENTS
  // For status indicators and badges
  // ============================================================

  /// Healthy gradient - Success states
  static const LinearGradient healthy = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.statusHealthy,
      Color(0xFF5AB391), // Lighter healthy
    ],
  );

  /// Warning gradient
  static const LinearGradient warning = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.statusWarning,
      Color(0xFFF5B94D), // Lighter warning
    ],
  );

  /// Critical gradient
  static const LinearGradient critical = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.statusCritical,
      Color(0xFFE57373), // Lighter critical
    ],
  );

  // ============================================================
  // GLASSMORPHISM
  // Frosted glass effect backgrounds
  // ============================================================

  /// Glass light - Light frosted glass
  static LinearGradient get glassLight => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.6),
          Colors.white.withValues(alpha: 0.3),
        ],
      );

  /// Glass dark - Dark frosted glass
  static LinearGradient get glassDark => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.black.withValues(alpha: 0.4),
          Colors.black.withValues(alpha: 0.2),
        ],
      );

  /// Glass forest - Green tinted glass
  static LinearGradient get glassForest => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.primaryForest.withValues(alpha: 0.5),
          AppColors.primarySage.withValues(alpha: 0.3),
        ],
      );

  // ============================================================
  // RADIAL GRADIENTS
  // For glow effects and spotlights
  // ============================================================

  /// Gold glow - Radial glow effect
  static RadialGradient get goldGlow => RadialGradient(
        colors: [
          AppColors.accentGold.withValues(alpha: 0.3),
          AppColors.accentGold.withValues(alpha: 0.1),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      );

  /// Forest glow - Green radial glow
  static RadialGradient get forestGlow => RadialGradient(
        colors: [
          AppColors.primarySage.withValues(alpha: 0.3),
          AppColors.primarySage.withValues(alpha: 0.1),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      );

  /// Mint glow - Light green glow
  static RadialGradient get mintGlow => RadialGradient(
        colors: [
          AppColors.primaryMint.withValues(alpha: 0.2),
          AppColors.primaryCelery.withValues(alpha: 0.1),
          Colors.transparent,
        ],
        stops: const [0.0, 0.6, 1.0],
      );

  // ============================================================
  // SWEEP GRADIENTS
  // For circular/rotating effects
  // ============================================================

  /// Forest sweep - Rotating forest gradient
  static const SweepGradient forestSweep = SweepGradient(
    colors: [
      AppColors.primaryForest,
      AppColors.primarySage,
      AppColors.primaryMint,
      AppColors.primarySage,
      AppColors.primaryForest,
    ],
  );
}
