import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  final String email, usuario, nombre, apellidos, grupo, genero;
  final String rol;
  final bool activo;
  final Timestamp creacion, ultimaActividad;
  final String uid;
  final Timestamp? aceptoTerminos; // 🔥 AGREGAR ESTA LÍNEA

  const Usuario({
    required this.email,
    required this.usuario,
    required this.nombre,
    required this.apellidos,
    required this.grupo,
    required this.genero,
    this.rol = 'smile',
    this.activo = true,
    required this.creacion,
    required this.uid,
    required this.ultimaActividad,
    this.aceptoTerminos, // 🔥 AGREGAR ESTA LÍNEA
  });

  // 🔄 Desde Firestore
  factory Usuario.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Usuario(
      email: data['email'] ?? '',
      usuario: doc.id,
      nombre: data['nombre'] ?? '',
      apellidos: data['apellidos'] ?? '',
      grupo: data['grupo'] ?? 'genial',
      genero: data['genero'] ?? 'masculino',
      rol: data['rol'] ?? 'smile',
      activo: data['activo'] ?? true,
      creacion: data['creacion'] ?? Timestamp.now(),
      uid: data['uid'] ?? '',
      ultimaActividad: data['ultimaActividad'] ?? Timestamp.now(),
      aceptoTerminos: data['aceptoTerminos'], // 🔥 AGREGAR ESTA LÍNEA
    );
  }

  // 🔄 A Firestore
  Map<String, dynamic> toFirestore() => {
    'email': email.toLowerCase().trim(),
    'usuario': usuario.toLowerCase().trim(),
    'nombre': nombre.trim(),
    'apellidos': apellidos.trim(),
    'grupo': grupo.toLowerCase().trim(),
    'genero': genero,
    'rol': rol,
    'activo': activo,
    'creacion': creacion,
    'uid': uid,
    'ultimaActividad': ultimaActividad,
    'aceptoTerminos': aceptoTerminos, // 🔥 AGREGAR ESTA LÍNEA
  };

  // 🎯 Constructor nuevo usuario
  factory Usuario.nuevo({
    required String email,
    required String usuario,
    required String nombre,
    required String apellidos,
    required String grupo,
    required String genero,
    required String uid,
  }) {
    final ahora = Timestamp.now();
    return Usuario(
      email: email.toLowerCase().trim(),
      usuario: usuario.toLowerCase().trim(),
      nombre: nombre.trim(),
      apellidos: apellidos.trim(),
      grupo: grupo.toLowerCase().trim(),
      genero: genero,
      creacion: ahora,
      uid: uid,
      ultimaActividad: ahora,
      aceptoTerminos: ahora, // 🔥  Acepta automáticamente al registrarse
    );
  }

  // 🎨 Helpers
  String get nombreCompleto => '$nombre $apellidos';
  String get usuarioLimpio => usuario.toLowerCase().trim();
  String get emailLimpio => email.toLowerCase().trim();
}
