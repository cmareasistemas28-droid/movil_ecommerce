import 'package:flutter/material.dart';

abstract final class ShopColors {
  static const green = Color(0xFF005C3C);
  static const accent = ReferenceColors.accent;
  static const ink = Color(0xFF172B24);
  static const muted = Color(0xFF5C6861);
  static const background = Color(0xFFF5F6F3);
  static const border = Color(0xFFE2E7E0);
  static const mint = Color(0xFFE5EEE5);
  static const yellow = Color(0xFFF9E49A);
}

abstract final class AppTheme {
  static ThemeData reference({bool dark = false}) {
    final scheme = ColorScheme.fromSeed(
      seedColor: ReferenceColors.coral,
      brightness: dark ? Brightness.dark : Brightness.light,
      primary: dark ? ReferenceColors.accentLight : ReferenceColors.accent,
      onPrimary: dark ? ReferenceColors.ink : Colors.white,
      primaryContainer: dark
          ? const Color(0xFF3E2529)
          : ReferenceColors.accentTint,
      onPrimaryContainer: dark
          ? const Color(0xFFFFDADD)
          : const Color(0xFF7A2630),
      secondary: dark ? ReferenceColors.accentLight : ReferenceColors.accent,
      onSecondary: dark ? ReferenceColors.ink : Colors.white,
      secondaryContainer: dark
          ? const Color(0xFF3E2529)
          : ReferenceColors.accentTint,
      onSecondaryContainer: dark
          ? const Color(0xFFFFDADD)
          : const Color(0xFF7A2630),
      surface: dark ? const Color(0xFF191919) : Colors.white,
      surfaceDim: dark ? const Color(0xFF191919) : const Color(0xFFF2F2F2),
      surfaceBright: dark ? const Color(0xFF383838) : Colors.white,
      surfaceContainerLowest: dark ? const Color(0xFF121212) : Colors.white,
      surfaceContainerLow: dark
          ? const Color(0xFF222222)
          : const Color(0xFFF7F7F7),
      surfaceContainer: dark
          ? const Color(0xFF292929)
          : const Color(0xFFF2F2F2),
      surfaceContainerHigh: dark
          ? const Color(0xFF303030)
          : const Color(0xFFEEEEEE),
      surfaceContainerHighest: dark
          ? const Color(0xFF383838)
          : const Color(0xFFE7E7E7),
      surfaceTint: Colors.transparent,
      outline: dark ? const Color(0xFF929292) : const Color(0xFF888888),
      outlineVariant: dark ? const Color(0xFF444444) : const Color(0xFFE0E0E0),
      onSurface: dark ? const Color(0xFFF5F5F5) : ReferenceColors.ink,
      onSurfaceVariant: dark ? const Color(0xFFBDBDBD) : ReferenceColors.muted,
    );
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Roboto',
      colorScheme: scheme,
      scaffoldBackgroundColor: dark
          ? const Color(0xFF151517)
          : const Color(0xFFFCFBFC),
      appBarTheme: AppBarTheme(
        backgroundColor: dark
            ? const Color(0xFF151517)
            : const Color(0xFFFCFBFC),
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'Roboto',
          color: scheme.onSurface,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
        ),
        titleLarge: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
        ),
        bodyLarge: TextStyle(
          fontSize: 14,
          height: 1.4,
          color: scheme.onSurface,
        ),
        bodyMedium: TextStyle(
          fontSize: 13,
          height: 1.4,
          color: scheme.onSurface,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          height: 1.4,
          color: scheme.onSurfaceVariant,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: dark ? const Color(0xFF373737) : const Color(0xFFE0E0E0),
        thickness: .6,
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(minimumSize: const Size(44, 44)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          minimumSize: const Size(48, 44),
          textStyle: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          shape: const StadiumBorder(),
        ),
      ),
    );
  }

  static ThemeData get light => reference();
}

abstract final class ReferenceColors {
  static const coral = Color(0xFFFF765F);
  static const accent = Color(0xFFFF593C);
  static const accentLight = Color(0xFFFFA38F);
  static const accentTint = Color(0xFFFFF2EF);
  static const ink = Color(0xFF222421);
  static const muted = Color(0xFF74787C);
  static const tile = Color(0xFFF2F2F2);
  static const restaurant = accentTint;
  static const taxi = Color(0xFFDFEFFF);
  static const avatar = Color(0xFF6F80D8);
}
