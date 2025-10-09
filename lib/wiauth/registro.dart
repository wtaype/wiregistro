import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';
import '../recursos/colores.dart';
import '../recursos/constantes.dart';
import '../secciones/gastos.dart';
import 'auth_fb.dart';
import 'firestore_fb.dart';
import 'usuario.dart';

class PantallaRegistro extends StatefulWidget {
  const PantallaRegistro({super.key});

  @override
  State<PantallaRegistro> createState() => _PantallaRegistroState();
}

class _PantallaRegistroState extends State<PantallaRegistro> {
  final _form = GlobalKey<FormState>();
  final _controllers = <String, TextEditingController>{
    for (var key in [
      'email',
      'usuario',
      'nombre',
      'apellidos',
      'grupo',
      'password',
      'confirmPassword',
    ])
      key: TextEditingController(),
  };

  final _focusNodes = <String, FocusNode>{
    'email': FocusNode(),
    'usuario': FocusNode(),
  };

  String _genero = 'masculino';
  bool _cargando = false;
  bool _registroCompletado = false; // 🛡️ Protección contra duplicados
  bool _verPassword = false, _verConfirm = false;

  final _validacion = <String, bool>{
    'emailExiste': false,
    'usuarioExiste': false,
    'validandoEmail': false,
    'validandoUsuario': false,
    'emailValidado': false,
    'usuarioValidado': false,
  };

  @override
  void initState() {
    super.initState();
    _configurarListeners();
  }

  void _configurarListeners() {
    // Sanitización email
    _controllers['email']!.addListener(() {
      final text = _controllers['email']!.text;
      final sanitized = text.toLowerCase().replaceAll(RegExp(r'\s+'), '');
      if (text != sanitized) {
        _controllers['email']!.value = TextEditingValue(
          text: sanitized,
          selection: TextSelection.collapsed(offset: sanitized.length),
        );
      }
    });

    // Sanitización usuario
    _controllers['usuario']!.addListener(() {
      final text = _controllers['usuario']!.text;
      final sanitized = text
          .toLowerCase()
          .replaceAll(RegExp(r'\s+'), '')
          .replaceAll(RegExp(r'[^a-z0-9_]'), '');
      if (text != sanitized) {
        _controllers['usuario']!.value = TextEditingValue(
          text: sanitized,
          selection: TextSelection.collapsed(offset: sanitized.length),
        );
      }
    });

    // Validación en blur
    _focusNodes['email']!.addListener(() {
      if (!_focusNodes['email']!.hasFocus) _validarEmailEnBlur();
    });

    _focusNodes['usuario']!.addListener(() {
      if (!_focusNodes['usuario']!.hasFocus) _validarUsuarioEnBlur();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColores.verdeClaro,
      appBar: AppBar(
        title: Text('Registro', style: AppEstilos.textoBoton),
        backgroundColor: AppColores.verdePrimario,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: AppConstantes.miwp,
        child: Form(
          key: _form,
          child: Column(
            children: [
              _construirLogo(),
              const SizedBox(height: AppConstantes.espacioGrande),

              // Email
              _campoValidacion(
                'email',
                'Email',
                'tu@email.com',
                Icons.email,
                TextInputType.emailAddress,
              ),
              const SizedBox(height: AppConstantes.espacioMedio),

              // Usuario
              _campoValidacion(
                'usuario',
                'Usuario',
                'usuario_unico',
                Icons.person,
              ),
              const SizedBox(height: AppConstantes.espacioMedio),

              // Nombre y Apellidos
              Row(
                children: [
                  Expanded(
                    child: _campoNormal(
                      'nombre',
                      'Nombre',
                      'Tu nombre',
                      Icons.badge,
                    ),
                  ),
                  const SizedBox(width: AppConstantes.espacioChico),
                  Expanded(
                    child: _campoNormal(
                      'apellidos',
                      'Apellidos',
                      'Tus apellidos',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstantes.espacioMedio),

              // Grupo
              _campoNormal(
                'grupo',
                'Grupo',
                'familia, amigos, trabajo',
                Icons.group,
              ),
              const SizedBox(height: AppConstantes.espacioMedio),

              // Género
              _construirSelectorGenero(),
              const SizedBox(height: AppConstantes.espacioMedio),

              // Contraseñas
              _campoPassword(
                'password',
                'Contraseña',
                _verPassword,
                () => setState(() => _verPassword = !_verPassword),
              ),
              const SizedBox(height: AppConstantes.espacioMedio),
              _campoPassword(
                'confirmPassword',
                'Confirmar Contraseña',
                _verConfirm,
                () => setState(() => _verConfirm = !_verConfirm),
              ),
              const SizedBox(height: AppConstantes.espacioGigante),

              // 🎯 Botón con protección completa
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _puedeRegistrar() ? _registrarUsuario : null,
                  icon: _cargando
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Icon(Icons.person_add),
                  label: Text(_obtenerTextoBoton()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _registroCompletado
                        ? AppColores.exito
                        : AppColores.verdePrimario,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColores.gris,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppConstantes.espacioMedio,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppConstantes.radioMedio,
                      ),
                    ),
                    elevation: _cargando ? 0 : 2,
                  ),
                ),
              ),
              const SizedBox(height: AppConstantes.espacioGrande),
            ],
          ),
        ),
      ),
    );
  }

