import 'package:flutter/material.dart';

/// App-wide color palette
/// Centralized color definitions for consistency across the app
class AppColors {
  // Prevent instantiation
  AppColors._();

  // Primary Green Colors (Brand Colors)
  static const Color primaryGreen = Color(0xFF388E3C); // green[700]
  static final Color primaryGreenDark = Colors.green.shade900;

  // Green Variants
  static final Color greenWithOpacity70 = primaryGreen.withOpacity(0.7);
  static final Color greenWithOpacity50 = primaryGreen.withOpacity(0.5);

  // Background Colors
  static const Color backgroundLight = Colors.white;
  static const Color backgroundDark = Color(0xFF121212);

  // Surface Colors
  static const Color surfaceLight = Colors.white;
  static final Color surfaceDark = Colors.grey.shade900;

  // Text Colors
  static const Color textPrimaryLight = Colors.white;
  static const Color textPrimaryDark = Colors.black87;
  static const Color textSecondaryLight = Colors.white70;
  static final Color textOnGreen = Colors.white;

  // Border Colors
  static const Color borderLight = Colors.white;
  static final Color borderFocused = primaryGreenDark;

  // Icon Colors
  static const Color iconPrimary = primaryGreen;
}
