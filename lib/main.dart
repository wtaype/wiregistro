import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'inicio/cargando.dart';
import 'inicio/principal.dart';
import 'secciones/gastos.dart'; // ¡Nueva importación!
import 'recursos/colores.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColores.verdeClaro,
      systemNavigationBarColor: AppColores.verdeClaro,
    ),
  );
  runApp(const MiApp());
}

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WiRegistrooo',
      debugShowCheckedModeBanner: false,
      theme: AppEstilos.temaApp,
      home: const PantallaCargando(),
      routes: {
        '/principal': (context) => const PantallaPrincipal(),
        '/gastos': (context) => const PantallaGastos(), // ¡Nueva ruta!
      },
    );
  }
}
