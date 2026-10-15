import 'package:flutter/material.dart';

/// Головна колірна палітра та тема застосунку "Домашня комора" (Каталог домашніх інструментів).
/// Повністю відповідає макетам Material Design 3 та дизайну Лабораторної роботи №2 (Seed: #006A6A).
class AppTheme {
  // Brand colors
  static const Color primarySeedColor = Color(0xFF006A6A);
  static const Color primaryTeal = Color(0xFF006A6A);
  static const Color scaffoldBackgroundColor = Color(0xFFF4FBFA);
  static const Color surfaceColor = Colors.white;
  static const Color cardBgColor = Color(0xFFE8F2F0);
  static const Color selectedItemBg = Color(0xFFD6EAE6);
  static const Color imagePlaceholderBg = Color(0xFFCCDEDA);

  // Status colors - Available
  static const Color statusAvailableColor = Color(0xFF1A632B);
  static const Color statusAvailableBg = Color(0xFFCFF4D2);

  // Status colors - Loaned
  static const Color statusLoanedColor = Color(0xFF964700);
  static const Color statusLoanedBg = Color(0xFFFDE6D2);

  // Status colors - Repair
  static const Color statusRepairColor = Color(0xFF9E1B1B);
  static const Color statusRepairBg = Color(0xFFFDDAD8);

  // Condition Good / General badge
  static const Color badgeGoodText = Color(0xFF006A6A);
  static const Color badgeGoodBg = Color(0xFFD6EAE6);

  // Statistics cards
  static const Color statTotalBg = Color(0xFFCCDEDA);
  static const Color statTotalText = Color(0xFF191C1C);

  static const Color statLoanedBg = Color(0xFFFDE6D2);
  static const Color statLoanedText = Color(0xFF964700);

  static const Color statRepairBg = Color(0xFFFDDAD8);
  static const Color statRepairText = Color(0xFF9E1B1B);

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryTeal,
      primary: primaryTeal,
      surface: surfaceColor,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: scaffoldBackgroundColor,
        foregroundColor: Color(0xFF191C1C),
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'Roboto',
          color: Color(0xFF191C1C),
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF707978)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF707978)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryTeal, width: 2),
        ),
        labelStyle: const TextStyle(
          fontFamily: 'Roboto',
          color: Color(0xFF3F4948),
          fontSize: 14,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryTeal,
          foregroundColor: Colors.white,
          minimumSize: const Size(64, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryTeal,
          minimumSize: const Size(64, 48),
          side: const BorderSide(color: primaryTeal, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
