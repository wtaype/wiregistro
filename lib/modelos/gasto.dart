class Gasto {
  final String id;
  final String descripcion;
  final double monto;
  final DateTime fecha;
  final String categoria;
  final String usuarioId;
  final String grupo;

  Gasto({
    required this.id,
    required this.descripcion,
    required this.monto,
    required this.fecha,
    required this.categoria,
    required this.usuarioId,
    required this.grupo,
  });

  Map<String, dynamic> aMap() {
    return {
      'descripcion': descripcion,
      'monto': monto,
      'fecha': fecha.toIso8601String(),
      'categoria': categoria,
      'usuarioId': usuarioId,
      'grupo': grupo,
    };
  }

  factory Gasto.desdeMap(String id, Map<String, dynamic> map) {
    return Gasto(
      id: id,
      descripcion: map['descripcion'] ?? '',
      monto: (map['monto'] ?? 0).toDouble(),
      fecha: DateTime.parse(map['fecha']),
      categoria: map['categoria'] ?? 'Otros',
      usuarioId: map['usuarioId'] ?? '',
      grupo: map['grupo'] ?? '',
    );
  }

  Gasto copiarCon({
    String? id,
    String? descripcion,
    double? monto,
    DateTime? fecha,
    String? categoria,
    String? usuarioId,
    String? grupo,
  }) {
    return Gasto(
      id: id ?? this.id,
      descripcion: descripcion ?? this.descripcion,
      monto: monto ?? this.monto,
      fecha: fecha ?? this.fecha,
      categoria: categoria ?? this.categoria,
      usuarioId: usuarioId ?? this.usuarioId,
      grupo: grupo ?? this.grupo,
    );
  }
}
