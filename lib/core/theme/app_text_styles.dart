import 'package:flutter/material.dart';
import 'package:fyllens/core/theme/app_colors.dart';

/// App-wide text styles
/// Centralized typography definitions
class AppTextStyles {
  // Prevent instantiation
  AppTextStyles._();

  // App Branding
  static const TextStyle appTitle = TextStyle(
    color: AppColors.primaryGreen,
    fontSize: 48,
    fontWeight: FontWeight.w700,
    letterSpacing: 8, // Reduced from 20 for modern look
    height: 1.2,
  );

  static const TextStyle appSubtitle = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.4,
  );

  // Headings
  static const TextStyle heading1 = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static const TextStyle heading2 = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static const TextStyle heading3 = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  // Body Text
  static const TextStyle bodyLarge = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  // Input Fields
  static const TextStyle inputText = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle inputHint = TextStyle(
    color: AppColors.textHint,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle inputLabel = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  static const TextStyle inputError = TextStyle(
    color: AppColors.error,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  // Buttons
  static const TextStyle buttonLarge = TextStyle(
    color: AppColors.textOnPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.25,
    height: 1.0,
  );

  static const TextStyle buttonMedium = TextStyle(
    color: AppColors.textOnPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.25,
    height: 1.0,
  );

  static const TextStyle buttonSmall = TextStyle(
    color: AppColors.textOnPrimary,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.0,
    height: 1.0,
  );

  // Links
  static const TextStyle linkLarge = TextStyle(
    color: AppColors.primaryGreen,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.none,
  );

  static const TextStyle linkMedium = TextStyle(
    color: AppColors.primaryGreen,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.none,
  );

  static const TextStyle linkSmall = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.none,
  );

  // Special text styles
  static const TextStyle caption = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
  );

  static const TextStyle overline = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.5,
  );
}