  // 🎨 Logo simple
  Widget _construirLogo() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColores.verdeSuave,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: AppColores.verdePrimario.withOpacity(0.2),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      children: [
        AppConstantes.miLogoCircular, // 🔥 ¡Una línea limpia!
        const SizedBox(height: AppConstantes.espacioChico),
        Text(AppConstantes.nombreApp, style: AppEstilos.tituloMedio),
        Text('Únete a la familia smile 😊', style: AppEstilos.textoNormal),
      ],
    ),
  );

  // Campo con validación visual
  Widget _campoValidacion(
    String key,
    String label,
    String hint,
    IconData icon, [
    TextInputType? keyboard,
  ]) {
    final controller = _controllers[key]!;
    final validando = _validacion['validando${key.capitalize()}'] ?? false;
    final tieneError = _validacion['${key}Existe'] ?? false;
    final esExito = (_validacion['${key}Validado'] ?? false) && !tieneError;

    return TextFormField(
      controller: controller,
      focusNode: key == 'email' || key == 'usuario' ? _focusNodes[key] : null,
      keyboardType: keyboard,
      validator: key == 'email' ? _validarEmail : _validarUsuario,
      style: AppEstilos.textoNormal,
      inputFormatters: key == 'email'
          ? [FilteringTextInputFormatter.deny(RegExp(r'\s'))]
          : key == 'usuario'
          ? [
              FilteringTextInputFormatter.allow(RegExp(r'[a-z0-9_]')),
              LowerCaseTextFormatter(),
            ]
          : null,
      decoration: tieneError
          ? VdError.decoration(
              label: label,
              hint: hint,
              icon: icon,
              suffixIcon: validando ? _cargandoWidget() : null,
            )
          : esExito
          ? VdGreen.decoration(
              label: label,
              hint: hint,
              icon: icon,
              suffixIcon: validando ? _cargandoWidget() : null,
            )
          : _decoracionNormal(
              label,
              hint,
              icon,
              validando ? _cargandoWidget() : null,
            ),
    );
  }

  // Campo normal
  Widget _campoNormal(
    String key,
    String label,
    String hint, [
    IconData? icon,
  ]) => TextFormField(
    controller: _controllers[key]!,
    validator: (v) => v?.trim().isEmpty ?? true ? '$label requerido' : null,
    style: AppEstilos.textoNormal,
    decoration: _decoracionNormal(label, hint, icon ?? Icons.edit),
  );

  // Campo password
  Widget _campoPassword(
    String key,
    String label,
    bool mostrar,
    VoidCallback onToggle,
  ) => TextFormField(
    controller: _controllers[key]!,
    obscureText: !mostrar,
    validator: key == 'password' ? _validarPassword : _validarConfirmPassword,
    style: AppEstilos.textoNormal,
    decoration: _decoracionNormal(
      label,
      '••••••••',
      Icons.lock,
      IconButton(
        icon: Icon(
          mostrar ? Icons.visibility : Icons.visibility_off,
          color: AppColores.verdePrimario,
        ),
        onPressed: onToggle,
      ),
    ),
  );

  // Selector género
  Widget _construirSelectorGenero() => DropdownButtonFormField<String>(
    value: _genero,
    decoration: _decoracionNormal('Género', 'Selecciona tu género', Icons.wc),
    items: ['masculino', 'femenino', 'otro']
        .map(
          (genero) =>
              DropdownMenuItem(value: genero, child: Text(genero.capitalize())),
        )
        .toList(),
    onChanged: (valor) => setState(() => _genero = valor!),
  );

  // Decoración normal
  InputDecoration _decoracionNormal(
    String label,
    String hint,
    IconData icon, [
    Widget? suffixIcon,
  ]) => InputDecoration(
    labelText: label,
    hintText: hint,
    prefixIcon: Icon(icon, color: AppColores.verdePrimario),
    suffixIcon: suffixIcon,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppConstantes.radioMedio),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppConstantes.radioMedio),
      borderSide: BorderSide(color: AppColores.verdePrimario, width: 2),
    ),
    filled: true,
    fillColor: Colors.white,
  );

  Widget _cargandoWidget() => SizedBox(
    width: 20,
    height: 20,
    child: CircularProgressIndicator(strokeWidth: 2),
  );

  // 🎯 Texto dinámico del botón
  String _obtenerTextoBoton() {
    if (_registroCompletado) return '¡Cuenta Creada! ✅';
    if (_cargando) return 'Registrando...';
    return 'Crear Cuenta';
  }

  // Validación en blur
  void _validarEmailEnBlur() async {
    final email = _controllers['email']!.text.trim();
    setState(() {
      _validacion['emailValidado'] = false;
      _validacion['emailExiste'] = false;
    });
    if (email.isEmpty || !EmailValidator.validate(email)) return;
    setState(() => _validacion['validandoEmail'] = true);
    final existe = await DatabaseServicio.emailExiste(email);
    if (mounted) {
      setState(() {
        _validacion['emailExiste'] = existe;
        _validacion['emailValidado'] = true;
        _validacion['validandoEmail'] = false;
      });
    }
  }

  void _validarUsuarioEnBlur() async {
    final usuario = _controllers['usuario']!.text.trim();
    setState(() {
      _validacion['usuarioValidado'] = false;
      _validacion['usuarioExiste'] = false;
    });
    if (usuario.length < 3 || !RegExp(r'^[a-z0-9_]+$').hasMatch(usuario))
      return;
    setState(() => _validacion['validandoUsuario'] = true);
    final existe = await DatabaseServicio.usuarioExiste(usuario);
    if (mounted) {
      setState(() {
        _validacion['usuarioExiste'] = existe;
        _validacion['usuarioValidado'] = true;
        _validacion['validandoUsuario'] = false;
      });
    }
  }

  // Validaciones
  String? _validarEmail(String? email) {
    if (email?.trim().isEmpty ?? true) return 'Email requerido';
    if (!EmailValidator.validate(email!)) return 'Email inválido';
    if (_validacion['emailExiste']!) return 'Email ya registrado';
    return null;
  }

  String? _validarUsuario(String? usuario) {
    if (usuario?.trim().isEmpty ?? true) return 'Usuario requerido';
    if (usuario!.length < 3) return 'Mínimo 3 caracteres';
    if (!RegExp(r'^[a-z0-9_]+$').hasMatch(usuario))
      return 'Solo letras, números y _';
    if (_validacion['usuarioExiste']!) return 'Usuario no disponible';
    return null;
  }

  String? _validarPassword(String? password) {
    if (password?.isEmpty ?? true) return 'Contraseña requerida';
    if (password!.length < 6) return 'Mínimo 6 caracteres';
    return null;
  }

  String? _validarConfirmPassword(String? confirmPassword) {
    if (confirmPassword?.isEmpty ?? true) return 'Confirma tu contraseña';
    if (confirmPassword != _controllers['password']!.text)
      return 'Contraseñas no coinciden';
    return null;
  }

  // 🛡️ Verificar si puede registrar (con protección)
  bool _puedeRegistrar() =>
      !_cargando &&
      !_registroCompletado &&
      !(_validacion['emailExiste'] ?? true) &&
      !(_validacion['usuarioExiste'] ?? true) &&
      !(_validacion['validandoEmail'] ?? true) &&
      !(_validacion['validandoUsuario'] ?? true) &&
      (_validacion['emailValidado'] ?? false) &&
      (_validacion['usuarioValidado'] ?? false) &&
      _controllers.values.every((c) => c.text.isNotEmpty) &&
      _controllers['password']!.text.length >= 6 &&
      _controllers['confirmPassword']!.text == _controllers['password']!.text;

  // 🚀 Registrar usuario CON PROTECCIÓN TOTAL
  void _registrarUsuario() async {
    if (!_form.currentState!.validate() || _cargando || _registroCompletado)
      return;

    setState(() => _cargando = true);

    try {
      print('🚀 Iniciando proceso de registro...');

      // 1. 🐰 Crear cuenta Auth
      final user = await AuthServicio.crearCuenta(
        _controllers['email']!.text,
        _controllers['password']!.text,
      );
      print('✅ Paso 1: Auth completado');

      // 2. 📝 Crear Usuario
      final usuario = Usuario.nuevo(
        email: _controllers['email']!.text,
        usuario: _controllers['usuario']!.text,
        nombre: _controllers['nombre']!.text,
        apellidos: _controllers['apellidos']!.text,
        grupo: _controllers['grupo']!.text,
        genero: _genero,
        uid: user.uid,
      );
      print('✅ Paso 2: Usuario creado');

      // 3. 🐢 Guardar en Firestore
      await DatabaseServicio.guardarUsuario(usuario);
      print('✅ Paso 3: Firestore completado');

      // 4. ✅ Éxito total
      setState(() => _registroCompletado = true);
      _mostrarExito('¡Cuenta creada exitosamente! 🎉');

      await Future.delayed(const Duration(seconds: 3));

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PantallaGastos()),
        );
      }
    } catch (e) {
      print('❌ Error en registro: $e');
      _mostrarError(e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  // Mensajes
  void _mostrarError(String mensaje) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensaje),
          backgroundColor: AppColores.error,
          behavior: SnackBarBehavior.floating,
        ),
      );

  void _mostrarExito(String mensaje) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensaje),
          backgroundColor: AppColores.exito,
          behavior: SnackBarBehavior.floating,
        ),
      );

  @override
  void dispose() {
    _controllers.values.forEach((controller) => controller.dispose());
    _focusNodes.values.forEach((node) => node.dispose());
    super.dispose();
  }
}

// Extensions
extension StringExtension on String {
  String capitalize() =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';
}

class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}
