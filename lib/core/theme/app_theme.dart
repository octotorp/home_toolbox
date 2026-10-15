import 'package:flutter/material.dart';

/// Головна конфігурація теми застосунку "Каталог домашніх інструментів" (Home Toolbox).
/// Відповідає вимогам Material Design 3 та палітрі на базі кольору #006A6A.
class AppTheme {
  static const Color primarySeedColor = Color(0xFF006A6A);
  static const Color scaffoldBackgroundColor = Color(0xFFF4FBFA);
  static const Color surfaceColor = Colors.white;

  // Семантичні кольори для станів інструментів
  static const Color statusAvailableColor = Color(0xFF2E7D32); // Зелений (В наявності)
  static const Color statusAvailableBg = Color(0xFFE8F5E9);
  
  static const Color statusLoanedColor = Color(0xFFE65100); // Помаранчевий (Видано)
  static const Color statusLoanedBg = Color(0xFFFFF3E0);
  
  static const Color statusRepairColor = Color(0xFFC62828); // Червоний (В ремонті)
  static const Color statusRepairBg = Color(0xFFFFEBEE);

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primarySeedColor,
      primary: primarySeedColor,
      surface: surfaceColor,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF191C1C),
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'Roboto',
          color: Color(0xFF191C1C),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE0E3E3), width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFBEC8C7)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFBEC8C7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primarySeedColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: statusRepairColor),
        ),
        labelStyle: const TextStyle(color: Color(0xFF3F4948)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primarySeedColor,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
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
          foregroundColor: primarySeedColor,
          minimumSize: const Size.fromHeight(48),
          side: const BorderSide(color: primarySeedColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
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
