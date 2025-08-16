// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_text_theme.dart';
import 'button_styles.dart';

/// Comprehensive Design System Theme
/// Based on Cloud Ironing App Design Guidelines
class AppTheme {
  // ===============================
  // MAIN THEMES
  // ===============================

  /// Light Theme - Primary theme for the application
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,

      // Color Scheme based on Design System
      colorScheme: const ColorScheme.light(
        brightness: Brightness.light,
        primary: AppColors.primary, // Deep Navy Blue
        onPrimary: AppColors.textOnPrimary, // White
        secondary: AppColors.secondary, // Light Blue
        onSecondary: AppColors.textOnSecondary, // Deep Navy Blue
        tertiary: AppColors.accent, // Bright Azure
        onTertiary: AppColors.textOnAccent, // White
        error: AppColors.error, // Soft Coral
        onError: AppColors.textOnError, // White
        surface: AppColors.surface, // White
        onSurface: AppColors.textSecondary, // Dark Gray
        surfaceVariant: AppColors.surfaceVariant, // Light Gray
        onSurfaceVariant: AppColors.textTertiary, // Warm Gray
        background: AppColors.background, // White
        onBackground: AppColors.textSecondary, // Dark Gray
        outline: AppColors.border, // Medium Gray
        outlineVariant: AppColors.borderLight, // Light Gray
        shadow: AppColors.darkGray,
        scrim: AppColors.scrim,
        inverseSurface: AppColors.darkGray,
        onInverseSurface: AppColors.white,
        inversePrimary: AppColors.secondary,
      ),

      // Typography using SF Pro Display
      fontFamily: 'SF Pro Display',
      textTheme: TextTheme(
        // Display styles
        displayLarge: AppTextTheme.displayLarge,
        displayMedium: AppTextTheme.displayMedium,
        displaySmall: AppTextTheme.displaySmall,

        // Headline styles (H1, H2, H3)
        headlineLarge: AppTextTheme.heading1, // 22px Bold
        headlineMedium: AppTextTheme.heading2, // 20px Bold
        headlineSmall: AppTextTheme.heading3, // 18px SemiBold

        // Title styles
        titleLarge: AppTextTheme.titleLarge,
        titleMedium: AppTextTheme.titleMedium,
        titleSmall: AppTextTheme.titleSmall,

        // Body styles (16px, 14px)
        bodyLarge: AppTextTheme.bodyText, // 16px Regular
        bodyMedium: AppTextTheme.bodyTextSmall, // 14px Regular
        bodySmall: AppTextTheme.captionSmall, // 12px Regular

        // Label styles (14px captions, buttons)
        labelLarge: AppTextTheme.label, // 14px Medium
        labelMedium: AppTextTheme.caption, // 14px Regular
        labelSmall: AppTextTheme.captionSmall, // 12px Regular
      ),

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        shadowColor: AppColors.border,
        centerTitle: true,
        titleTextStyle: AppTextTheme.heading3,
        iconTheme: const IconThemeData(
          color: AppColors.primary,
          size: 24,
        ),
        actionsIconTheme: const IconThemeData(
          color: AppColors.primary,
          size: 24,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: AppButtonStyles.primary,
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: AppButtonStyles.outlinePrimary,
      ),

