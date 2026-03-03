import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_mode.dart';

class AppTheme {
  static Color primaryColor = const Color(0xFFFF4B6E);
  // Using withValues(alpha: ...) as requested for production-grade Flutter apps
  static Color secondaryColor = const Color(0xFFFF4B6E).withValues(alpha: 0.8);
  static Color accentColor = Colors.purpleAccent;

  static ThemeData getTheme(UIMode mode, bool isDarkMode) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      secondary: secondaryColor,
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
    );

    // Using ThemeData.from as requested
    final baseTheme = ThemeData.from(
      colorScheme: colorScheme,
      useMaterial3: true,
    );
    
    return baseTheme.copyWith(
      primaryColor: primaryColor,
      textTheme: GoogleFonts.outfitTextTheme(baseTheme.textTheme),
      cardTheme: CardThemeData(
        elevation: mode == UIMode.performanceMode ? 0 : 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
    );
  }

  static BoxDecoration gradientDecoration = BoxDecoration(
    gradient: LinearGradient(
      colors: [primaryColor, accentColor],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );
}
