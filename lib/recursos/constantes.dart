import 'package:flutter/material.dart';

class AppConstantes {
  // 🏠 Información de la app
  static const String nombreApp = 'WiRegistro';
  static const String version = '1.0.0';
  static const String descripcion = 'La mejor app para registrar gastos';

  // 🎨 ASSETS CONSTANTES - ¡Una línea limpia para usar!
  static const String _logoPath = 'assets/images/logo.png';

  // 🖼️ Widgets de imagen listos para usar (más eficiente)
  static Widget get miLogo => Image.asset(
    _logoPath,
    width: 80,
    height: 80,
    fit: BoxFit.cover,
    errorBuilder: (_, __, ___) =>
        Icon(Icons.account_circle, size: 80, color: verdePrimario),
  );

  // 🎨 Logo circular para usar directo
  static Widget get miLogoCircular => Container(
    width: 80,
    height: 80,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: verdePrimario.withOpacity(0.3),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: ClipOval(child: miLogo),
  );

  // 🎨 Colores básicos (para no importar el archivo completo)
  static const Color verdePrimario = Color(0xFF4CAF50);
  static const Color verdeSecundario = Color(0xFF81C784);
  static const Color verdeClaro = Color(0xFFB9F6CA);
  static const Color verdeSuave = Color(0xFFE8F5E8);

  // 📱 Textos que usamos actualmente
  static const String bienvenida = '¡Dios te ama bro! 😎';
  static const String cargando = 'Ingresando al mejor app...';
  static const String error = 'Algo salió mal';
  static const String sinInternet = 'Sin conexión a internet';

  // 🎨 Espaciados
  static const double espacioChico = 8.0;
  static const double espacioMedio = 16.0;
  static const double espacioGrande = 24.0;
  static const double espacioGigante = 32.0;

  // 📐 Radios
  static const double radioChico = 8.0;
  static const double radioMedio = 12.0;
  static const double radioGrande = 16.0;

  // ⏱️ Duraciones
  static const Duration animacionRapida = Duration(milliseconds: 300);
  static const Duration animacionLenta = Duration(milliseconds: 600);
  static const Duration tiempoCarga = Duration(seconds: 3);

  // 📱 Padding estándar
  static const EdgeInsets miwp = EdgeInsets.symmetric(
    vertical: 9.0,
    horizontal: 10.0,
  );

  // 🎨 Otros paddings útiles
  static const EdgeInsets miwpL = EdgeInsets.symmetric(
    vertical: 15.0,
    horizontal: 20.0,
  );

  static const EdgeInsets miwpS = EdgeInsets.symmetric(
    vertical: 5.0,
    horizontal: 8.0,
  );

  // 🎯 Iconos comunes
  static Widget get iconoUsuario => Icon(Icons.person, color: verdePrimario);
  static Widget get iconoEmail => Icon(Icons.email, color: verdePrimario);
  static Widget get iconoCargando =>
      CircularProgressIndicator(color: verdePrimario);

  // 🎨 Espaciadores comunes
  static Widget get espacioChicoWidget => SizedBox(height: espacioChico);
  static Widget get espacioMedioWidget => SizedBox(height: espacioMedio);
  static Widget get espacioGrandeWidget => SizedBox(height: espacioGrande);
}
