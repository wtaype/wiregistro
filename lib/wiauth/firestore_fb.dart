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
      return false; // No bloquear si hay error
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
      return false; // No bloquear si hay error
    }
  }

  // 💾 Guardar usuario
  static Future<void> guardarUsuario(Usuario usuario) async => await _db
      .child(_coleccion)
      .child(usuario.usuarioLimpio)
      .set(usuario.toMap());

  // 🔍 Obtener usuario
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
      return null;
    }
  }

  // 📧 Obtener email por usuario
  static Future<String?> obtenerEmailPorUsuario(String usuario) async {
    final usuarioData = await obtenerUsuario(usuario);
    return usuarioData?.email;
  }

  // ⏰ Actualizar última actividad
  static Future<void> actualizarUltimaActividad(String usuario) async {
    try {
      await _db.child(_coleccion).child(usuario.toLowerCase().trim()).update({
        'ultimaActividad': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      // No crítico
    }
  }
}
