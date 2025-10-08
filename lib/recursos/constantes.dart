import 'package:flutter/material.dart';

class AppConstantes {
  // 🏠 Información de la app
  static const String nombreApp = 'WiRegistro';
  static const String version = '1.0.0';
  static const String descripcion = 'La mejor app para registrar gastos';

  // 📱 Textos que usamos mucho
  static const String bienvenida = '¡Dios te ama bro! 😎';
  static const String cargando = 'Ingresando al mejor app...';
  static const String error = 'Algo salió mal';
  static const String sinInternet = 'Sin conexión a internet';

  // 💰 Categorías con sus íconos - ¡ÚNICA FUENTE DE VERDAD!
  static const Map<String, IconData> categoriasConIconos = {
    'Quesito': Icons.emoji_food_beverage, // 🧀 Para tus quesitos
    'Deliciosos grr': Icons.restaurant_menu, // 😋 Para comidas deliciosas
    'Entretenimiento': Icons.movie, // 🎬
    'Compras': Icons.shopping_bag, // 🛍️
    'Salud': Icons.local_hospital, // 🏥
    'Educación': Icons.school, // 🎓
    'Servicios': Icons.build, // 🔧
    'Otros': Icons.attach_money, // 💰
  };

  // 📋 Lista de categorías (se genera automáticamente del mapa)
  static List<String> get categorias => categoriasConIconos.keys.toList();

  // 🎯 Método para obtener ícono - ¡Una línea limpia!
  static IconData obtenerIconoCategoria(String categoria) {
    return categoriasConIconos[categoria] ?? Icons.help_outline;
  }

  // 🎨 Método extra: obtener todas las categorías con descripciones
  static List<Map<String, dynamic>> get categoriasDetalladas {
    const descripciones = {
      'Quesito': 'Gastos en quesitos y lácteos 🧀',
      'Deliciosos grr': 'Comidas deliciosas que te hacen grr 😋',
      'Entretenimiento': 'Diversión y espectáculos 🎬',
      'Compras': 'Compras varias y shopping 🛍️',
      'Salud': 'Gastos médicos y bienestar 🏥',
      'Educación': 'Estudios y aprendizaje 🎓',
      'Servicios': 'Servicios profesionales 🔧',
      'Otros': 'Gastos varios 💰',
    };

    return categorias
        .map(
          (categoria) => {
            'nombre': categoria,
            'icono': obtenerIconoCategoria(categoria),
            'descripcion': descripciones[categoria] ?? 'Sin descripción',
          },
        )
        .toList();
  }

  // 🎨 Tamaños de espaciado
  static const double espacioChico = 8.0;
  static const double espacioMedio = 16.0;
  static const double espacioGrande = 24.0;
  static const double espacioGigante = 32.0;

  // 📐 Radios de bordes
  static const double radioChico = 8.0;
  static const double radioMedio = 12.0;
  static const double radioGrande = 16.0;

  // ⏱️ Duraciones de animaciones
  static const Duration animacionRapida = Duration(milliseconds: 300);
  static const Duration animacionLenta = Duration(milliseconds: 600);
  static const Duration tiempoCarga = Duration(seconds: 3);

  // 📱 Padding estándar para toda la app - ¡Reutilizable!
  static const EdgeInsets miwp = EdgeInsets.symmetric(
    vertical: 9.0, // ⬆️⬇️ Arriba y abajo 9px
    horizontal: 10.0, // ⬅️➡️ Izquierda y derecha 10px
  );

  // 🎨 Otros paddings útiles (opcionales)
  static const EdgeInsets miwpL = EdgeInsets.symmetric(
    vertical: 15.0,
    horizontal: 20.0,
  );

  static const EdgeInsets miwpS = EdgeInsets.symmetric(
    vertical: 5.0,
    horizontal: 8.0,
  );
}

// 🔗 URLs y endpoints
class AppUrls {
  static const String politicaPrivacidad =
      'https://wiregistro.web.app/privacidad';
  static const String terminosUso = 'https://wiregistro.web.app/terminos';
  static const String soporte = 'mailto:soporte@wiregistro.com';
  static const String logoUrl = 'https://wiregistro.web.app/smile.png';
}

// 💾 Keys para SharedPreferences
class AppKeys {
  static const String usuario = 'usuario_actual';
  static const String temaOscuro = 'tema_oscuro';
  static const String primerIngreso = 'primer_ingreso';
  static const String idiomaApp = 'idioma_app';
}
