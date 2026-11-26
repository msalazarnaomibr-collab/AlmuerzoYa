
import 'package:flutter/material.dart';

class AppTheme {
  static const Color rosa = Color(0xFFE8A6B7);
  static const Color rosaClaro = Color(0xFFFCE8ED);
  static const Color crema = Color(0xFFFFF9F5);
  static const Color marron = Color(0xFF59464A);
  static const Color blanco = Color(0xFFFFFFFF);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: crema,
      colorScheme: ColorScheme.fromSeed(
        seedColor: rosa,
        primary: rosa,
        surface: blanco,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: crema,
        foregroundColor: marron,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: blanco,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: blanco,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
