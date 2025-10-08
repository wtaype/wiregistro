import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// 🎨 Nuestra paleta de colores guapos y gorditos
class AppColores {
  // 🌿 Verdes gorditos y bonitos
  static const Color verdePrimario = Color(0xFF4CAF50);
  static const Color verdeSecundario = Color(0xFF81C784);
  static const Color verdeClaro = Color(0xFFB9F6CA);
  static const Color verdeSuave = Color(0xFFE8F5E8);

  // 🖤 Solo para texto cuando necesitemos contraste
  static const Color textoOscuro = Color(0xFF2E2E2E);
  static const Color textoVerde = Color(0xFF388E3C);
  static const Color blanco = Colors.white;
}

// 🎭 Nuestro "CSS root" - ¡Poppins centralizado! 🎨 Theme completo para MaterialApp
class AppEstilos {
  static ThemeData get temaApp => ThemeData(
    scaffoldBackgroundColor: AppColores.verdeClaro,
    primarySwatch: Colors.green,

    // 🎭 ¡Fuente por defecto para TODA la app!
    fontFamily: GoogleFonts.poppins().fontFamily, // Como tu * en CSS
    // 📱 AppBar theme [START]
    appBarTheme: AppBarTheme(
      backgroundColor: AppColores.verdePrimario,
      foregroundColor: AppColores.blanco,
      elevation: 4.0, // 📐 MÁS sombra (era 4.0, ahora 8.0)
      toolbarHeight: 45.0, // 📏 45px de altura (era 56.0)
      titleTextStyle: textoBoton,
      centerTitle: true,
      iconTheme: IconThemeData(
        color: AppColores.blanco,
        size: 22.0, // 🔧 Íconos más chicos para 45px
      ),
      // 🌟 Sombra personalizada
      shadowColor: AppColores.verdePrimario.withOpacity(
        0.3,
      ), // Color de la sombra
    ),

    // 🎯 Ahora tus estilos pueden ser más simples
    textTheme: TextTheme(
      headlineLarge: tituloGrande,
      headlineMedium: tituloMedio,
      titleLarge: subtitulo,
      bodyLarge: textoNormal,
      bodyMedium: textoChico,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColores.verdePrimario,
        foregroundColor: AppColores.blanco,
        textStyle: textoBoton,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  // 📝 Títulos gorditos
  static TextStyle get tituloGrande => GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: AppColores.textoVerde,
  );

  static TextStyle get tituloMedio => GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColores.textoVerde,
  );

  static TextStyle get subtitulo => GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColores.textoOscuro,
  );

  // 📱 Textos normales
  static TextStyle get textoNormal => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColores.textoOscuro,
  );

  static TextStyle get textoChico => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColores.textoOscuro,
  );

  // 🎯 Botones
  static TextStyle get textoBoton => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColores.blanco,
  );
}
