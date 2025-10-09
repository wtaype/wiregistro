import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'colores.dart';

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

  static const EdgeInsets miwpM = EdgeInsets.only(
    top: 10.0,
    bottom: 15.0,
    right: 10.0,
    left: 10.0,
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

class AppValidadores {
  // 🔥 Validadores reutilizables MEJORADOS
  static String? email(String? value) {
    if (value?.trim().isEmpty ?? true) return 'Email requerido';
    if (!EmailValidator.validate(value!)) return 'Email inválido';
    return null;
  }

  static String? usuario(String? value) {
    if (value?.trim().isEmpty ?? true) return 'Usuario requerido';
    if (value!.length < 3) return 'Mínimo 3 caracteres';
    if (!RegExp(r'^[a-z0-9_]+$').hasMatch(value))
      return 'Solo letras, números y _';
    return null;
  }

  static String? password(String? value) {
    if (value?.isEmpty ?? true) return 'Contraseña requerida';
    if (value!.length < 6) return 'Mínimo 6 caracteres';
    return null;
  }

  // 🔥 NUEVO: Validador para login (más flexible)
  static String? passwordLogin(String? value) {
    if (value?.isEmpty ?? true) return 'Contraseña requerida';
    return null; // No validar longitud en login
  }

  // 🔥 NUEVO: Validador para email o usuario
  static String? emailOUsuario(String? value) {
    if (value?.trim().isEmpty ?? true) return 'Email o usuario requerido';
    if (value!.length < 3) return 'Mínimo 3 caracteres';
    return null;
  }

  static String? requerido(String? value, String campo) =>
      value?.trim().isEmpty ?? true ? '$campo requerido' : null;
}

class AppFirebase {
  // 🔥 Configuración centralizada
  static const String coleccionUsuarios = 'smiles';
  static const int timeoutSegundos = 30;
  static const Duration delayVerificacion = Duration(milliseconds: 300);

  // 🎯 Mensajes de error centralizados
  static const Map<String, String> erroresAuth = {
    'email-already-in-use': 'Email ya registrado',
    'weak-password': 'Contraseña muy débil',
    'invalid-email': 'Email inválido',
    'user-not-found': 'Usuario no encontrado',
    'wrong-password': 'Contraseña incorrecta',
    'network-request-failed': 'Sin conexión a internet',
  };

  static String mensajeError(String codigo) =>
      erroresAuth[codigo] ?? 'Error de autenticación';

  // 🎯 Mensajes de éxito - AGREGAR ESTO
  static const Map<String, String> mensajesExito = {
    'registro': '¡Cuenta creada exitosamente! 🎉',
    'login': '¡Bienvenido de vuelta! 😊',
    'logout': '¡Hasta pronto! 👋',
    'password-reset': 'Email de recuperación enviado 📧',
  };

  static String mensajeExito(String tipo) =>
      mensajesExito[tipo] ?? '¡Operación exitosa!';
}

class AppFormatos {
  // 🧹 Sanitizadores reutilizables MEJORADOS
  static String email(String text) =>
      text.toLowerCase().replaceAll(RegExp(r'\s+'), '');

  static String usuario(String text) => text
      .toLowerCase()
      .replaceAll(RegExp(r'\s+'), '')
      .replaceAll(RegExp(r'[^a-z0-9_]'), '');

  // 🔥 NUEVO: Formatear email o usuario para login
  static String emailOUsuario(String text) {
    // Si contiene @, tratarlo como email
    if (text.contains('@')) {
      return email(text);
    }
    // Si no, tratarlo como usuario
    return usuario(text);
  }

  static String texto(String text) => text.trim();

  static String grupo(String text) => text.toLowerCase().trim();
}

class AppWidgets {
  // 🎨 Widgets preconstruidos
  static Widget cargando({double size = 20}) => SizedBox(
    width: size,
    height: size,
    child: CircularProgressIndicator(strokeWidth: 2),
  );

  static Widget espaciador(double altura) => SizedBox(height: altura);

  static Widget logoCircular() => Container(
    width: 80,
    height: 80,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: AppColores.verdePrimario.withOpacity(0.3),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: ClipOval(child: AppConstantes.miLogo),
  );
}
