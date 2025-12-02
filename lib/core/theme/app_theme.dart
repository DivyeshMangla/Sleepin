import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const _primaryColor = Color(0xFF6C63FF); // Modern Purple
  static const _secondaryColor = Color(0xFF00E5FF); // Cyan Accent
  static const _errorColor = Color(0xFFFF5252);

  // Dark Theme Colors
  static const _darkBackground = Color(0xFF121212);
  static const _darkSurface = Color(0xFF1E1E1E);
  static const _darkText = Colors.white;

  // Light Theme Colors
  static const _lightBackground = Color(0xFFF5F7FA);
  static const _lightSurface = Colors.white;
  static const _lightText = Color(0xFF2D3436);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: _primaryColor,
        secondary: _secondaryColor,
        surface: _lightSurface,
        // background: _lightBackground, // Deprecated
        error: _errorColor,
        // onBackground: _lightText, // Deprecated
        onSurface: _lightText,
      ),
      scaffoldBackgroundColor: _lightBackground,
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.light().textTheme).apply(
        bodyColor: _lightText,
        displayColor: _lightText,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _lightBackground,
        elevation: 0,
        iconTheme: IconThemeData(color: _lightText),
        titleTextStyle: TextStyle(
          color: _lightText,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: _lightSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: _primaryColor,
        secondary: _secondaryColor,
        surface: _darkSurface,
        // background: _darkBackground, // Deprecated
        error: _errorColor,
        // onBackground: _darkText, // Deprecated
        onSurface: _darkText,
      ),
      scaffoldBackgroundColor: _darkBackground,
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: _darkText,
        displayColor: _darkText,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _darkBackground,
        elevation: 0,
        iconTheme: IconThemeData(color: _darkText),
        titleTextStyle: TextStyle(
          color: _darkText,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: _darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
