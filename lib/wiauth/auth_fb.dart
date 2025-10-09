import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'firestore_fb.dart';

class AuthServicio {
  static final _auth = FirebaseAuth.instance;

  // 🔐 Propiedades
  static User? get usuarioActual => _auth.currentUser;
  static bool get estaLogueado => usuarioActual != null;

  // 📧 Crear cuenta CON DEBUG
  static Future<User> crearCuenta(String email, String password) async {
    try {
      print('🔐 Creando cuenta Auth para: $email');

      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.toLowerCase().trim(),
        password: password,
      );

      if (credential.user == null) {
        throw Exception('Usuario creado pero credential.user es null');
      }

      print('✅ Cuenta Auth creada exitosamente');
      print('🆔 UID: ${credential.user!.uid}');

      return credential.user!;
    } on FirebaseAuthException catch (e) {
      print('❌ Error Firebase Auth: ${e.code} - ${e.message}');
      throw Exception(_mensajeError(e.code));
    } catch (e) {
      print('❌ Error general Auth: $e');
      throw Exception('Error inesperado: $e');
    }
  }

  // 🔑 Login
  static Future<User> login(String emailOUsuario, String password) async {
    try {
      String email = emailOUsuario.toLowerCase().trim();

      // Si no es email, buscar por usuario
      if (!EmailValidator.validate(emailOUsuario)) {
        print('🔍 Buscando email para usuario: $emailOUsuario');
        final emailEncontrado = await DatabaseServicio.obtenerEmailPorUsuario(
          emailOUsuario,
        );
        if (emailEncontrado == null) throw Exception('Usuario no encontrado');
        email = emailEncontrado;
        print('✅ Email encontrado: $email');
      }

      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Actualizar actividad
      if (!EmailValidator.validate(emailOUsuario)) {
        DatabaseServicio.actualizarUltimaActividad(emailOUsuario);
      }

      return credential.user!;
    } on FirebaseAuthException catch (e) {
      throw Exception(_mensajeError(e.code));
    }
  }

  // 🚪 Cerrar sesión
  static Future<void> logout() async => await _auth.signOut();

  // 🔄 Restablecer contraseña
  static Future<void> restablecerPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.toLowerCase().trim());
    } on FirebaseAuthException catch (e) {
      throw Exception(_mensajeError(e.code));
    }
  }

  // 🎯 Mensajes de error
  static String _mensajeError(String codigo) => switch (codigo) {
    'email-already-in-use' => 'Email ya registrado',
    'weak-password' => 'Contraseña muy débil',
    'invalid-email' => 'Email inválido',
    'user-not-found' => 'Usuario no encontrado',
    'wrong-password' => 'Contraseña incorrecta',
    'network-request-failed' => 'Sin conexión a internet',
    _ => 'Error de autenticación',
  };
}
