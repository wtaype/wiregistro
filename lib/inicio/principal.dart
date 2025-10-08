import 'package:flutter/material.dart';
import '../recursos/colores.dart';
import '../recursos/constantes.dart';
import '../recursos/widgets.dart';

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _EstadoPantallaPrincipal();
}

class _EstadoPantallaPrincipal extends State<PantallaPrincipal> {
  final _controladorNombre = TextEditingController();
  final _controladorMensaje = TextEditingController();
  final _formularioKey = GlobalKey<FormState>();
  bool _estaCargando = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColores.verdeClaro,
      appBar: AppBar(
        title: Text(AppConstantes.nombreApp, style: AppEstilos.textoBoton),
        backgroundColor: AppColores.verdePrimario,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstantes.espacioMedio),
        child: Form(
          key: _formularioKey,
          child: Column(
            children: [
              // 💳 Tarjeta de bienvenida compacta
              TarjetaInformacion(contenido: _construirTarjetaBienvenida()),

              const SizedBox(height: AppConstantes.espacioGigante),

              // 📝 Campos de texto
              CampoTexto(
                etiqueta: 'Tu nombre',
                pista: 'Escribe tu nombre...',
                icono: Icons.person,
                controlador: _controladorNombre,
                validador: (v) =>
                    v?.trim().isEmpty == true ? 'Nombre requerido' : null,
              ),

              const SizedBox(height: AppConstantes.espacioGrande),

              CampoTexto(
                etiqueta: 'Tu mensaje',
                pista: 'Escribe tu mensaje...',
                icono: Icons.message,
                controlador: _controladorMensaje,
                validador: (v) =>
                    v?.trim().isEmpty == true ? 'Mensaje requerido' : null,
              ),

              const SizedBox(height: AppConstantes.espacioGigante),

              // 🎯 Botones compactos
              ..._construirBotones(),

              const Spacer(),

              // 💡 Info compacta
              TarjetaInformacion(
                elevacion: 2,
                colorFondo: AppColores.verdeSuave,
                contenido: _construirInfoAyuda(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🎨 Widgets helpers compactos
  Widget _construirTarjetaBienvenida() => Row(
    children: [
      Container(
        padding: const EdgeInsets.all(AppConstantes.espacioChico),
        decoration: BoxDecoration(
          color: AppColores.verdePrimario,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.message, size: 40, color: Colors.white),
      ),
      const SizedBox(width: AppConstantes.espacioMedio),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppConstantes.bienvenida, style: AppEstilos.tituloMedio),
            const SizedBox(height: AppConstantes.espacioChico),
            Text('Comparte tu nombre y mensaje', style: AppEstilos.textoNormal),
          ],
        ),
      ),
    ],
  );

  List<Widget> _construirBotones() => [
    SizedBox(
      width: double.infinity,
      child: BotonPrincipal(
        texto: _estaCargando ? AppConstantes.cargando : 'Mostrar Saludo',
        icono: Icons.send,
        estaCargando: _estaCargando,
        alPresionar: _mostrarSaludo,
      ),
    ),
    const SizedBox(height: AppConstantes.espacioMedio),
    SizedBox(
      width: double.infinity,
      child: BotonPrincipal(
        texto: 'Limpiar',
        icono: Icons.clear,
        colorFondo: AppColores.verdeSecundario,
        alPresionar: _limpiarCampos,
      ),
    ),
  ];

  Widget _construirInfoAyuda() => Row(
    children: [
      Icon(Icons.info_outline, color: AppColores.verdePrimario),
      const SizedBox(width: AppConstantes.espacioChico),
      Expanded(
        child: Text(
          'Completa ambos campos para ver el saludo personalizado 🎉',
          style: AppEstilos.textoChico,
        ),
      ),
    ],
  );

  // 🎉 Métodos de acción compactos
  void _mostrarSaludo() async {
    if (!_formularioKey.currentState!.validate()) {
      MensajeHelper.mostrarError(context, 'Completa todos los campos');
      return;
    }

    setState(() => _estaCargando = true);
    await Future.delayed(AppConstantes.animacionLenta);
    setState(() => _estaCargando = false);

    final nombre = _controladorNombre.text.trim();
    final mensaje = _controladorMensaje.text.trim();
    final saludo = 'Hola $nombre, me gusta tu mensaje de: "$mensaje"';

    MensajeHelper.mostrarExito(context, saludo);
    _mostrarDialogo(nombre, mensaje);
  }

  void _mostrarDialogo(String nombre, String mensaje) => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstantes.radioMedio),
      ),
      title: Row(
        children: [
          Icon(Icons.celebration, color: AppColores.verdePrimario),
          const SizedBox(width: AppConstantes.espacioChico),
          Text('¡Saludo!', style: AppEstilos.tituloMedio),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('¡Hola $nombre! 👋', style: AppEstilos.subtitulo),
          const SizedBox(height: AppConstantes.espacioMedio),
          Container(
            padding: const EdgeInsets.all(AppConstantes.espacioMedio),
            decoration: BoxDecoration(
              color: AppColores.verdeSuave,
              borderRadius: BorderRadius.circular(AppConstantes.radioChico),
            ),
            child: Text('"$mensaje"', style: AppEstilos.textoNormal),
          ),
        ],
      ),
      actions: [
        BotonPrincipal(
          texto: 'Genial',
          icono: Icons.thumb_up,
          alPresionar: () => Navigator.pop(context),
        ),
      ],
    ),
  );

  void _limpiarCampos() {
    _controladorNombre.clear();
    _controladorMensaje.clear();
    MensajeHelper.mostrarExito(context, 'Campos limpiados 🧹');
  }

  @override
  void dispose() {
    _controladorNombre.dispose();
    _controladorMensaje.dispose();
    super.dispose();
  }
}
