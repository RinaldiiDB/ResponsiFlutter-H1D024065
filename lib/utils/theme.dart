import 'package:flutter/material.dart';

class AppTheme {
  static const String fontPoppins = 'Poppins';

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF2563EB),
      brightness: Brightness.light,
      surface: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      fontFamily: fontPoppins,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: fontPoppins,
          fontSize: 68,
          fontWeight: FontWeight.w700,
          letterSpacing: -1.5,
          color: Color(0xFF0F172A),
        ),
        headlineLarge: TextStyle(
          fontFamily: fontPoppins,
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: Color(0xFF0F172A),
        ),
        headlineMedium: TextStyle(
          fontFamily: fontPoppins,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Color(0xFF0F172A),
        ),
        titleLarge: TextStyle(
          fontFamily: fontPoppins,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFF0F172A),
        ),
        titleMedium: TextStyle(
          fontFamily: fontPoppins,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Color(0xFF334155),
        ),
        bodyLarge: TextStyle(
          fontFamily: fontPoppins,
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Color(0xFF334155),
        ),
        bodyMedium: TextStyle(
          fontFamily: fontPoppins,
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: Color(0xFF64748B),
        ),
        labelLarge: TextStyle(
          fontFamily: fontPoppins,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFF0F172A),
        titleTextStyle: TextStyle(
          fontFamily: fontPoppins,
          color: Color(0xFF0F172A),
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: Color(0xFFF1F5F9), width: 1.2),
        ),
        color: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle: const TextStyle(
          fontFamily: fontPoppins,
          color: Color(0xFF94A3B8),
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xFF2563EB),
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontFamily: fontPoppins,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFF1F5F9),
        labelStyle: const TextStyle(
          fontFamily: fontPoppins,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFF334155),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: BorderSide.none,
      ),
    );
  }

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF3B82F6),
      brightness: Brightness.dark,
      surface: const Color(0xFF1E293B),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      fontFamily: fontPoppins,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: fontPoppins,
          fontSize: 68,
          fontWeight: FontWeight.w700,
          letterSpacing: -1.5,
          color: Colors.white,
        ),
        headlineLarge: TextStyle(
          fontFamily: fontPoppins,
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        headlineMedium: TextStyle(
          fontFamily: fontPoppins,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        titleLarge: TextStyle(
          fontFamily: fontPoppins,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        titleMedium: TextStyle(
          fontFamily: fontPoppins,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Color(0xFFCBD5E1),
        ),
        bodyLarge: TextStyle(
          fontFamily: fontPoppins,
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Color(0xFFE2E8F0),
        ),
        bodyMedium: TextStyle(
          fontFamily: fontPoppins,
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: Color(0xFF94A3B8),
        ),
        labelLarge: TextStyle(
          fontFamily: fontPoppins,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontFamily: fontPoppins,
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: Color(0xFF334155), width: 1.2),
        ),
        color: const Color(0xFF1E293B),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E293B),
        hintStyle: const TextStyle(
          fontFamily: fontPoppins,
          color: Color(0xFF64748B),
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 1.8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xFF3B82F6),
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontFamily: fontPoppins,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF334155),
        labelStyle: const TextStyle(
          fontFamily: fontPoppins,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFFE2E8F0),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: BorderSide.none,
      ),
    );
  }
}
