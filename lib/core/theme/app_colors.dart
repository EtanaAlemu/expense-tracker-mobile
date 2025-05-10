import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Rich Blue
  static const MaterialColor primary =
      MaterialColor(_primaryPrimaryValue, <int, Color>{
    50: Color(0xFFE3F2FD),
    100: Color(0xFFBBDEFB),
    200: Color(0xFF90CAF9),
    300: Color(0xFF64B5F6),
    400: Color(0xFF42A5F5),
    500: Color(_primaryPrimaryValue),
    600: Color(0xFF1E88E5),
    700: Color(0xFF1976D2),
    800: Color(0xFF1565C0),
    900: Color(0xFF0D47A1),
  });
  static const int _primaryPrimaryValue = 0xFF2196F3;

  // Secondary Colors - Warm Coral
  static const MaterialColor secondary =
      MaterialColor(_secondaryPrimaryValue, <int, Color>{
    50: Color(0xFFFFEBEE),
    100: Color(0xFFFFCDD2),
    200: Color(0xFFEF9A9A),
    300: Color(0xFFE57373),
    400: Color(0xFFEF5350),
    500: Color(_secondaryPrimaryValue),
    600: Color(0xFFE53935),
    700: Color(0xFFD32F2F),
    800: Color(0xFFC62828),
    900: Color(0xFFB71C1C),
  });
  static const int _secondaryPrimaryValue = 0xFFF44336;

  // Error Colors - Deep Red
  static const MaterialColor error =
      MaterialColor(_errorPrimaryValue, <int, Color>{
    50: Color(0xFFFBE9E7),
    100: Color(0xFFFFCCBC),
    200: Color(0xFFFFAB91),
    300: Color(0xFFFF8A65),
    400: Color(0xFFFF7043),
    500: Color(_errorPrimaryValue),
    600: Color(0xFFF4511E),
    700: Color(0xFFE64A19),
    800: Color(0xFFD84315),
    900: Color(0xFFBF360C),
  });
  static const int _errorPrimaryValue = 0xFFFF5722;

  // Warning Colors - Warm Yellow
  static const MaterialColor warning =
      MaterialColor(_warningPrimaryValue, <int, Color>{
    50: Color(0xFFFFFDE7),
    100: Color(0xFFFFF9C4),
    200: Color(0xFFFFF59D),
    300: Color(0xFFFFF176),
    400: Color(0xFFFFEE58),
    500: Color(_warningPrimaryValue),
    600: Color(0xFFFDD835),
    700: Color(0xFFFBC02D),
    800: Color(0xFFF9A825),
    900: Color(0xFFF57F17),
  });
  static const int _warningPrimaryValue = 0xFFFFEB3B;

  // Success Colors - Fresh Green
  static const MaterialColor success =
      MaterialColor(_successPrimaryValue, <int, Color>{
    50: Color(0xFFE8F5E9),
    100: Color(0xFFC8E6C9),
    200: Color(0xFFA5D6A7),
    300: Color(0xFF81C784),
    400: Color(0xFF66BB6A),
    500: Color(_successPrimaryValue),
    600: Color(0xFF43A047),
    700: Color(0xFF388E3C),
    800: Color(0xFF2E7D32),
    900: Color(0xFF1B5E20),
  });
  static const int _successPrimaryValue = 0xFF4CAF50;

  // Info Colors - Light Blue
  static const MaterialColor info =
      MaterialColor(_infoPrimaryValue, <int, Color>{
    50: Color(0xFFE0F7FA),
    100: Color(0xFFB2EBF2),
    200: Color(0xFF80DEEA),
    300: Color(0xFF4DD0E1),
    400: Color(0xFF26C6DA),
    500: Color(_infoPrimaryValue),
    600: Color(0xFF00ACC1),
    700: Color(0xFF0097A7),
    800: Color(0xFF00838F),
    900: Color(0xFF006064),
  });
  static const int _infoPrimaryValue = 0xFF00BCD4;

  // Neutral Colors for Light Mode
  static const MaterialColor neutral =
      MaterialColor(_neutralPrimaryValue, <int, Color>{
    50: Color(0xFFFAFAFA),
    100: Color(0xFFF5F5F5),
    200: Color(0xFFEEEEEE),
    300: Color(0xFFE0E0E0),
    400: Color(0xFFBDBDBD),
    500: Color(_neutralPrimaryValue),
    600: Color(0xFF757575),
    700: Color(0xFF616161),
    800: Color(0xFF424242),
    900: Color(0xFF212121),
  });
  static const int _neutralPrimaryValue = 0xFF9E9E9E;

  // Dark Mode Colors
  static const MaterialColor dark =
      MaterialColor(_darkPrimaryValue, <int, Color>{
    50: Color(0xFFE0E0E0),
    100: Color(0xFFBDBDBD),
    200: Color(0xFF9E9E9E),
    300: Color(0xFF757575),
    400: Color(0xFF616161),
    500: Color(_darkPrimaryValue),
    600: Color(0xFF424242),
    700: Color(0xFF303030),
    800: Color(0xFF212121),
    900: Color(0xFF121212),
  });
  static const int _darkPrimaryValue = 0xFF424242;

  // Surface Colors
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF121212);
  static const Color surfaceVariantLight = Color(0xFFF5F5F5);
  static const Color surfaceVariantDark = Color(0xFF1E1E1E);

  // Text Colors
  static const Color textPrimaryLight = Color(0xFF000000);
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFBDBDBD);

  // Background Colors
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF121212);

  // Get color scheme based on brightness
  static ColorScheme getColorScheme(Brightness brightness) {
    return brightness == Brightness.light
        ? const ColorScheme.light(
            primary: Color(_primaryPrimaryValue),
            secondary: Color(_secondaryPrimaryValue),
            error: Color(_errorPrimaryValue),
            background: backgroundLight,
            surface: surfaceLight,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onError: Colors.white,
            onBackground: textPrimaryLight,
            onSurface: textPrimaryLight,
          )
        : const ColorScheme.dark(
            primary: Color(_primaryPrimaryValue),
            secondary: Color(_secondaryPrimaryValue),
            error: Color(_errorPrimaryValue),
            background: backgroundDark,
            surface: surfaceDark,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onError: Colors.white,
            onBackground: textPrimaryDark,
            onSurface: textPrimaryDark,
          );
  }

  // Helper methods for getting colors based on theme
  static Color getSurfaceColor(Brightness brightness) =>
      brightness == Brightness.light ? surfaceLight : surfaceDark;

  static Color getSurfaceVariantColor(Brightness brightness) =>
      brightness == Brightness.light ? surfaceVariantLight : surfaceVariantDark;

  static Color getTextPrimaryColor(Brightness brightness) =>
      brightness == Brightness.light ? textPrimaryLight : textPrimaryDark;

  static Color getTextSecondaryColor(Brightness brightness) =>
      brightness == Brightness.light ? textSecondaryLight : textSecondaryDark;

  static Color getBackgroundColor(Brightness brightness) =>
      brightness == Brightness.light ? backgroundLight : backgroundDark;
}
