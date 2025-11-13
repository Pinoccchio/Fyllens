/// Standardized spacing values
/// Use these constants for consistent spacing throughout the app
/// Based on 8px grid system (industry standard)
class AppSpacing {
  // Prevent instantiation
  AppSpacing._();

  // Base 8px grid spacing
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;

  // Border Radius (Modern Flat UI - moderate rounding)
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radiusPill = 24.0; // For pill-shaped buttons

  // Component-specific dimensions
  static const double buttonHeight = 48.0; // Minimum touch target (WCAG)
  static const double inputHeight = 56.0; // Material Design standard
  static const double touchTarget = 48.0; // Minimum interactive size

  // Icon Sizes
  static const double iconXs = 16.0;
  static const double iconSm = 20.0;
  static const double iconMd = 24.0;
  static const double iconLg = 48.0;
  static const double iconXl = 80.0; // Logo size

  // Content Padding
  static const double screenPaddingHorizontal = 24.0;
  static const double screenPaddingVertical = 16.0;
  static const double cardPadding = 20.0;
  static const double sectionPadding = 32.0;

  // Layout constraints
  static const double maxContentWidth = 400.0; // For forms on large screens

  // Elevation (for subtle shadows in Flat 2.0)
  static const double elevation0 = 0.0;
  static const double elevation1 = 1.0;
  static const double elevation2 = 2.0;
  static const double elevation4 = 4.0;
  static const double elevation8 = 8.0;
}
