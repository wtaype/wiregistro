class Gasto {
  final String id;
  final String descripcion;
  final double monto;
  final DateTime fecha;
  final String categoria;

  Gasto({
    required this.id,
    required this.descripcion,
    required this.monto,
    required this.fecha,
    required this.categoria,
  });

  // Convertir a Map para guardar en Firestore
  Map<String, dynamic> aMap() {
    return {
      'descripcion': descripcion,
      'monto': monto,
      'fecha': fecha.toIso8601String(),
      'categoria': categoria,
    };
  }

  // Crear desde Map de Firestore
  factory Gasto.desdeMap(String id, Map<String, dynamic> map) {
    return Gasto(
      id: id,
      descripcion: map['descripcion'] ?? '',
      monto: (map['monto'] ?? 0).toDouble(),
      fecha: DateTime.parse(map['fecha']),
      categoria: map['categoria'] ?? 'Otros',
    );
  }

  // Para facilitar copiar con modificaciones
  Gasto copiarCon({
    String? id,
    String? descripcion,
    double? monto,
    DateTime? fecha,
    String? categoria,
  }) {
    return Gasto(
      id: id ?? this.id,
      descripcion: descripcion ?? this.descripcion,
      monto: monto ?? this.monto,
      fecha: fecha ?? this.fecha,
      categoria: categoria ?? this.categoria,
    );
  }
}
