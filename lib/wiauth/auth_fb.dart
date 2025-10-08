import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'firestore_fb.dart';

class AuthServicio {
  static final _auth = FirebaseAuth.instance;

  // 🔐 Usuario actual
  static User? get usuarioActual => _auth.currentUser;
  static bool get estaLogueado => usuarioActual != null;

  // 📧 Crear cuenta Firebase Auth
  static Future<User> crearCuenta(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.toLowerCase().trim(),
        password: password,
      );

      if (credential.user == null) {
        throw Exception('Error creando cuenta');
      }

      return credential.user!;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw Exception('Este email ya está registrado en Auth');
        case 'weak-password':
          throw Exception('Contraseña muy débil');
        case 'invalid-email':
          throw Exception('Email inválido');
        case 'network-request-failed':
          throw Exception('Sin conexión a internet');
        default:
          throw Exception('Error: ${e.message}');
      }
    } catch (e) {
      print('Error en AuthServicio.crearCuenta: $e');
      rethrow;
    }
  }

  // 🔑 Login con email o usuario
  static Future<User> login(String emailOUsuario, String password) async {
    try {
      String email = emailOUsuario.toLowerCase().trim();

      // Si no es email, buscar email por usuario
      if (!EmailValidator.validate(emailOUsuario)) {
        final emailEncontrado = await DatabaseServicio.obtenerEmailPorUsuario(
          emailOUsuario,
        );
        if (emailEncontrado == null) {
          throw Exception('Usuario no encontrado');
        }
        email = emailEncontrado;
      }

      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw Exception('Error en login');
      }

      // Actualizar última actividad si fue login por usuario
      if (!EmailValidator.validate(emailOUsuario)) {
        await DatabaseServicio.actualizarUltimaActividad(emailOUsuario);
      }

      return credential.user!;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw Exception('Usuario no encontrado');
        case 'wrong-password':
          throw Exception('Contraseña incorrecta');
        case 'invalid-email':
          throw Exception('Email inválido');
        case 'network-request-failed':
          throw Exception('Sin conexión a internet');
        default:
          throw Exception('Error: ${e.message}');
      }
    } catch (e) {
      print('Error en AuthServicio.login: $e');
      rethrow;
    }
  }

  // 🚪 Cerrar sesión
  static Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Error cerrando sesión');
    }
  }

  // 🔄 Restablecer contraseña
  static Future<void> restablecerPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.toLowerCase().trim());
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw Exception('Email no registrado');
        case 'invalid-email':
          throw Exception('Email inválido');
        default:
          throw Exception('Error: ${e.message}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
