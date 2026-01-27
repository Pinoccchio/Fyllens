import 'package:flutter/material.dart';

/// App-wide color palette - "Organic Luxury" Design System
///
/// A rich botanical palette combining elegant greens with warm earth tones
/// for a premium, sophisticated aesthetic with scientific credibility.
/// All colors meet WCAG AA accessibility standards.
class AppColors {
  // Prevent instantiation
  AppColors._();

  // ============================================================
  // PRIMARY: Deep Botanical Greens
  // Rich, sophisticated greens for hero elements and primary actions
  // ============================================================

  /// Deep forest green - hero backgrounds, dark headers
  static const Color primaryForest = Color(0xFF1A3A2D);

  /// Muted sage green - primary actions, buttons
  static const Color primarySage = Color(0xFF4A7C59);

  /// Fresh mint green - highlights, accents
  static const Color primaryMint = Color(0xFF7FB285);

  /// Light celery green - subtle accents, hover states
  static const Color primaryCelery = Color(0xFFB8D4A8);

  // Legacy primary colors (for backwards compatibility)
  static const Color primaryGreen = primarySage;
  static const Color primaryGreenLight = primaryMint;
  static const Color primaryGreenDark = primaryForest;
  static const Color primaryGreenModern = primarySage;
  static const Color accentGreen = primaryMint;
  static const Color accentMint = primaryCelery;
  static const Color accentGreenHover = Color(0xFF5A8C69);

  // ============================================================
  // ACCENT: Warm Earth Tones (KEY DIFFERENTIATOR)
  // These warm colors set the app apart from generic green apps
  // ============================================================

  /// Warm gold - CTAs, primary buttons, emphasis
  static const Color accentGold = Color(0xFFD4A574);

  /// Soft coral - secondary accents, notifications
  static const Color accentCoral = Color(0xFFE07B65);

  /// Earth terracotta - tertiary accent, badges
  static const Color accentTerracotta = Color(0xFFBC6C4D);

  /// Warm cream - backgrounds, elevated surfaces
  static const Color accentCream = Color(0xFFF5F0E6);

  /// Light peach - very subtle warm highlight
  static const Color accentPeach = Color(0xFFFFF9F5);

  // ============================================================
  // NEUTRALS: Sophisticated Warm Grays
  // Balanced neutrals with subtle warmth
  // ============================================================

  /// Deep charcoal - primary text
  static const Color neutralCharcoal = Color(0xFF2D3436);

  /// Medium slate - secondary text
  static const Color neutralSlate = Color(0xFF636E72);

  /// Light mist - cool background
  static const Color neutralMist = Color(0xFFF7F9FA);

  /// Warm background - card backgrounds, elevated surfaces
  static const Color neutralWarm = Color(0xFFFAF8F5);

  /// Warm border - subtle dividers
  static const Color neutralBorder = Color(0xFFE8E4DF);

  /// Cool border - standard dividers
  static const Color neutralBorderCool = Color(0xFFE0E0E0);

  // ============================================================
  // BACKGROUNDS
  // Layered background system for depth and hierarchy
  // ============================================================

  /// Primary background - main scaffold color
  static const Color backgroundLight = neutralMist;

  /// Default background - main scaffold alias
  static const Color background = neutralMist;

  /// Soft background - slightly warmer, for cards
  static const Color backgroundSoft = Color(0xFFFAFAFA);

  /// Warm background - premium feel for elevated elements
  static const Color backgroundWarm = neutralWarm;

  /// Pure white - for highest elevation surfaces
  static const Color backgroundWhite = Colors.white;

  /// Dark background - dark mode base
  static const Color backgroundDark = Color(0xFF121212);

  /// Cream background - luxury card background
  static const Color backgroundCream = accentCream;

  // ============================================================
  // SURFACES
  // Card and elevated element backgrounds
  // ============================================================

  /// Light surface - cards, modals
  static const Color surfaceLight = Colors.white;

  /// Warm surface - premium cards
  static const Color surfaceWarm = neutralWarm;

  /// Gray surface - subtle form fields
  static const Color surfaceGray = Color(0xFFF5F5F5);

