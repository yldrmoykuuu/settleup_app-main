import 'package:flutter/material.dart';
import 'package:settleup_app/core/theme/app_text_style.dart';
import 'app_colors.dart';

class AppTheme {
  static const double cardRadius = 20;
  static const double buttonRadius = 16;
  static const double chipRadius = 16;

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.lightBackground,
    brightness: Brightness.light,

    colorScheme: const ColorScheme.light(
      surface: AppColors.lightCard,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      onSurface: AppColors.primaryText,
      error: Color(0xFFDC2626),
    ),

    textTheme: TextTheme(
      titleLarge: AppTextStyles.title.copyWith(color: AppColors.primaryText),
      titleMedium: AppTextStyles.subtitle.copyWith(
        color: AppColors.primaryText,
      ),
      bodyMedium: AppTextStyles.body.copyWith(color: AppColors.secondaryText),
      bodySmall: AppTextStyles.body.copyWith(
        fontSize: 12,
        color: AppColors.secondaryText,
      ),
      labelLarge: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightBackground,
      foregroundColor: AppColors.primaryText,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyles.subtitle.copyWith(
        color: AppColors.primaryText,
      ),
      iconTheme: const IconThemeData(color: AppColors.primaryText),
    ),

    cardTheme: CardThemeData(
      color: AppColors.lightCard,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
        side: BorderSide(color: AppColors.borderColor.withValues(alpha: 0.6)),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightBackground,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: TextStyle(
        color: AppColors.secondaryText.withValues(alpha: 0.7),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFDC2626)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFDC2626), width: 1.6),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonRadius),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ),

    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.lightCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
      ),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: AppColors.lightCard,
      selectedColor: AppColors.primary,
      labelStyle: const TextStyle(color: AppColors.primaryText),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(chipRadius),
      ),
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.lightDark,
      contentTextStyle: const TextStyle(color: Colors.white),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.darkBackground,
    brightness: Brightness.dark,

    colorScheme: const ColorScheme.dark(
      surface: AppColors.darkCard,
      primary: AppColors.darkPrimary,
      onPrimary: Colors.white,
      onSurface: AppColors.darkPrimaryText,
      error: Color(0xFFF87171),
    ),

    textTheme: TextTheme(
      titleLarge: AppTextStyles.title.copyWith(
        color: AppColors.darkPrimaryText,
      ),
      titleMedium: AppTextStyles.subtitle.copyWith(
        color: AppColors.darkPrimaryText,
      ),
      bodyMedium: AppTextStyles.body.copyWith(
        color: AppColors.darkSecondaryText,
      ),
      bodySmall: AppTextStyles.body.copyWith(
        fontSize: 12,
        color: AppColors.darkSecondaryText,
      ),
      labelLarge: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      foregroundColor: AppColors.darkPrimaryText,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyles.subtitle.copyWith(
        color: AppColors.darkPrimaryText,
      ),
      iconTheme: const IconThemeData(color: AppColors.darkPrimaryText),
    ),

    cardTheme: CardThemeData(
      color: AppColors.darkCard,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
        side: BorderSide(color: AppColors.darkBorderColor),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkCard,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: TextStyle(
        color: AppColors.darkSecondaryText.withValues(alpha: 0.7),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.darkBorderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.darkBorderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.darkPrimary, width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFF87171)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFF87171), width: 1.6),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonRadius),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ),

    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.darkCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
      ),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: AppColors.darkCard,
      selectedColor: AppColors.darkPrimary,
      labelStyle: const TextStyle(color: AppColors.darkPrimaryText),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(chipRadius),
      ),
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.darkCard,
      contentTextStyle: const TextStyle(color: AppColors.darkPrimaryText),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}
