import 'package:flutter/material.dart';

/// App-wide color palette
/// Centralized color definitions for consistency across the app
/// All colors meet WCAG AA accessibility standards
class AppColors {
  // Prevent instantiation
  AppColors._();

  // Primary Green Colors (Brand Colors) - WCAG Compliant
  static const Color primaryGreen = Color(0xFF2E7D32); // green[800] - 4.5:1 contrast on white
  static const Color primaryGreenLight = Color(0xFF43A047); // green[600]
  static const Color primaryGreenDark = Color(0xFF1B5E20); // green[900]

  // Accent colors for CTAs
  static const Color accentGreen = Color(0xFF4CAF50); // Material green[500]
  static const Color accentGreenHover = Color(0xFF66BB6A); // green[400]

  // Modern Flat UI Colors (inspired by contemporary plant apps)
  static const Color primaryGreenModern = Color(0xFF66BB6A); // Brighter, more vibrant green
  static const Color accentMint = Color(0xFF81C784); // Mint green for highlights
  static const Color backgroundSoft = Color(0xFFFAFAFA); // Softer than F5F5F5 for modern cards

  // Background Colors
  static const Color backgroundLight = Color(0xFFF5F5F5); // Slightly off-white, reduces eye strain
  static const Color backgroundWhite = Colors.white;
  static const Color backgroundDark = Color(0xFF121212);

  // Surface Colors (for cards, elevated elements)
  static const Color surfaceLight = Colors.white;
  static final Color surfaceDark = Colors.grey.shade900;
  static const Color surfaceGray = Color(0xFFF5F5F5); // For filled text fields

  // Text Colors (WCAG Compliant)
  static const Color textPrimary = Color(0xFF212121); // Almost black - 16.1:1 contrast
  static const Color textSecondary = Color(0xFF757575); // Medium gray - 4.6:1 contrast
  static const Color textHint = Color(0xFF9E9E9E); // Light gray - 2.8:1 (for hints only)
  static const Color textOnPrimary = Colors.white; // White on green backgrounds
  static const Color textDisabled = Color(0xFFBDBDBD);

  // State Colors
  static const Color error = Color(0xFFD32F2F); // red[700]
  static const Color errorLight = Color(0xFFEF5350); // red[400]
  static const Color success = Color(0xFF388E3C); // green[700]
  static const Color warning = Color(0xFFF57C00); // orange[700]
  static const Color info = Color(0xFF1976D2); // blue[700]

  // Border Colors
  static const Color borderLight = Color(0xFFE0E0E0); // Light gray border
  static const Color borderMedium = Color(0xFFBDBDBD); // Medium gray border
  static const Color borderFocused = primaryGreen; // Focused state
  static const Color borderError = error;

  // Icon Colors
  static const Color iconPrimary = primaryGreen;
  static const Color iconSecondary = textSecondary;
  static const Color iconDisabled = Color(0xFFBDBDBD);

  // Shadow Colors
  static const Color shadowLight = Color(0x0F000000); // 6% black
  static const Color shadowMedium = Color(0x1F000000); // 12% black
}
