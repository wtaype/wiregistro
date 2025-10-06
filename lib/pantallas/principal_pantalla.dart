import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../servicios/auth_servicio.dart';
import '../servicios/fb_servicio.dart';
import '../modelos/usuario.dart';
import '../modelos/gasto.dart';
import 'agregar_gasto_pantalla.dart';
import 'login_pantalla.dart';

class PrincipalPantalla extends StatefulWidget {
  const PrincipalPantalla({super.key});

  @override
  State<PrincipalPantalla> createState() => _PrincipalPantallaState();
}

class _PrincipalPantallaState extends State<PrincipalPantalla> {
  int _indiceActual = 0;
  final AuthServicio _authServicio = AuthServicio();
  final FbServicio _fbServicio = FbServicio();
  Usuario? _usuario;

  @override
  void initState() {
    super.initState();
    _cargarUsuario();
  }

  Future<void> _cargarUsuario() async {
    final uid = _authServicio.usuarioActual?.uid;
    if (uid != null) {
      final usuario = await _authServicio.obtenerUsuario(uid);
      setState(() {
        _usuario = usuario;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pantallas = [
      _PantallaRegistro(usuario: _usuario, fbServicio: _fbServicio),
      _PantallaGastos(usuario: _usuario, fbServicio: _fbServicio),
      _PantallaEstadisticas(usuario: _usuario, fbServicio: _fbServicio),
      _PantallaConfiguracion(usuario: _usuario, authServicio: _authServicio),
    ];

    return Scaffold(
      body: pantallas[_indiceActual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceActual,
        onTap: (index) {
          setState(() {
            _indiceActual = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF4CAF50),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Registro',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Gastos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Estadísticas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configuración',
          ),
        ],
      ),
      floatingActionButton: _indiceActual == 0 || _indiceActual == 1
          ? FloatingActionButton(
              onPressed: () => _navegarAAgregar(),
              backgroundColor: const Color(0xFF4CAF50),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  void _navegarAAgregar() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AgregarGastoPantalla(usuario: _usuario),
      ),
    );
  }
}

// ============ PANTALLA 1: REGISTRO CON CALENDARIO ============
class _PantallaRegistro extends StatefulWidget {
  final Usuario? usuario;
  final FbServicio fbServicio;

  const _PantallaRegistro({required this.usuario, required this.fbServicio});

  @override
  State<_PantallaRegistro> createState() => _PantallaRegistroState();
}

class _PantallaRegistroState extends State<_PantallaRegistro> {
  DateTime _fechaSeleccionada = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📅 Registro'),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Calendario
          Container(
            color: Colors.white,
            child: CalendarDatePicker(
              initialDate: _fechaSeleccionada,
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
              onDateChanged: (fecha) {
                setState(() {
                  _fechaSeleccionada = fecha;
                });
              },
            ),
          ),
          const Divider(height: 1),

          // Lista de gastos del día
          Expanded(
            child: StreamBuilder<List<Gasto>>(
              stream: widget.fbServicio.obtenerGastosPorMes(
                _fechaSeleccionada.year,
                _fechaSeleccionada.month,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 80,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No hay gastos registrados',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                final gastos = snapshot.data!.where((gasto) {
                  return gasto.fecha.year == _fechaSeleccionada.year &&
                      gasto.fecha.month == _fechaSeleccionada.month &&
                      gasto.fecha.day == _fechaSeleccionada.day;
                }).toList();

                if (gastos.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.event_available,
                          size: 80,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Sin gastos el ${DateFormat('dd/MM/yyyy').format(_fechaSeleccionada)}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final totalDia = gastos.fold<double>(
                  0,
                  (sum, gasto) => sum + gasto.monto,
                );

                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: const Color(0xFF4CAF50).withOpacity(0.1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat(
                              'EEEE, dd MMMM',
                              'es',
                            ).format(_fechaSeleccionada),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$${totalDia.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4CAF50),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: gastos.length,
                        itemBuilder: (context, index) {
                          final gasto = gastos[index];
                          return _TarjetaGastoSimple(
                            gasto: gasto,
                            onEliminar: () => _eliminarGasto(gasto.id),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _eliminarGasto(String id) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Gasto'),
        content: const Text('¿Estás seguro de eliminar este gasto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await widget.fbServicio.eliminarGasto(id);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('✅ Gasto eliminado')));
      }
    }
  }
}

// ============ PANTALLA 2: GASTOS ============
class _PantallaGastos extends StatelessWidget {
  final Usuario? usuario;
  final FbServicio fbServicio;

  const _PantallaGastos({required this.usuario, required this.fbServicio});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('💰 Gastos del Grupo'),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<Gasto>>(
        stream: fbServicio.obtenerGastos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No hay gastos registrados',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final gastos = snapshot.data!
              .where((gasto) => gasto.grupo == usuario?.grupo)
              .toList();

          if (gastos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.group_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tu grupo "${usuario?.grupo ?? ''}" no tiene gastos',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final totalGrupo = gastos.fold<double>(
            0,
            (sum, gasto) => sum + gasto.monto,
          );

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [const Color(0xFF4CAF50), const Color(0xFF81C784)],
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'Grupo: ${usuario?.grupo ?? ""}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Total Gastado',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    Text(
                      '\$${totalGrupo.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: gastos.length,
                  itemBuilder: (context, index) {
                    final gasto = gastos[index];
                    return _TarjetaGastoSimple(
                      gasto: gasto,
                      onEliminar: () => _eliminarGasto(context, gasto.id),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _eliminarGasto(BuildContext context, String id) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Gasto'),
        content: const Text('¿Estás seguro de eliminar este gasto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await fbServicio.eliminarGasto(id);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('✅ Gasto eliminado')));
      }
    }
  }
}

// ============ PANTALLA 3: ESTADÍSTICAS ============
class _PantallaEstadisticas extends StatelessWidget {
  final Usuario? usuario;
  final FbServicio fbServicio;

  const _PantallaEstadisticas({
    required this.usuario,
    required this.fbServicio,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📊 Estadísticas del Grupo'),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<Gasto>>(
        stream: fbServicio.obtenerGastos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay datos para mostrar'));
          }

          final gastos = snapshot.data!
              .where((gasto) => gasto.grupo == usuario?.grupo)
              .toList();

          if (gastos.isEmpty) {
            return const Center(child: Text('No hay gastos en tu grupo'));
          }

          // Calcular estadísticas
          final total = gastos.fold<double>(0, (sum, g) => sum + g.monto);
          final promedio = total / gastos.length;

          // Gastos por categoría
          final Map<String, double> porCategoria = {};
          for (var gasto in gastos) {
            porCategoria[gasto.categoria] =
                (porCategoria[gasto.categoria] ?? 0) + gasto.monto;
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _TarjetaEstadistica(
                titulo: 'Total Gastado',
                valor: '\$${total.toStringAsFixed(2)}',
                icono: Icons.attach_money,
                color: Colors.green,
              ),
              _TarjetaEstadistica(
                titulo: 'Promedio por Gasto',
                valor: '\$${promedio.toStringAsFixed(2)}',
                icono: Icons.trending_up,
                color: Colors.blue,
              ),
              _TarjetaEstadistica(
                titulo: 'Total de Gastos',
                valor: '${gastos.length}',
                icono: Icons.receipt,
                color: Colors.orange,
              ),
              const SizedBox(height: 20),
              const Text(
                'Gastos por Categoría',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...porCategoria.entries.map((entry) {
                final porcentaje = (entry.value / total * 100);
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              entry.key,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '\$${entry.value.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4CAF50),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: porcentaje / 100,
                          backgroundColor: Colors.grey[200],
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF4CAF50),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${porcentaje.toStringAsFixed(1)}%',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }
}

// ============ PANTALLA 4: CONFIGURACIÓN ============
class _PantallaConfiguracion extends StatelessWidget {
  final Usuario? usuario;
  final AuthServicio authServicio;

  const _PantallaConfiguracion({
    required this.usuario,
    required this.authServicio,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('⚙️ Configuración'),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFF4CAF50), const Color(0xFF81C784)],
              ),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 50, color: Color(0xFF4CAF50)),
                ),
                const SizedBox(height: 16),
                Text(
                  usuario?.nombreCompleto ?? 'Usuario',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  usuario?.email ?? '',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          _OpcionConfiguracion(
            icono: Icons.person_outline,
            titulo: 'Usuario',
            subtitulo: usuario?.usuario ?? '',
          ),
          _OpcionConfiguracion(
            icono: Icons.group_outlined,
            titulo: 'Grupo',
            subtitulo: usuario?.grupo ?? '',
          ),
          _OpcionConfiguracion(
            icono: Icons.calendar_today,
            titulo: 'Miembro desde',
            subtitulo: usuario != null
                ? DateFormat('dd/MM/yyyy').format(usuario!.fechaRegistro)
                : '',
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Cerrar Sesión',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            onTap: () => _cerrarSesion(context),
          ),
        ],
      ),
    );
  }

  Future<void> _cerrarSesion(BuildContext context) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro de cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Salir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await authServicio.cerrarSesion();
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPantalla()),
        );
      }
    }
  }
}

// ============ WIDGETS AUXILIARES ============
class _TarjetaGastoSimple extends StatelessWidget {
  final Gasto gasto;
  final VoidCallback onEliminar;

  const _TarjetaGastoSimple({required this.gasto, required this.onEliminar});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _obtenerColorCategoria(gasto.categoria),
          child: Icon(
            _obtenerIconoCategoria(gasto.categoria),
            color: Colors.white,
          ),
        ),
        title: Text(
          gasto.descripcion,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(DateFormat('dd/MM/yyyy HH:mm').format(gasto.fecha)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '\$${gasto.monto.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4CAF50),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onEliminar,
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

class _TarjetaEstadistica extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icono;
  final Color color;

  const _TarjetaEstadistica({
    required this.titulo,
    required this.valor,
    required this.icono,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: color.withOpacity(0.2),
              child: Icon(icono, color: color, size: 30),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  valor,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OpcionConfiguracion extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String subtitulo;

  const _OpcionConfiguracion({
    required this.icono,
    required this.titulo,
    required this.subtitulo,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icono, color: const Color(0xFF4CAF50)),
      title: Text(titulo),
      subtitle: Text(subtitulo),
    );
  }
}
