import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/theme/app_fonts.dart';

/// App-wide text styles - "Organic Luxury" Typography System
///
/// Uses Google Fonts for premium typography:
/// - DM Serif Display for headings (botanical elegance)
/// - DM Sans for body text (modern clarity)
/// - Space Mono for data/metrics (scientific precision)
class AppTextStyles {
  // Prevent instantiation
  AppTextStyles._();

  // ============================================================
  // DISPLAY STYLES (DM Serif Display)
  // Elegant serif for headings and hero text
  // ============================================================

  /// App branding - large logo text
  static TextStyle get appTitle => GoogleFonts.dmSerifDisplay(
        color: AppColors.primarySage,
        fontSize: 48,
        fontWeight: FontWeight.w400,
        letterSpacing: 2,
        height: 1.2,
      );

  /// App subtitle - tagline text
  static TextStyle get appSubtitle => GoogleFonts.dmSans(
        color: AppColors.textSecondary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 1.4,
      );

  /// Display Large - Hero headlines
  static TextStyle get displayLarge => GoogleFonts.dmSerifDisplay(
        color: AppColors.textPrimary,
        fontSize: 40,
        fontWeight: FontWeight.w400,
        letterSpacing: AppFonts.letterSpacingDisplay,
        height: 1.2,
      );

  /// Display Medium - Section headlines
  static TextStyle get displayMedium => GoogleFonts.dmSerifDisplay(
        color: AppColors.textPrimary,
        fontSize: 32,
        fontWeight: FontWeight.w400,
        letterSpacing: AppFonts.letterSpacingDisplay,
        height: 1.25,
      );

  /// Display Small - Card titles
  static TextStyle get displaySmall => GoogleFonts.dmSerifDisplay(
        color: AppColors.textPrimary,
        fontSize: 28,
        fontWeight: FontWeight.w400,
        letterSpacing: AppFonts.letterSpacingDisplay,
        height: 1.3,
      );

  // ============================================================
  // HEADING STYLES (DM Serif Display)
  // For section headers and card titles
  // ============================================================

  /// Heading 1 - Page titles
  static TextStyle get heading1 => GoogleFonts.dmSerifDisplay(
        color: AppColors.textPrimary,
        fontSize: 24,
        fontWeight: FontWeight.w400,
        height: 1.3,
        letterSpacing: -0.3,
      );

  /// Heading 2 - Section titles
  static TextStyle get heading2 => GoogleFonts.dmSerifDisplay(
        color: AppColors.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w400,
        height: 1.35,
        letterSpacing: -0.2,
      );

  /// Heading 3 - Card titles, subsections
  static TextStyle get heading3 => GoogleFonts.dmSerifDisplay(
        color: AppColors.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w400,
        height: 1.4,
        letterSpacing: -0.1,
      );

  // ============================================================
  // BODY STYLES (DM Sans)
  // For paragraphs, descriptions, and UI text
  // ============================================================

  /// Body Large - Primary content
  static TextStyle get bodyLarge => GoogleFonts.dmSans(
        color: AppColors.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        letterSpacing: AppFonts.letterSpacingBody,
      );

  /// Body Medium - Standard content
  static TextStyle get bodyMedium => GoogleFonts.dmSans(
        color: AppColors.textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        letterSpacing: AppFonts.letterSpacingBody,
      );

  /// Body Small - Secondary content
  static TextStyle get bodySmall => GoogleFonts.dmSans(
        color: AppColors.textSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
        letterSpacing: AppFonts.letterSpacingBody,
      );

  // ============================================================
  // INPUT STYLES (DM Sans)
  // For form fields and user input
  // ============================================================

