import 'package:flutter/material.dart';

/// Semantic color tokens for the app. Screens should reference these instead
/// of raw [Colors] values so the palette stays consistent and themeable.
abstract final class AppColors {
  static const Color primary = Color(0xFF2E7D32);
  static const Color primaryContainer = Color(0xFFC8E6C9);
  static const Color secondary = Color(0xFFEF6C00);

  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFEF6C00);
  static const Color danger = Color(0xFFC62828);
  static const Color info = Color(0xFF1565C0);

  static const Color surfaceLight = Color(0xFFFAFAFA);
  static const Color surfaceDark = Color(0xFF121212);
}
