import 'package:flutter/material.dart';

abstract final class ShopColors {
  static const green = Color(0xFF005C3C);
  static const orange = Color(0xFFFF790D);
  static const ink = Color(0xFF172B24);
  static const muted = Color(0xFF5C6861);
  static const background = Color(0xFFF5F6F3);
  static const border = Color(0xFFE2E7E0);
  static const mint = Color(0xFFE5EEE5);
  static const yellow = Color(0xFFF9E49A);
}

abstract final class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    fontFamily: 'Roboto',
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(minimumSize: const Size(48, 48)),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: ShopColors.green,
      primary: ShopColors.green,
      secondary: ShopColors.orange,
      surface: Colors.white,
      onSurface: ShopColors.ink,
    ),
    scaffoldBackgroundColor: ShopColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: ShopColors.background,
      foregroundColor: ShopColors.ink,
      elevation: 0,
      centerTitle: true,
      scrolledUnderElevation: 0,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.2,
      ),
      headlineMedium: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.8,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      bodyLarge: TextStyle(fontSize: 16, height: 1.5),
      bodyMedium: TextStyle(fontSize: 14, height: 1.5, color: ShopColors.muted),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: ShopColors.orange,
        foregroundColor: ShopColors.ink,
        minimumSize: const Size(48, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        textStyle: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w800,
          fontSize: 16,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: ShopColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: ShopColors.border),
      ),
      contentPadding: const EdgeInsets.all(16),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.white,
      selectedColor: ShopColors.green,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: ShopColors.mint,
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    ),
  );
}
