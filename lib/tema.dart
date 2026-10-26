import 'package:flutter/material.dart';

class TemaAplicativo {
  // Cores principais da identidade visual.
  static const Color azulPrincipal = Color(0xFF0755B8);
  static const Color azulEscuro = Color(0xFF062B66);
  static const Color azulMarinho = Color(0xFF041426);
  static const Color azulCiano = Color(0xFF35BDF5);

  // Cores para a tela clara.
  static const Color fundoClaro = Color(0xFFF0F7FF);
  static const Color branco = Colors.white;
  static const Color textoPrincipal = Color(0xFF102D60);
  static const Color bordaAzul = Color(0xFF9CCBFF);

  // Cores para a tela de leitura da câmera.
  static const Color fundoCamera = Color(0xFF06111F);
  static const Color superficieCamera = Color(0xFF0B1D32);

  static ThemeData obterTema() {
    return ThemeData(
      useMaterial3: true,

      colorScheme: ColorScheme.fromSeed(
        seedColor: azulPrincipal,
        primary: azulPrincipal,
        secondary: azulCiano,
        surface: branco,
        onSurface: textoPrincipal,
      ),

      scaffoldBackgroundColor: fundoClaro,

      appBarTheme: const AppBarTheme(
        backgroundColor: azulPrincipal,
        foregroundColor: branco,
        centerTitle: false,
        elevation: 0,
      ),

      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: textoPrincipal),
        bodyMedium: TextStyle(color: textoPrincipal),
        titleLarge: TextStyle(
          color: textoPrincipal,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          color: textoPrincipal,
          fontWeight: FontWeight.w600,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: branco,
        labelStyle: const TextStyle(color: azulPrincipal),
        hintStyle: const TextStyle(color: Color(0xFF7186A5)),
        prefixIconColor: azulPrincipal,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: bordaAzul),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: azulPrincipal, width: 2),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: azulPrincipal,
          foregroundColor: branco,
          disabledBackgroundColor: const Color(0xFFD5E5F8),
          disabledForegroundColor: const Color(0xFF667A96),
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: azulPrincipal,
          side: const BorderSide(color: azulPrincipal, width: 1.5),
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
      ),

      cardTheme: CardThemeData(
        color: branco,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFD4E7FF)),
        ),
      ),

      dividerTheme: const DividerThemeData(color: Color(0xFFD4E5F8)),
    );
  }
}
