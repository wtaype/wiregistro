import 'package:flutter/material.dart';
import '../recursos/colores.dart';
import '../recursos/constantes.dart';
import '../recursos/widgets.dart';

class PantallaGastos extends StatelessWidget {
  const PantallaGastos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColores.verdeClaro,
      appBar: AppBar(
        title: Text('Mis Gastos', style: AppEstilos.textoBoton),
        backgroundColor: AppColores.verdePrimario,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () =>
              Navigator.pushReplacementNamed(context, '/principal'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstantes.espacioMedio),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 💖 Mensaje amoroso
              TarjetaInformacion(
                colorFondo: AppColores.verdeSuave,
                elevacion: 8,
                contenido: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppConstantes.espacioMedio),
                      decoration: BoxDecoration(
                        color: AppColores.verdePrimario,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: AppConstantes.espacioGrande),
                    Text(
                      'Es bueno tenerte aquí',
                      style: AppEstilos.tituloMedio,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppConstantes.espacioChico),
                    Text(
                      '¡Te amoo! 💚',
                      style: AppEstilos.tituloGrande.copyWith(
                        color: AppColores.verdePrimario,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppConstantes.espacioMedio),
                    Text(
                      'Aquí podrás gestionar todos tus gastos de manera fácil y bonita',
                      style: AppEstilos.textoNormal,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppConstantes.espacioGigante),

              // 🎯 Botones de acción
              SizedBox(
                width: double.infinity,
                child: BotonPrincipal(
                  texto: 'Agregar Mi Primer Gasto',
                  icono: Icons.add_circle,
                  alPresionar: () => MensajeHelper.mostrarExito(
                    context,
                    '¡Próximamente podrás agregar gastos! 💰',
                  ),
                ),
              ),

              const SizedBox(height: AppConstantes.espacioMedio),

              SizedBox(
                width: double.infinity,
                child: BotonPrincipal(
                  texto: 'Ver Mis Estadísticas',
                  icono: Icons.bar_chart,
                  colorFondo: AppColores.verdeSecundario,
                  alPresionar: () => MensajeHelper.mostrarExito(
                    context,
                    '¡Pronto tendrás gráficos hermosos! 📊',
                  ),
                ),
              ),

              const SizedBox(height: AppConstantes.espacioGigante),

              // 💡 Información adicional
              TarjetaInformacion(
                elevacion: 2,
                contenido: Row(
                  children: [
                    Icon(Icons.lightbulb, color: AppColores.verdePrimario),
                    const SizedBox(width: AppConstantes.espacioChico),
                    Expanded(
                      child: Text(
                        'Tip: Esta será tu pantalla principal para gestionar gastos. ¡Estamos construyendo algo increíble para ti!',
                        style: AppEstilos.textoChico,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // 🎈 Botón flotante amoroso
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushReplacementNamed(context, '/principal'),
        icon: const Icon(Icons.home),
        label: const Text('Ir a Principal'),
        backgroundColor: AppColores.verdePrimario,
      ),
    );
  }
}
