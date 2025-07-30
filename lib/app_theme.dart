// lib/app_theme.dart

import 'package:flutter/material.dart';

class AppTheme {
  // --- NOSSA PALETA DE CORES ---
  static const Color primaryColor = Color(0xFFF57C00); // Laranja vibrante principal
  static const Color accentColor = Color(0xFFFF9800); // Laranja mais claro para acentos
  static const Color backgroundColor = Color(0xFFF5F5F5); // Um cinza muito claro para o fundo
  static const Color textColor = Color(0xFF333333); // Cor de texto principal
  static const Color cardColor = Colors.white;

  // --- NOSSO TEMA GLOBAL ---
  static ThemeData get theme {
    return ThemeData(
      // Esquema de cores principal
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: accentColor,
        background: backgroundColor,
      ),

      // Fundo padrão de todos os Scaffolds
      scaffoldBackgroundColor: backgroundColor,

      // Tema da AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white, // Cor do título e ícones
        elevation: 2,
      ),

      // --- CORREÇÃO AQUI ---
      // Tema da TabBar
      tabBarTheme: TabBarThemeData( // O correto é TabBarThemeData
        indicatorColor: Colors.white,         // Cor da linha que fica em baixo da aba selecionada
        labelColor: Colors.white,             // Cor do texto e ícone da aba SELECIONADA
        unselectedLabelColor: Colors.white.withOpacity(0.7), // Cor da aba NÃO SELECIONADA, com um pouco de transparência
        indicatorSize: TabBarIndicatorSize.label, // A linha indicadora tem o tamanho do texto, não da aba inteira
      ),
      // --- FIM DA CORREÇÃO ---

      // Tema dos Cards
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
      
      // Tema dos Botões Elevados (ElevatedButton)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // Tema dos Campos de Texto (TextField)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
      ),
      
      // Tema dos Chips (Tags)
      chipTheme: ChipThemeData(
        backgroundColor: accentColor.withOpacity(0.2),
        labelStyle: const TextStyle(color: textColor, fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: const BorderSide(color: Colors.transparent),
        ),
      ),
    );
  }
}
