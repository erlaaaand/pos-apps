import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';

/// Builds the app's [ThemeData]. Kept as a single factory so light/dark stay
/// in sync instead of drifting apart in separate ad hoc definitions.
abstract final class AppTheme {
  static ThemeData light() => _build(Brightness.light);

  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: brightness == Brightness.light
          ? AppColors.surfaceLight
          : AppColors.surfaceDark,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.cardRadius),
        color: colorScheme.surfaceContainerLow,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: AppRadius.smRadius),
        filled: true,
        fillColor: colorScheme.surfaceContainerLowest,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: AppRadius.smRadius),
        ),
      ),
    );
  }
}
