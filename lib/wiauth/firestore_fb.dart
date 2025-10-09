import 'package:cloud_firestore/cloud_firestore.dart';
import '../recursos/constantes.dart';
import 'usuario.dart';

class DatabaseServicio {
  static final _db = FirebaseFirestore.instance;
  static CollectionReference get _collection =>
      _db.collection(AppFirebase.coleccionUsuarios);

  // 🔍 Verificar usuario existe - COMPACTO
  static Future<bool> usuarioExiste(String usuario) async {
    try {
      final doc = await _collection.doc(AppFormatos.usuario(usuario)).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  // 📧 Verificar email existe - COMPACTO
  static Future<bool> emailExiste(String email) async {
    try {
      final query = await _collection
          .where('email', isEqualTo: AppFormatos.email(email))
          .limit(1)
          .get();
      return query.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // 💾 Guardar usuario - COMPACTO con retry automático
  static Future<void> guardarUsuario(Usuario usuario) async {
    try {
      await _collection.doc(usuario.usuarioLimpio).set(usuario.toFirestore());

      // 🐢 Delay para tortuga Firestore
      await Future.delayed(AppFirebase.delayVerificacion);

      // 🔍 Verificación + retry automático
      final verificacion = await _collection.doc(usuario.usuarioLimpio).get();
      if (!verificacion.exists) {
        await Future.delayed(AppConstantes.animacionRapida);
        await _collection.doc(usuario.usuarioLimpio).set(usuario.toFirestore());
      }
    } catch (e) {
      // 🔄 Retry en caso de error
      await Future.delayed(AppConstantes.animacionRapida);
      await _collection.doc(usuario.usuarioLimpio).set(usuario.toFirestore());
    }
  }

  // 🔍 Obtener usuario - COMPACTO
  static Future<Usuario?> obtenerUsuario(String usuario) async {
    try {
      final doc = await _collection.doc(AppFormatos.usuario(usuario)).get();
      return doc.exists ? Usuario.fromFirestore(doc) : null;
    } catch (e) {
      return null;
    }
  }

  // 📧 Obtener email por usuario - UNA LÍNEA
  static Future<String?> obtenerEmailPorUsuario(String usuario) async =>
      (await obtenerUsuario(usuario))?.email;

  // ⏰ Actualizar actividad - COMPACTO
  static Future<void> actualizarUltimaActividad(String usuario) async {
    try {
      await _collection.doc(AppFormatos.usuario(usuario)).update({
        'ultimaActividad': Timestamp.now(),
      });
    } catch (_) {} // Silent fail
  }

  // 🔥 AGREGAR: Obtener usuario por email
  static Future<Usuario?> obtenerUsuarioPorEmail(String email) async {
    try {
      final query = await _collection
          .where('email', isEqualTo: AppFormatos.email(email))
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        return Usuario.fromFirestore(query.docs.first);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
