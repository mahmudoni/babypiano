import 'package:flutter/material.dart';

import 'app_palette.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppPalette.teal,
      onPrimary: Colors.white,
      secondary: AppPalette.coral,
      onSecondary: Colors.white,
      error: Color(0xFFBA1A1A),
      onError: Colors.white,
      surface: AppPalette.card,
      onSurface: AppPalette.ink,
      onSurfaceVariant: Color(0xFF526070),
      outline: Color(0xFFD4D9E0),
      shadow: AppPalette.shadow,
      inverseSurface: AppPalette.ink,
      onInverseSurface: AppPalette.shell,
      inversePrimary: AppPalette.mint,
      tertiary: AppPalette.honey,
      onTertiary: AppPalette.ink,
      surfaceContainerHighest: Color(0xFFF1F2F5),
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppPalette.shell,
      textTheme: Typography.blackMountainView.apply(
        bodyColor: AppPalette.ink,
        displayColor: AppPalette.ink,
      ),
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppPalette.ink,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: AppPalette.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: Colors.white.withValues(alpha: 0.86),
        selectedColor: AppPalette.mist,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppPalette.teal,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppPalette.ink,
          minimumSize: const Size.fromHeight(56),
          side: const BorderSide(color: Color(0xFFCFD9E3)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      sliderTheme: base.sliderTheme.copyWith(
        activeTrackColor: AppPalette.teal,
        thumbColor: AppPalette.coral,
        inactiveTrackColor: AppPalette.mist,
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
