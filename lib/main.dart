import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'firebase_options.dart';
import 'servicios/auth_servicio.dart';
import 'pantallas/splash_pantalla.dart';
import 'pantallas/login_pantalla.dart';
import 'pantallas/principal_pantalla.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDateFormatting('es', null);
  runApp(const MiApp());
}

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registro de Gastos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4CAF50),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      locale: const Locale('es', 'ES'),
      home: const VerificadorAutenticacion(),
    );
  }
}

class VerificadorAutenticacion extends StatelessWidget {
  const VerificadorAutenticacion({super.key});

  @override
  Widget build(BuildContext context) {
    final authServicio = AuthServicio();

    return StreamBuilder(
      stream: authServicio.cambioEstadoAuth,
      builder: (context, snapshot) {
        // Mostrar splash mientras se verifica
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashPantalla();
        }

        // Si hay usuario logueado, ir a principal
        if (snapshot.hasData && snapshot.data != null) {
          return const PrincipalPantalla();
        }

        // Si no hay usuario, ir a login
        return const LoginPantalla();
      },
    );
  }
}
