import 'package:flutter/material.dart';
import 'package:fyllens/core/theme/app_colors.dart';

/// Standardized spacing values - "Organic Luxury" Design System
///
/// Use these constants for consistent spacing throughout the app.
/// Based on 8px grid system with enhanced values for premium feel.
class AppSpacing {
  // Prevent instantiation
  AppSpacing._();

  // ============================================================
  // BASE SPACING (8px Grid)
  // Core spacing values for margins and padding
  // ============================================================

  /// Extra small: 4px
  static const double xs = 4.0;

  /// Small: 8px
  static const double sm = 8.0;

  /// Medium: 16px (base unit)
  static const double md = 16.0;

  /// Large: 24px
  static const double lg = 24.0;

  /// Extra large: 32px
  static const double xl = 32.0;

  /// Double extra large: 48px
  static const double xxl = 48.0;

  /// Triple extra large: 64px
  static const double xxxl = 64.0;

  // ============================================================
  // BORDER RADIUS (Luxury - More Rounded)
  // Modern, softer corners for premium feel
  // ============================================================

  /// Extra small radius: 4px
  static const double radiusXs = 4.0;

  /// Small radius: 8px
  static const double radiusSm = 8.0;

  /// Medium radius: 12px
  static const double radiusMd = 12.0;

  /// Large radius: 16px
  static const double radiusLg = 16.0;

  /// Extra large radius: 20px
  static const double radiusXl = 20.0;

  /// Card radius: 24px (premium card corners)
  static const double radiusCard = 24.0;

  /// Pill shape: 999px (for buttons)
  static const double radiusPill = 999.0;

  /// Circle: for avatars and round elements
  static const double radiusCircle = 9999.0;

  // ============================================================
  // COMPONENT DIMENSIONS
  // Standardized sizes for interactive elements
  // ============================================================

  /// Button height: 56px (generous touch target)
  static const double buttonHeight = 56.0;

  /// Button height small: 44px
  static const double buttonHeightSmall = 44.0;

  /// Input height: 56px (Material Design standard)
  static const double inputHeight = 56.0;

  /// Minimum touch target: 48px (WCAG)
  static const double touchTarget = 48.0;

  /// Card minimum height: 80px
  static const double cardMinHeight = 80.0;

  /// Hero card height: 180px
  static const double heroCardHeight = 180.0;

  // ============================================================
  // ICON SIZES
  // Consistent icon scaling
  // ============================================================

  /// Extra small icon: 16px
  static const double iconXs = 16.0;

  /// Small icon: 20px
  static const double iconSm = 20.0;

  /// Medium icon: 24px (default)
  static const double iconMd = 24.0;

  /// Large icon: 32px
  static const double iconLg = 32.0;

  /// Extra large icon: 48px
  static const double iconXl = 48.0;

  /// Hero icon: 64px
  static const double iconHero = 64.0;

  /// Logo size: 80px
  static const double iconLogo = 80.0;

  // ============================================================
  // CONTENT PADDING
  // Screen and container padding values
  // ============================================================

  /// Screen padding: 24px (standard screen edge padding)
  static const double screenPadding = 24.0;

  /// Screen horizontal padding: 24px
  static const double screenPaddingHorizontal = 24.0;

  /// Screen vertical padding: 16px
  static const double screenPaddingVertical = 16.0;

  /// Card padding: 20px (standard)
  static const double cardPadding = 20.0;

  /// Card padding large: 24px (luxury cards)
  static const double cardPaddingLg = 24.0;

  /// Section padding: 32px
  static const double sectionPadding = 32.0;

  /// Modal padding: 24px
  static const double modalPadding = 24.0;

  // ============================================================
  // LAYOUT CONSTRAINTS
  // Maximum widths for content areas
  // ============================================================

  /// Max content width (forms): 400px
  static const double maxContentWidth = 400.0;

  /// Max card width: 360px
  static const double maxCardWidth = 360.0;

  /// Max dialog width: 320px
  static const double maxDialogWidth = 320.0;

  // ============================================================
  // ELEVATION (Layered Shadow System)
  // Consistent elevation values
  // ============================================================

  /// No elevation
  static const double elevation0 = 0.0;

  /// Subtle elevation: 1
  static const double elevation1 = 1.0;

  /// Light elevation: 2
  static const double elevation2 = 2.0;

  /// Medium elevation: 4
  static const double elevation4 = 4.0;

  /// High elevation: 8
  static const double elevation8 = 8.0;

  /// Modal elevation: 16
  static const double elevation16 = 16.0;

  // ============================================================
  // BOX SHADOWS (Layered Shadow System)
  // Pre-defined shadow configurations for depth
  // ============================================================

  /// Subtle shadow - for cards at rest
  static List<BoxShadow> get shadowSubtle => [
        BoxShadow(
          color: AppColors.shadowLight,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];

  /// Light shadow - for elevated cards
  static List<BoxShadow> get shadowLight => [
        BoxShadow(
          color: AppColors.shadowLight,
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
        BoxShadow(
          color: AppColors.shadowLight,
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      ];

  /// Medium shadow - for modals and dropdowns
  static List<BoxShadow> get shadowMedium => [
        BoxShadow(
          color: AppColors.shadowMedium,
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: AppColors.shadowLight,
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ];

  /// Heavy shadow - for floating elements
  static List<BoxShadow> get shadowHeavy => [
        BoxShadow(
          color: AppColors.shadowHeavy,
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: AppColors.shadowMedium,
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ];

  /// Card shadow - standard card elevation
  static List<BoxShadow> get shadowCard => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];

  /// Gold button shadow
  static List<BoxShadow> get shadowGold => [
        BoxShadow(
          color: AppColors.accentGold.withValues(alpha: 0.3),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  /// Green button shadow
  static List<BoxShadow> get shadowGreen => [
        BoxShadow(
          color: AppColors.primarySage.withValues(alpha: 0.3),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  // ============================================================
  // ANIMATION DURATIONS
  // Consistent timing for animations
  // ============================================================

  /// Fast animation: 100ms (for micro-interactions)
  static const Duration animationFast = Duration(milliseconds: 100);

  /// Quick animation: 150ms
  static const Duration animationQuick = Duration(milliseconds: 150);

  /// Standard animation: 300ms
  static const Duration animationStandard = Duration(milliseconds: 300);

  /// Slow animation: 500ms
  static const Duration animationSlow = Duration(milliseconds: 500);

  /// Page transition: 400ms
  static const Duration animationPage = Duration(milliseconds: 400);

  // ============================================================
  // ANIMATION CURVES
  // Consistent easing curves
  // ============================================================

  /// Standard ease out
  static const Curve curveStandard = Curves.easeOutCubic;

  /// Bounce effect
  static const Curve curveBounce = Curves.elasticOut;

  /// Smooth decelerate
  static const Curve curveDecelerate = Curves.decelerate;

  // ============================================================
  // BORDER WIDTHS
  // Consistent border styling
  // ============================================================

  /// Thin border: 1px
  static const double borderThin = 1.0;

  /// Medium border: 1.5px
  static const double borderMedium = 1.5;

  /// Thick border: 2px
  static const double borderThick = 2.0;

  /// Focus border: 2px
  static const double borderFocus = 2.0;
}
