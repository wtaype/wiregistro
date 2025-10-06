import 'package:cloud_firestore/cloud_firestore.dart';
import '../modelos/gasto.dart';

class FbServicio {
  final FirebaseFirestore _bd = FirebaseFirestore.instance;
  final String _coleccion = 'gastos';

  // Agregar un nuevo gasto
  Future<void> agregarGasto(Gasto gasto) async {
    try {
      await _bd.collection(_coleccion).add(gasto.aMap());
      print('✅ Gasto agregado exitosamente');
    } catch (e) {
      print('❌ Error al agregar gasto: $e');
      rethrow;
    }
  }

  // Obtener todos los gastos en tiempo real
  Stream<List<Gasto>> obtenerGastos() {
    return _bd
        .collection(_coleccion)
        .orderBy('fecha', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Gasto.desdeMap(doc.id, doc.data()))
              .toList();
        });
  }

  // Obtener gastos de un mes específico
  Stream<List<Gasto>> obtenerGastosPorMes(int anio, int mes) {
    final inicio = DateTime(anio, mes, 1);
    final fin = DateTime(anio, mes + 1, 0, 23, 59, 59);

    return _bd
        .collection(_coleccion)
        .where('fecha', isGreaterThanOrEqualTo: inicio.toIso8601String())
        .where('fecha', isLessThanOrEqualTo: fin.toIso8601String())
        .orderBy('fecha', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Gasto.desdeMap(doc.id, doc.data()))
              .toList();
        });
  }

  // Actualizar un gasto existente
  Future<void> actualizarGasto(String id, Gasto gasto) async {
    try {
      await _bd.collection(_coleccion).doc(id).update(gasto.aMap());
      print('✅ Gasto actualizado exitosamente');
    } catch (e) {
      print('❌ Error al actualizar gasto: $e');
      rethrow;
    }
  }

  // Eliminar un gasto
  Future<void> eliminarGasto(String id) async {
    try {
      await _bd.collection(_coleccion).doc(id).delete();
      print('✅ Gasto eliminado exitosamente');
    } catch (e) {
      print('❌ Error al eliminar gasto: $e');
      rethrow;
    }
  }

  // Calcular total de gastos
  Future<double> calcularTotalGastos() async {
    try {
      final snapshot = await _bd.collection(_coleccion).get();
      double total = 0;
      for (var doc in snapshot.docs) {
        total += (doc.data()['monto'] ?? 0).toDouble();
      }
      return total;
    } catch (e) {
      print('❌ Error al calcular total: $e');
      return 0;
    }
  }
}
