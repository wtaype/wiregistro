import 'package:firebase_database/firebase_database.dart';
import 'usuario.dart';

class DatabaseServicio {
  static final _db = FirebaseDatabase.instance.ref();
  static const _coleccion = 'smiles';

  // 🔍 Verificar usuario existe
  static Future<bool> usuarioExiste(String usuario) async {
    try {
      final snapshot = await _db
          .child(_coleccion)
          .child(usuario.toLowerCase().trim())
          .get();
      return snapshot.exists;
    } catch (e) {
      print('Error verificando usuario: $e');
      return false; // Si hay error, asume que no existe para no bloquear
    }
  }

  // 📧 Verificar email existe
  static Future<bool> emailExiste(String email) async {
    try {
      final snapshot = await _db
          .child(_coleccion)
          .orderByChild('email')
          .equalTo(email.toLowerCase().trim())
          .get();
      return snapshot.exists;
    } catch (e) {
      print('Error verificando email: $e');
      return false; // Si hay error, asume que no existe para no bloquear
    }
  }

  // 💾 Guardar usuario en Realtime Database
  static Future<void> guardarUsuario(Usuario usuario) async {
    try {
      await _db
          .child(_coleccion)
          .child(usuario.usuarioLimpio)
          .set(usuario.toMap());
    } catch (e) {
      print('Error guardando usuario: $e');
      rethrow;
    }
  }

  // 🔍 Obtener usuario por nombre
  static Future<Usuario?> obtenerUsuario(String usuario) async {
    try {
      final snapshot = await _db
          .child(_coleccion)
          .child(usuario.toLowerCase().trim())
          .get();
      if (snapshot.exists && snapshot.value != null) {
        final data = Map<dynamic, dynamic>.from(snapshot.value as Map);
        return Usuario.fromMap(data, usuario.toLowerCase().trim());
      }
      return null;
    } catch (e) {
      print('Error obteniendo usuario: $e');
      return null;
    }
  }

  // 📧 Obtener email por usuario (para login)
  static Future<String?> obtenerEmailPorUsuario(String usuario) async {
    try {
      final usuarioData = await obtenerUsuario(usuario);
      return usuarioData?.email;
    } catch (e) {
      print('Error obteniendo email: $e');
      return null;
    }
  }

  // ⏰ Actualizar última actividad
  static Future<void> actualizarUltimaActividad(String usuario) async {
    try {
      await _db.child(_coleccion).child(usuario.toLowerCase().trim()).update({
        'ultimaActividad': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      print('Error actualizando actividad: $e');
      // No rethrow - no es crítico
    }
  }
}
