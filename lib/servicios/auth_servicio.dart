import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../modelos/usuario.dart';

class AuthServicio {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _bd = FirebaseFirestore.instance;

  User? get usuarioActual => _auth.currentUser;
  Stream<User?> get cambioEstadoAuth => _auth.authStateChanges();

  // Registrar usuario
  Future<Usuario?> registrar({
    required String email,
    required String password,
    required String usuario,
    required String nombres,
    required String apellidos,
    required String grupo,
  }) async {
    try {
      // Verificar si el usuario ya existe
      final querySnapshot = await _bd
          .collection('smiles')
          .where('usuario', isEqualTo: usuario)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        throw 'El usuario ya existe';
      }

      // Crear usuario en Firebase Auth
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Crear documento en Firestore
      final nuevoUsuario = Usuario(
        id: credential.user!.uid,
        email: email,
        usuario: usuario,
        nombres: nombres,
        apellidos: apellidos,
        grupo: grupo,
        fechaRegistro: DateTime.now(),
      );

      await _bd
          .collection('smiles')
          .doc(credential.user!.uid)
          .set(nuevoUsuario.aMap());

      return nuevoUsuario;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw 'La contraseña es muy débil';
      } else if (e.code == 'email-already-in-use') {
        throw 'El email ya está en uso';
      }
      throw e.message ?? 'Error al registrar';
    } catch (e) {
      throw e.toString();
    }
  }

  // Iniciar sesión
  Future<Usuario?> iniciarSesion({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return await obtenerUsuario(credential.user!.uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw 'Usuario no encontrado';
      } else if (e.code == 'wrong-password') {
        throw 'Contraseña incorrecta';
      }
      throw e.message ?? 'Error al iniciar sesión';
    }
  }

  // Obtener datos del usuario
  Future<Usuario?> obtenerUsuario(String uid) async {
    try {
      final doc = await _bd.collection('smiles').doc(uid).get();
      if (doc.exists) {
        return Usuario.desdeMap(doc.id, doc.data()!);
      }
      return null;
    } catch (e) {
      print('Error al obtener usuario: $e');
      return null;
    }
  }

  // Cerrar sesión
  Future<void> cerrarSesion() async {
    await _auth.signOut();
  }
}
