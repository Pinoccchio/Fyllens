import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/theme/app_text_styles.dart';
import 'package:fyllens/core/constants/app_spacing.dart';

/// App theme configuration - "Organic Luxury" Design System
///
/// Provides light theme data for the entire application with
/// premium botanical aesthetic and refined component styling.
class AppTheme {
  // Prevent instantiation
  AppTheme._();

  /// Light theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primarySage,
      scaffoldBackgroundColor: AppColors.backgroundLight,

      // ============================================================
      // COLOR SCHEME
      // ============================================================
      colorScheme: ColorScheme.light(
        primary: AppColors.primarySage,
        onPrimary: AppColors.textOnPrimary,
        primaryContainer: AppColors.primaryCelery,
        onPrimaryContainer: AppColors.primaryForest,
        secondary: AppColors.accentGold,
        onSecondary: AppColors.textOnGold,
        secondaryContainer: AppColors.accentCream,
        onSecondaryContainer: AppColors.accentTerracotta,
        tertiary: AppColors.primaryMint,
        onTertiary: AppColors.primaryForest,
        error: AppColors.error,
        onError: Colors.white,
        surface: AppColors.surfaceLight,
        onSurface: AppColors.textPrimary,
        surfaceContainerHighest: AppColors.surfaceGray,
        outline: AppColors.borderLight,
        outlineVariant: AppColors.neutralBorder,
      ),

