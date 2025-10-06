import 'package:flutter/material.dart';
import '../modelos/gasto.dart';

class TarjetaGasto extends StatelessWidget {
  final Gasto gasto;
  final VoidCallback alEliminar;

  const TarjetaGasto({
    super.key,
    required this.gasto,
    required this.alEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: _obtenerColorCategoria(gasto.categoria),
          child: Icon(
            _obtenerIconoCategoria(gasto.categoria),
            color: Colors.white,
          ),
        ),
        title: Text(
          gasto.descripcion,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              gasto.categoria,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            const SizedBox(height: 2),
            Text(
              '${gasto.fecha.day}/${gasto.fecha.month}/${gasto.fecha.year}',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'S/ ${gasto.monto.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              color: Colors.red[300],
              onPressed: alEliminar,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
            ),
          ],
        ),
      ),
    );
  }

  IconData _obtenerIconoCategoria(String categoria) {
    switch (categoria) {
      case 'Comida':
        return Icons.restaurant;
      case 'Transporte':
        return Icons.directions_car;
      case 'Entretenimiento':
        return Icons.movie;
      case 'Salud':
        return Icons.local_hospital;
      case 'Educación':
        return Icons.school;
      case 'Servicios':
        return Icons.build;
      case 'Compras':
        return Icons.shopping_bag;
      default:
        return Icons.more_horiz;
    }
  }

  Color _obtenerColorCategoria(String categoria) {
    switch (categoria) {
      case 'Comida':
        return Colors.orange;
      case 'Transporte':
        return Colors.blue;
      case 'Entretenimiento':
        return Colors.purple;
      case 'Salud':
        return Colors.red;
      case 'Educación':
        return Colors.green;
      case 'Servicios':
        return Colors.brown;
      case 'Compras':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }
}
