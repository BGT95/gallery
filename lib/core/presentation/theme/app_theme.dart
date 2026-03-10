import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFFCF497E);
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1D1D1D);
  static const Color textSecondary = Color(0xFFB3B3B3);
  static const Color disabled = Color(0xFFEEEEEF);
  static const Color disabledText = Color(0xFFBCBCBC);
  static const Color searchBackground = Color(0xFFEEEEEF);
  static const Color searchPlaceholder = Color(0xFF7A7A7E);
  static const Color tabInactiveBorder = Color(0xFFEEEEEF);
  static const Color divider = Color(0xFFB3B3B3);
  static const Color gradientStart = Color(0xFFE69633);
  static const Color gradientEnd = Color(0xFFCF497E);
  static const Color error = Color(0xFFED3E3E);
  static const Color pressed = Color(0xFF4D4D4D);
  static const Color pressedOutline = Color(0xFFF2F2F2);
}

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    fontFamily: 'Roboto',
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surface,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 22,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto',
      ),
      iconTheme: IconThemeData(color: AppColors.textPrimary),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      color: AppColors.surface,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.textSecondary,
    ),    
  );
}