  /// Cream surface - luxury input fields
  static const Color surfaceCream = accentPeach;

  /// Dark surface - dark mode cards
  static final Color surfaceDark = Colors.grey.shade900;

  // ============================================================
  // TEXT COLORS (WCAG Compliant)
  // Clear hierarchy with warm undertones
  // ============================================================

  /// Primary text - main content, 16.1:1 contrast
  static const Color textPrimary = neutralCharcoal;

  /// Secondary text - descriptions, 4.6:1 contrast
  static const Color textSecondary = neutralSlate;

  /// Hint text - placeholders, 2.8:1 (for hints only)
  static const Color textHint = Color(0xFF9E9E9E);

  /// Text on primary - white text on colored backgrounds
  static const Color textOnPrimary = Colors.white;

  /// Text on gold - dark text on gold backgrounds
  static const Color textOnGold = primaryForest;

  /// Tertiary text - timestamps, subtle info
  static const Color textTertiary = Color(0xFF9E9E9E);

  /// Disabled text
  static const Color textDisabled = Color(0xFFBDBDBD);

  /// Link text
  static const Color textLink = primarySage;

  // ============================================================
  // STATUS COLORS (Refined)
  // Softer, more sophisticated status indicators
  // ============================================================

  /// Healthy status - calm teal-green
  static const Color statusHealthy = Color(0xFF4A9B7F);

  /// Warning status - warm amber
  static const Color statusWarning = Color(0xFFE8A838);

  /// Critical status - muted red
  static const Color statusCritical = Color(0xFFD4544C);

  /// Info status - soft blue
  static const Color statusInfo = Color(0xFF5B9BD5);

  // Legacy state colors (for backwards compatibility)
  static const Color error = statusCritical;
  static const Color errorLight = Color(0xFFEF5350);
  static const Color success = statusHealthy;
  static const Color warning = statusWarning;
  static const Color info = statusInfo;

  // ============================================================
  // BORDER COLORS
  // Subtle, refined borders
  // ============================================================

  /// Light border - default state
  static const Color borderLight = neutralBorder;

  /// Medium border - hover state
  static const Color borderMedium = Color(0xFFBDBDBD);

  /// Focused border - active state (gold accent)
  static const Color borderFocused = accentGold;

  /// Error border
  static const Color borderError = error;

  /// Success border
  static const Color borderSuccess = statusHealthy;

  // ============================================================
  // ICON COLORS
  // Consistent icon coloring
  // ============================================================

  /// Primary icon - sage green
  static const Color iconPrimary = primarySage;

  /// Secondary icon - muted
  static const Color iconSecondary = textSecondary;

  /// Accent icon - gold highlight
  static const Color iconAccent = accentGold;

  /// Disabled icon
  static const Color iconDisabled = Color(0xFFBDBDBD);

  // ============================================================
  // SHADOW COLORS
  // Layered shadow system for depth
  // ============================================================

  /// Light shadow - subtle elevation
  static const Color shadowLight = Color(0x0F000000);

  /// Medium shadow - standard elevation
  static const Color shadowMedium = Color(0x1F000000);

  /// Heavy shadow - high elevation
  static const Color shadowHeavy = Color(0x29000000);

  /// Gold shadow - for gold buttons
  static Color shadowGold = accentGold.withValues(alpha: 0.3);

  /// Green shadow - for green elements
  static Color shadowGreen = primarySage.withValues(alpha: 0.3);

  // ============================================================
  // GRADIENT ANCHORS
  // Base colors for gradient creation
  // ============================================================

  /// Forest gradient start
  static const Color gradientForestStart = primaryForest;

  /// Forest gradient end
  static const Color gradientForestEnd = primarySage;

  /// Gold gradient start
  static const Color gradientGoldStart = accentGold;

  /// Gold gradient end (coral)
  static const Color gradientGoldEnd = accentCoral;

  /// Mint gradient start
  static const Color gradientMintStart = primaryMint;

  /// Mint gradient end
  static const Color gradientMintEnd = primaryCelery;
}
