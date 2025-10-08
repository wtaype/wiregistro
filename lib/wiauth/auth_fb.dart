import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'firestore_fb.dart';

class AuthServicio {
  static final _auth = FirebaseAuth.instance;

  // 🔐 Propiedades
  static User? get usuarioActual => _auth.currentUser;
  static bool get estaLogueado => usuarioActual != null;

  // 📧 Crear cuenta
  static Future<User> crearCuenta(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.toLowerCase().trim(),
        password: password,
      );
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      throw Exception(_obtenerMensajeError(e.code));
    }
  }

  // 🔑 Login
  static Future<User> login(String emailOUsuario, String password) async {
    try {
      String email = emailOUsuario.toLowerCase().trim();

      // Si no es email, buscar por usuario
      if (!EmailValidator.validate(emailOUsuario)) {
        final emailEncontrado = await DatabaseServicio.obtenerEmailPorUsuario(
          emailOUsuario,
        );
        if (emailEncontrado == null) throw Exception('Usuario no encontrado');
        email = emailEncontrado;
      }

      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Actualizar actividad si login por usuario
      if (!EmailValidator.validate(emailOUsuario)) {
        DatabaseServicio.actualizarUltimaActividad(emailOUsuario);
      }

      return credential.user!;
    } on FirebaseAuthException catch (e) {
      throw Exception(_obtenerMensajeError(e.code));
    }
  }

  // 🚪 Cerrar sesión
  static Future<void> logout() async => await _auth.signOut();

  // 🔄 Restablecer contraseña
  static Future<void> restablecerPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.toLowerCase().trim());
    } on FirebaseAuthException catch (e) {
      throw Exception(_obtenerMensajeError(e.code));
    }
  }

  // 🎯 Mensajes de error centralizados
  static String _obtenerMensajeError(String codigo) {
    switch (codigo) {
      case 'email-already-in-use':
        return 'Email ya registrado';
      case 'weak-password':
        return 'Contraseña muy débil';
      case 'invalid-email':
        return 'Email inválido';
      case 'user-not-found':
        return 'Usuario no encontrado';
      case 'wrong-password':
        return 'Contraseña incorrecta';
      case 'network-request-failed':
        return 'Sin conexión a internet';
      default:
        return 'Error de autenticación';
    }
  }
}
