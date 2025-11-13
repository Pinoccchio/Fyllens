import 'package:flutter/material.dart';
import 'package:fyllens/core/theme/app_colors.dart';

/// App-wide text styles
/// Centralized typography definitions
class AppTextStyles {
  // Prevent instantiation
  AppTextStyles._();

  // App Title/Logo
  static const TextStyle appTitle = TextStyle(
    color: AppColors.primaryGreen,
    fontSize: 50,
    fontWeight: FontWeight.bold,
    letterSpacing: 20,
  );

  // Headings
  static const TextStyle heading1 = TextStyle(
    color: AppColors.textPrimaryLight,
    fontSize: 26,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  // Body Text
  static const TextStyle bodyText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle bodyTextBold = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  // Button Text
  static const TextStyle button = TextStyle(
    color: AppColors.textPrimaryLight,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  // Link Text
  static const TextStyle link = TextStyle(
    color: AppColors.textPrimaryLight,
  );

  // Hint Text
  static TextStyle hintText = TextStyle(
    color: AppColors.greenWithOpacity50,
  );

  // TextField Text
  static const TextStyle textFieldInput = TextStyle(
    color: AppColors.primaryGreen,
  );
}