      // ============================================================
      // APP BAR THEME
      // ============================================================
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backgroundLight,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.heading2,
        iconTheme: const IconThemeData(
          color: AppColors.textPrimary,
          size: AppSpacing.iconMd,
        ),
      ),

      // ============================================================
      // TEXT THEME
      // ============================================================
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        displaySmall: AppTextStyles.displaySmall,
        headlineLarge: AppTextStyles.heading1,
        headlineMedium: AppTextStyles.heading2,
        headlineSmall: AppTextStyles.heading3,
        titleLarge: AppTextStyles.heading2,
        titleMedium: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
        titleSmall: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.buttonLarge,
        labelMedium: AppTextStyles.buttonMedium,
        labelSmall: AppTextStyles.buttonSmall,
      ),

      // ============================================================
      // ELEVATED BUTTON THEME (Primary Actions)
      // ============================================================
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentGold,
          foregroundColor: AppColors.textOnGold,
          disabledBackgroundColor: AppColors.accentGold.withValues(alpha: 0.5),
          disabledForegroundColor: AppColors.textOnGold.withValues(alpha: 0.7),
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.lg,
          ),
          minimumSize: const Size(0, AppSpacing.buttonHeight),
          elevation: 0,
          shadowColor: AppColors.shadowGold,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          ),
          textStyle: AppTextStyles.buttonLarge.copyWith(
            color: AppColors.textOnGold,
          ),
        ),
      ),

      // ============================================================
      // FILLED BUTTON THEME
      // ============================================================
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primarySage,
          foregroundColor: AppColors.textOnPrimary,
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.lg,
          ),
          minimumSize: const Size(0, AppSpacing.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          ),
        ),
      ),

      // ============================================================
      // OUTLINED BUTTON THEME
      // ============================================================
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primarySage,
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.lg,
          ),
          minimumSize: const Size(0, AppSpacing.buttonHeight),
          side: const BorderSide(
            color: AppColors.borderLight,
            width: AppSpacing.borderThin,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          ),
        ),
      ),

      // ============================================================
      // TEXT BUTTON THEME
      // ============================================================
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primarySage,
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.sm,
            horizontal: AppSpacing.md,
          ),
          minimumSize: const Size(0, AppSpacing.touchTarget),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
        ),
      ),

      // ============================================================
      // INPUT DECORATION THEME
      // ============================================================
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceCream,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),

        // Border styling
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(
            color: Colors.transparent,
            width: AppSpacing.borderThin,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(
            color: AppColors.accentGold,
            width: AppSpacing.borderFocus,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: AppSpacing.borderThin,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: AppSpacing.borderFocus,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide.none,
        ),

        // Text styling
        hintStyle: AppTextStyles.inputHint,
        labelStyle: AppTextStyles.inputLabel,
        errorStyle: AppTextStyles.inputError,
        floatingLabelStyle: GoogleFonts.dmSerifDisplay(
          color: AppColors.primarySage,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        prefixIconColor: AppColors.iconSecondary,
        suffixIconColor: AppColors.iconSecondary,
      ),

      // ============================================================
      // CARD THEME
      // ============================================================
      cardTheme: CardThemeData(
        color: AppColors.surfaceWarm,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        ),
        clipBehavior: Clip.antiAlias,
      ),

      // ============================================================
      // CHIP THEME
      // ============================================================
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceGray,
        selectedColor: AppColors.accentGold.withValues(alpha: 0.2),
        labelStyle: AppTextStyles.chip,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        ),
        side: BorderSide.none,
      ),

      // ============================================================
      // DIALOG THEME
      // ============================================================
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceLight,
        elevation: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        ),
        titleTextStyle: AppTextStyles.heading2,
        contentTextStyle: AppTextStyles.bodyMedium,
      ),

      // ============================================================
      // BOTTOM SHEET THEME
      // ============================================================
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surfaceLight,
        elevation: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusCard),
          ),
        ),
        showDragHandle: true,
        dragHandleColor: AppColors.borderLight,
      ),

      // ============================================================
      // BOTTOM NAVIGATION BAR THEME
      // ============================================================
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceLight,
        selectedItemColor: AppColors.primarySage,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: AppTextStyles.caption.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTextStyles.caption,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // ============================================================
      // NAVIGATION BAR THEME (Material 3)
      // ============================================================
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surfaceLight,
        indicatorColor: AppColors.accentGold.withValues(alpha: 0.2),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTextStyles.caption.copyWith(
              color: AppColors.primarySage,
              fontWeight: FontWeight.w600,
            );
          }
          return AppTextStyles.caption;
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(
              color: AppColors.primarySage,
              size: AppSpacing.iconMd,
            );
          }
          return const IconThemeData(
            color: AppColors.textSecondary,
            size: AppSpacing.iconMd,
          );
        }),
        elevation: 0,
        height: 80,
      ),

      // ============================================================
      // TAB BAR THEME
      // ============================================================
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.primarySage,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: AppTextStyles.buttonMedium,
        unselectedLabelStyle: AppTextStyles.bodyMedium,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(
            color: AppColors.accentGold,
            width: 3,
          ),
        ),
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: Colors.transparent,
      ),

      // ============================================================
      // FLOATING ACTION BUTTON THEME
      // ============================================================
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.accentGold,
        foregroundColor: AppColors.textOnGold,
        elevation: 6,
        focusElevation: 8,
        hoverElevation: 8,
        shape: CircleBorder(),
      ),

      // ============================================================
      // SNACK BAR THEME
      // ============================================================
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.neutralCharcoal,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 6,
      ),

      // ============================================================
      // PROGRESS INDICATOR THEME
      // ============================================================
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primarySage,
        linearTrackColor: AppColors.surfaceGray,
        circularTrackColor: AppColors.surfaceGray,
      ),

      // ============================================================
      // SLIDER THEME
      // ============================================================
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primarySage,
        inactiveTrackColor: AppColors.surfaceGray,
        thumbColor: AppColors.accentGold,
        overlayColor: AppColors.accentGold.withValues(alpha: 0.2),
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
      ),

      // ============================================================
      // SWITCH THEME
      // ============================================================
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.accentGold;
          }
          return AppColors.surfaceLight;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.accentGold.withValues(alpha: 0.5);
          }
          return AppColors.borderLight;
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),

      // ============================================================
      // CHECKBOX THEME
      // ============================================================
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.accentGold;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.textOnGold),
        side: const BorderSide(color: AppColors.borderMedium, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),

      // ============================================================
      // RADIO THEME
      // ============================================================
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.accentGold;
          }
          return AppColors.borderMedium;
        }),
      ),

      // ============================================================
      // DIVIDER THEME
      // ============================================================
      dividerTheme: const DividerThemeData(
        color: AppColors.borderLight,
        thickness: 1,
        space: AppSpacing.md,
      ),

      // ============================================================
      // LIST TILE THEME
      // ============================================================
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        minVerticalPadding: AppSpacing.sm,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        titleTextStyle: AppTextStyles.bodyLarge.copyWith(
          fontWeight: FontWeight.w500,
        ),
        subtitleTextStyle: AppTextStyles.bodySmall,
        iconColor: AppColors.iconSecondary,
      ),

      // ============================================================
      // ICON THEME
      // ============================================================
      iconTheme: const IconThemeData(
        color: AppColors.iconPrimary,
        size: AppSpacing.iconMd,
      ),

      // ============================================================
      // PAGE TRANSITIONS
      // ============================================================
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
