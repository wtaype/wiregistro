class Usuario {
  final String email;
  final String usuario;
  final String nombre;
  final String apellidos;
  final String grupo;
  final String genero;
  final String rol;
  final bool activo;
  final int creacion;
  final String uid;
  final int ultimaActividad;

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
  });

  // 🔄 Desde Firebase Realtime Database
  factory Usuario.fromMap(Map<dynamic, dynamic> data, String usuarioId) {
    return Usuario(
      email: data['email'] ?? '',
      usuario: usuarioId,
      nombre: data['nombre'] ?? '',
      apellidos: data['apellidos'] ?? '',
      grupo: data['grupo'] ?? 'general',
      genero: data['genero'] ?? 'masculino',
      rol: data['rol'] ?? 'smile',
      activo: data['activo'] ?? true,
      creacion: data['creacion'] ?? DateTime.now().millisecondsSinceEpoch,
      uid: data['uid'] ?? '',
      ultimaActividad:
          data['ultimaActividad'] ?? DateTime.now().millisecondsSinceEpoch,
    );
  }

  // 🔄 A Firebase Realtime Database
  Map<String, dynamic> toMap() {
    return {
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
    };
  }

  // 🎯 Crear nuevo usuario
  factory Usuario.nuevo({
    required String email,
    required String usuario,
    required String nombre,
    required String apellidos,
    required String grupo,
    required String genero,
    required String uid,
  }) {
    final ahora = DateTime.now().millisecondsSinceEpoch;
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
    );
  }

  // 🎨 Helpers útiles
  String get nombreCompleto => '$nombre $apellidos';
  String get usuarioLimpio => usuario.toLowerCase().trim();
  String get emailLimpio => email.toLowerCase().trim();
}