      textButtonTheme: TextButtonThemeData(
        style: AppButtonStyles.textPrimary,
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: AppButtonStyles.accent,
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariant,
        labelStyle: AppTextTheme.label,
        hintStyle: AppTextTheme.caption,
        errorStyle: AppTextTheme.captionSmall.copyWith(
          color: AppColors.error,
        ),

        // Border styles
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.accent,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.disabled,
            width: 1,
          ),
        ),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.surface,
        shadowColor: AppColors.border,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.warmGray,
        selectedLabelStyle: TextStyle(
          fontFamily: 'SF Pro Display',
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'SF Pro Display',
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Tab Bar Theme
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.warmGray,
        labelStyle: AppTextTheme.label,
        unselectedLabelStyle: AppTextTheme.caption,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(
            color: AppColors.accent,
            width: 2,
          ),
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.textOnAccent,
        elevation: 6,
        focusElevation: 8,
        hoverElevation: 8,
        shape: CircleBorder(),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceVariant,
        selectedColor: AppColors.accent,
        secondarySelectedColor: AppColors.secondary,
        labelStyle: AppTextTheme.caption,
        secondaryLabelStyle: AppTextTheme.caption.copyWith(
          color: AppColors.textOnAccent,
        ),
        brightness: Brightness.light,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shadowColor: AppColors.border,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titleTextStyle: AppTextTheme.heading3,
        contentTextStyle: AppTextTheme.bodyText,
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        elevation: 8,
        modalElevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
      ),

      // Snack Bar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkGray,
        contentTextStyle: AppTextTheme.bodyTextSmall.copyWith(
          color: AppColors.white,
        ),
        actionTextColor: AppColors.accent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: AppColors.primary,
        size: 24,
      ),

      // Primary Icon Theme
      primaryIconTheme: const IconThemeData(
        color: AppColors.textOnPrimary,
        size: 24,
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.accent;
          }
          return AppColors.mediumGray;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.accent.withOpacity(0.3);
          }
          return AppColors.lightGray;
        }),
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        checkColor: WidgetStateProperty.all(AppColors.textOnAccent),
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.accent;
          }
          return Colors.transparent;
        }),
        side: const BorderSide(
          color: AppColors.border,
          width: 2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),

      // Radio Theme
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.accent;
          }
          return AppColors.border;
        }),
      ),

      // Slider Theme
      sliderTheme: const SliderThemeData(
        activeTrackColor: AppColors.accent,
        inactiveTrackColor: AppColors.lightGray,
        thumbColor: AppColors.accent,
        overlayColor: Color(0x1F00A8E8), // Accent with low opacity
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.accent,
        linearTrackColor: AppColors.lightGray,
        circularTrackColor: AppColors.lightGray,
      ),
    );
  }

  // ===============================
  // DARK THEME (Future Enhancement)
  // ===============================

  /// Dark Theme - Comprehensive dark mode implementation
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color Scheme for Dark Mode
      colorScheme: const ColorScheme.dark(
        brightness: Brightness.dark,
        primary: AppColors.accent, // Bright Azure for primary actions
        onPrimary: AppColors.textOnAccent, // White text on primary
        secondary: AppColors.secondaryLight, // Light blue for secondary
        onSecondary: AppColors.primary, // Navy text on secondary
        tertiary: AppColors.accentLight, // Light accent
        onTertiary: AppColors.textOnAccent, // White text on tertiary
        error: AppColors.errorLight, // Lighter error color for dark theme
        onError: AppColors.textOnError, // White text on error
        surface: Color(0xFF1E1E1E), // Dark surface
        onSurface: AppColors.white, // White text on surface
        surfaceVariant: Color(0xFF2A2A2A), // Darker surface variant
        onSurfaceVariant: AppColors.lightGray, // Light gray text
        background: Color(0xFF121212), // Very dark background
        onBackground: AppColors.white, // White text on background
        outline: AppColors.warmGray, // Warm gray for outlines
        outlineVariant: Color(0xFF3A3A3A), // Darker outline variant
        shadow: Colors.black, // Black shadows
        scrim: Color(0x99000000), // Darker scrim
        inverseSurface: AppColors.white, // Light surface for inverse
        onInverseSurface: AppColors.primary, // Dark text on inverse
        inversePrimary: AppColors.primary, // Navy for inverse primary
      ),

      // Typography for Dark Mode
      fontFamily: 'SF Pro Display',
      textTheme: TextTheme(
        // Display styles
        displayLarge: AppTextTheme.displayLarge.copyWith(color: AppColors.white),
        displayMedium: AppTextTheme.displayMedium.copyWith(color: AppColors.white),
        displaySmall: AppTextTheme.displaySmall.copyWith(color: AppColors.white),

        // Headline styles
        headlineLarge: AppTextTheme.heading1.copyWith(color: AppColors.white),
        headlineMedium: AppTextTheme.heading2.copyWith(color: AppColors.white),
        headlineSmall: AppTextTheme.heading3.copyWith(color: AppColors.white),

        // Title styles
        titleLarge: AppTextTheme.titleLarge.copyWith(color: AppColors.white),
        titleMedium: AppTextTheme.titleMedium.copyWith(color: AppColors.lightGray),
        titleSmall: AppTextTheme.titleSmall.copyWith(color: AppColors.lightGray),

        // Body styles
        bodyLarge: AppTextTheme.bodyText.copyWith(color: AppColors.white),
        bodyMedium: AppTextTheme.bodyTextSmall.copyWith(color: AppColors.lightGray),
        bodySmall: AppTextTheme.captionSmall.copyWith(color: AppColors.warmGray),

        // Label styles
        labelLarge: AppTextTheme.label.copyWith(color: AppColors.white),
        labelMedium: AppTextTheme.caption.copyWith(color: AppColors.lightGray),
        labelSmall: AppTextTheme.captionSmall.copyWith(color: AppColors.warmGray),
      ),

      // App Bar Theme for Dark Mode
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: AppColors.white,
        elevation: 0,
        shadowColor: Colors.black,
        centerTitle: true,
        titleTextStyle: AppTextTheme.heading3.copyWith(color: AppColors.white),
        iconTheme: const IconThemeData(
          color: AppColors.accent,
          size: 24,
        ),
        actionsIconTheme: const IconThemeData(
          color: AppColors.accent,
          size: 24,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),

      // Button Themes for Dark Mode
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: AppButtonStyles.primary.copyWith(
          backgroundColor: WidgetStateProperty.all(AppColors.accent),
          foregroundColor: WidgetStateProperty.all(AppColors.textOnAccent),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: AppButtonStyles.outlinePrimary.copyWith(
          foregroundColor: WidgetStateProperty.all(AppColors.accent),
          side: WidgetStateProperty.all(
            const BorderSide(color: AppColors.accent, width: 1.5),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: AppButtonStyles.textPrimary.copyWith(
          foregroundColor: WidgetStateProperty.all(AppColors.accent),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: AppButtonStyles.accent,
      ),

      // Input Decoration Theme for Dark Mode
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFF2A2A2A),
        labelStyle: AppTextTheme.label.copyWith(color: AppColors.lightGray),
        hintStyle: AppTextTheme.caption.copyWith(color: AppColors.warmGray),
        errorStyle: AppTextTheme.captionSmall.copyWith(
          color: AppColors.errorLight,
        ),

        // Border styles for dark mode
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF3A3A3A),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF3A3A3A),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.accent,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.errorLight,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.errorLight,
            width: 2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF2A2A2A),
            width: 1,
          ),
        ),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),

      // Card Theme for Dark Mode
      cardTheme: CardThemeData(
        color: Color(0xFF1E1E1E),
        shadowColor: Colors.black,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
      ),

      // Bottom Navigation Bar Theme for Dark Mode
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1E1E1E),
        selectedItemColor: AppColors.accent,
        unselectedItemColor: AppColors.warmGray,
        selectedLabelStyle: TextStyle(
          fontFamily: 'SF Pro Display',
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'SF Pro Display',
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Additional dark theme components
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.accent,
        unselectedLabelColor: AppColors.warmGray,
        labelStyle: AppTextTheme.label.copyWith(color: AppColors.accent),
        unselectedLabelStyle: AppTextTheme.caption.copyWith(color: AppColors.warmGray),
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(
            color: AppColors.accent,
            width: 2,
          ),
        ),
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.textOnAccent,
        elevation: 6,
        focusElevation: 8,
        hoverElevation: 8,
        shape: CircleBorder(),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: Color(0xFF2A2A2A),
        selectedColor: AppColors.accent,
        secondarySelectedColor: AppColors.secondaryLight,
        labelStyle: AppTextTheme.caption.copyWith(color: AppColors.lightGray),
        secondaryLabelStyle: AppTextTheme.caption.copyWith(
          color: AppColors.textOnAccent,
        ),
        brightness: Brightness.dark,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: Color(0xFF1E1E1E),
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titleTextStyle: AppTextTheme.heading3.copyWith(color: AppColors.white),
        contentTextStyle: AppTextTheme.bodyText.copyWith(color: AppColors.lightGray),
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Color(0xFF1E1E1E),
        elevation: 8,
        modalElevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: Color(0xFF2A2A2A),
        contentTextStyle: AppTextTheme.bodyTextSmall.copyWith(
          color: AppColors.white,
        ),
        actionTextColor: AppColors.accent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      dividerTheme: const DividerThemeData(
        color: Color(0xFF3A3A3A),
        thickness: 1,
        space: 1,
      ),

      iconTheme: const IconThemeData(
        color: AppColors.accent,
        size: 24,
      ),

      primaryIconTheme: const IconThemeData(
        color: AppColors.textOnAccent,
        size: 24,
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.accent;
          }
          return AppColors.warmGray;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.accent.withOpacity(0.3);
          }
          return Color(0xFF3A3A3A);
        }),
      ),

      checkboxTheme: CheckboxThemeData(
        checkColor: WidgetStateProperty.all(AppColors.textOnAccent),
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.accent;
          }
          return Colors.transparent;
        }),
        side: const BorderSide(
          color: Color(0xFF3A3A3A),
          width: 2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),

      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.accent;
          }
          return Color(0xFF3A3A3A);
        }),
      ),

      sliderTheme: const SliderThemeData(
        activeTrackColor: AppColors.accent,
        inactiveTrackColor: Color(0xFF3A3A3A),
        thumbColor: AppColors.accent,
        overlayColor: Color(0x1F00A8E8),
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.accent,
        linearTrackColor: Color(0xFF3A3A3A),
        circularTrackColor: Color(0xFF3A3A3A),
      ),
    );
  }

  // ===============================
  // UTILITY METHODS
  // ===============================

  /// Get theme based on brightness
  static ThemeData getTheme(Brightness brightness) {
    return brightness == Brightness.dark ? darkTheme : lightTheme;
  }

  /// Check if current theme is dark
  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  /// Get appropriate text color for current theme
  static Color getTextColor(BuildContext context) {
    return isDark(context) ? AppColors.white : AppColors.textPrimary;
  }
}
