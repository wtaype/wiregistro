import 'package:cloud_firestore/cloud_firestore.dart';
import 'usuario.dart';

class DatabaseServicio {
  static final _db = FirebaseFirestore.instance;
  static const _coleccion = 'smiles';
  static CollectionReference get _collection => _db.collection(_coleccion);

  // 🔍 Verificar usuario existe
  static Future<bool> usuarioExiste(String usuario) async {
    try {
      print('🔍 Verificando usuario: $usuario');
      final doc = await _collection.doc(usuario.toLowerCase().trim()).get();
      final existe = doc.exists;
      print('👤 Usuario existe: $existe');
      return existe;
    } catch (e) {
      print('❌ Error verificando usuario: $e');
      return false;
    }
  }

  // 📧 Verificar email existe
  static Future<bool> emailExiste(String email) async {
    try {
      print('🔍 Verificando email: $email');
      final query = await _collection
          .where('email', isEqualTo: email.toLowerCase().trim())
          .limit(1)
          .get();
      final existe = query.docs.isNotEmpty;
      print('📧 Email existe: $existe');
      return existe;
    } catch (e) {
      print('❌ Error verificando email: $e');
      return false;
    }
  }

  // 💾 Guardar usuario - CON DEBUG Y RETRY
  static Future<void> guardarUsuario(Usuario usuario) async {
    try {
      print('💾 Guardando usuario: ${usuario.usuario}');
      print('📄 Datos: ${usuario.toFirestore()}');

      // Guardar en Firestore
      await _collection.doc(usuario.usuarioLimpio).set(usuario.toFirestore());
      print('✅ Usuario guardado exitosamente');

      // Verificación opcional
      await Future.delayed(const Duration(milliseconds: 300));
      final verificacion = await _collection.doc(usuario.usuarioLimpio).get();

      if (verificacion.exists) {
        print('✅ Verificación exitosa - usuario existe en Firestore');
      } else {
        print('⚠️ Advertencia - usuario no encontrado en verificación');
        // Retry
        await _collection.doc(usuario.usuarioLimpio).set(usuario.toFirestore());
      }
    } catch (e) {
      print('❌ Error guardando usuario: $e');
      rethrow; // Re-lanzar para manejar en UI
    }
  }

  // 🔍 Obtener usuario
  static Future<Usuario?> obtenerUsuario(String usuario) async {
    try {
      final doc = await _collection.doc(usuario.toLowerCase().trim()).get();
      return doc.exists ? Usuario.fromFirestore(doc) : null;
    } catch (e) {
      print('❌ Error obteniendo usuario: $e');
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
      await _collection.doc(usuario.toLowerCase().trim()).update({
        'ultimaActividad': Timestamp.now(),
      });
    } catch (e) {
      print('⚠️ Error actualizando actividad: $e');
    }
  }
}