  /// Input text - User entered text
  static TextStyle get inputText => GoogleFonts.dmSans(
        color: AppColors.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  /// Input hint - Placeholder text
  static TextStyle get inputHint => GoogleFonts.dmSans(
        color: AppColors.textHint,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  /// Input label - Field labels
  static TextStyle get inputLabel => GoogleFonts.dmSans(
        color: AppColors.textSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      );

  /// Input error - Validation errors
  static TextStyle get inputError => GoogleFonts.dmSans(
        color: AppColors.error,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
      );

  // ============================================================
  // BUTTON STYLES (DM Sans)
  // For buttons and interactive elements
  // ============================================================

  /// Button Large - Primary CTAs
  static TextStyle get buttonLarge => GoogleFonts.dmSans(
        color: AppColors.textOnPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: AppFonts.letterSpacingButton,
        height: 1.0,
      );

  /// Button Medium - Standard buttons
  static TextStyle get buttonMedium => GoogleFonts.dmSans(
        color: AppColors.textOnPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: AppFonts.letterSpacingButton,
        height: 1.0,
      );

  /// Button Small - Compact buttons
  static TextStyle get buttonSmall => GoogleFonts.dmSans(
        color: AppColors.textOnPrimary,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
        height: 1.0,
      );

  /// Button Gold - Gold CTA text (dark on gold)
  static TextStyle get buttonGold => GoogleFonts.dmSans(
        color: AppColors.textOnGold,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: AppFonts.letterSpacingButton,
        height: 1.0,
      );

  // ============================================================
  // LINK STYLES (DM Sans)
  // For clickable text links
  // ============================================================

  /// Link Large - Primary links
  static TextStyle get linkLarge => GoogleFonts.dmSans(
        color: AppColors.primarySage,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        decoration: TextDecoration.none,
      );

  /// Link Medium - Standard links
  static TextStyle get linkMedium => GoogleFonts.dmSans(
        color: AppColors.primarySage,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        decoration: TextDecoration.none,
      );

  /// Link Small - Compact links
  static TextStyle get linkSmall => GoogleFonts.dmSans(
        color: AppColors.textSecondary,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        decoration: TextDecoration.none,
      );

  // ============================================================
  // SPECIAL STYLES
  // For labels, captions, and data
  // ============================================================

  /// Caption - Small descriptive text
  static TextStyle get caption => GoogleFonts.dmSans(
        color: AppColors.textSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      );

  /// Overline - Section labels
  static TextStyle get overline => GoogleFonts.dmSans(
        color: AppColors.textSecondary,
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: AppFonts.letterSpacingLabel,
      );

  /// Label - Form labels and badges
  static TextStyle get label => GoogleFonts.dmSans(
        color: AppColors.textSecondary,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      );

  /// Label Large - Prominent labels
  static TextStyle get labelLarge => GoogleFonts.dmSans(
        color: AppColors.textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      );

  /// Label Medium - Standard labels
  static TextStyle get labelMedium => GoogleFonts.dmSans(
        color: AppColors.textPrimary,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
      );

  /// Label Small - Compact labels
  static TextStyle get labelSmall => GoogleFonts.dmSans(
        color: AppColors.textSecondary,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      );

  // ============================================================
  // DATA STYLES (Space Mono)
  // For metrics, percentages, and technical data
  // ============================================================

  /// Data Large - Prominent metrics
  static TextStyle get dataLarge => GoogleFonts.spaceMono(
        color: AppColors.textPrimary,
        fontSize: 24,
        fontWeight: FontWeight.w400,
        letterSpacing: AppFonts.letterSpacingMono,
        height: 1.2,
      );

  /// Data Medium - Standard metrics
  static TextStyle get dataMedium => GoogleFonts.spaceMono(
        color: AppColors.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: AppFonts.letterSpacingMono,
        height: 1.3,
      );

  /// Data Small - Compact metrics
  static TextStyle get dataSmall => GoogleFonts.spaceMono(
        color: AppColors.textSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: AppFonts.letterSpacingMono,
        height: 1.4,
      );

  /// Percentage - Confidence scores
  static TextStyle get percentage => GoogleFonts.spaceMono(
        color: AppColors.primarySage,
        fontSize: 14,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
      );

  /// Timestamp - Dates and times
  static TextStyle get timestamp => GoogleFonts.spaceMono(
        color: AppColors.textSecondary,
        fontSize: 11,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
      );

  // ============================================================
  // BADGE STYLES
  // For status badges and chips
  // ============================================================

  /// Badge text - Status indicators
  static TextStyle get badge => GoogleFonts.dmSans(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      );

  /// Chip text - Filter chips
  static TextStyle get chip => GoogleFonts.dmSans(
        fontSize: 13,
        fontWeight: FontWeight.w500,
      );

  // ============================================================
  // CARD STYLES
  // Specialized styles for cards
  // ============================================================

  /// Card title - Using serif for elegance
  static TextStyle get cardTitle => GoogleFonts.dmSerifDisplay(
        color: AppColors.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.3,
      );

  /// Card subtitle
  static TextStyle get cardSubtitle => GoogleFonts.dmSans(
        color: AppColors.textSecondary,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.4,
      );

  /// Plant name - For plant cards in library
  static TextStyle get plantName => GoogleFonts.dmSerifDisplay(
        color: AppColors.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w400,
        height: 1.3,
      );
}
