class Usuario {
  final String id;
  final String email;
  final String usuario; // documento
  final String nombres;
  final String apellidos;
  final String grupo;
  final DateTime fechaRegistro;

  Usuario({
    required this.id,
    required this.email,
    required this.usuario,
    required this.nombres,
    required this.apellidos,
    required this.grupo,
    required this.fechaRegistro,
  });

  String get nombreCompleto => '$nombres $apellidos';

  Map<String, dynamic> aMap() {
    return {
      'email': email,
      'usuario': usuario,
      'nombres': nombres,
      'apellidos': apellidos,
      'grupo': grupo,
      'fechaRegistro': fechaRegistro.toIso8601String(),
    };
  }

  factory Usuario.desdeMap(String id, Map<String, dynamic> map) {
    return Usuario(
      id: id,
      email: map['email'] ?? '',
      usuario: map['usuario'] ?? '',
      nombres: map['nombres'] ?? '',
      apellidos: map['apellidos'] ?? '',
      grupo: map['grupo'] ?? '',
      fechaRegistro: DateTime.parse(map['fechaRegistro']),
    );
  }
}
