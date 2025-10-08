import 'package:flutter/material.dart';
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
  final _controllers = {
    'email': TextEditingController(),
    'usuario': TextEditingController(),
    'nombre': TextEditingController(),
    'apellidos': TextEditingController(),
    'grupo': TextEditingController(),
    'password': TextEditingController(),
    'confirmPassword': TextEditingController(),
  };

  String _genero = 'masculino';
  bool _cargando = false;
  bool _verPassword = false, _verConfirm = false;

  // 🚨 Estados de validación
  final _validacion = {
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
    _controllers['email']!.addListener(_validarEmailTiempoReal);
    _controllers['usuario']!.addListener(_validarUsuarioTiempoReal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColores.verdeClaro,
      appBar: AppBar(
        title: Text('Registro', style: AppEstilos.textoBoton),
        centerTitle: true,
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

              // 📧 Email con validación visual
              _construirCampoValidacion(
                controller: _controllers['email']!,
                label: 'Email',
                hint: 'tu@email.com',
                icon: Icons.email,
                keyboard: TextInputType.emailAddress,
                validando: _validacion['validandoEmail']!,
                tieneError: _validacion['emailExiste']!,
                esExito:
                    _validacion['emailValidado']! &&
                    !_validacion['emailExiste']!,
                validator: _validarEmail,
              ),

              const SizedBox(height: AppConstantes.espacioMedio),

              // 👤 Usuario con validación visual
              _construirCampoValidacion(
                controller: _controllers['usuario']!,
                label: 'Usuario',
                hint: 'usuario_unico',
                icon: Icons.person,
                validando: _validacion['validandoUsuario']!,
                tieneError: _validacion['usuarioExiste']!,
                esExito:
                    _validacion['usuarioValidado']! &&
                    !_validacion['usuarioExiste']!,
                validator: _validarUsuario,
              ),

              const SizedBox(height: AppConstantes.espacioMedio),

              // 📝 Nombre y Apellidos
              Row(
                children: [
                  Expanded(
                    child: _construirCampo(
                      'nombre',
                      'Nombre',
                      'Tu nombre',
                      Icons.badge,
                    ),
                  ),
                  const SizedBox(width: AppConstantes.espacioChico),
                  Expanded(
                    child: _construirCampo(
                      'apellidos',
                      'Apellidos',
                      'Tus apellidos',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppConstantes.espacioMedio),

              // 👥 Grupo
              _construirCampo(
                'grupo',
                'Grupo',
                'familia, amigos, trabajo',
                Icons.group,
              ),

              const SizedBox(height: AppConstantes.espacioMedio),

              // 🚻 Género
              _construirSelectorGenero(),

              const SizedBox(height: AppConstantes.espacioMedio),

              // 🔒 Contraseñas
              _construirCampoPassword(
                'password',
                'Contraseña',
                _verPassword,
                () => setState(() => _verPassword = !_verPassword),
              ),
              const SizedBox(height: AppConstantes.espacioMedio),
              _construirCampoPassword(
                'confirmPassword',
                'Confirmar Contraseña',
                _verConfirm,
                () => setState(() => _verConfirm = !_verConfirm),
              ),

              const SizedBox(height: AppConstantes.espacioGigante),

              // 🎯 Botón registro
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
                  label: Text(_cargando ? 'Registrando...' : 'Crear Cuenta'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColores.verdePrimario,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppConstantes.espacioMedio,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppConstantes.radioMedio,
                      ),
                    ),
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

  // 🎨 Logo
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
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: ClipOval(
            child: Image.network(
              AppUrls.logoUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Icon(
                Icons.account_circle,
                size: 60,
                color: AppColores.verdePrimario,
              ),
              loadingBuilder: (_, child, progress) => progress == null
                  ? child
                  : CircularProgressIndicator(color: AppColores.verdePrimario),
            ),
          ),
        ),
        const SizedBox(height: AppConstantes.espacioChico),
        Text(AppConstantes.nombreApp, style: AppEstilos.tituloMedio),
        Text('Únete a la familia smile 😊', style: AppEstilos.textoNormal),
      ],
    ),
  );

  // 📧 Campo con validación visual - USANDO VdError/VdGreen
  Widget _construirCampoValidacion({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboard,
    required bool validando,
    required bool tieneError,
    required bool esExito,
    required String? Function(String?) validator,
  }) => TextFormField(
    controller: controller,
    keyboardType: keyboard,
    validator: validator,
    style: AppEstilos.textoNormal,
    decoration: tieneError
        ? VdError.decoration(
            label: label,
            hint: hint,
            icon: icon,
            suffixIcon: validando
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : null,
          )
        : esExito
        ? VdGreen.decoration(
            label: label,
            hint: hint,
            icon: icon,
            suffixIcon: validando
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : null,
          )
        : InputDecoration(
            labelText: label,
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColores.verdePrimario),
            suffixIcon: validando
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstantes.radioMedio),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstantes.radioMedio),
              borderSide: BorderSide(color: AppColores.verdePrimario, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
  );

  // 📝 Campo normal
  Widget _construirCampo(
    String key,
    String label,
    String hint, [
    IconData? icon,
  ]) => TextFormField(
    controller: _controllers[key]!,
    validator: (v) => v?.trim().isEmpty ?? true ? '$label requerido' : null,
    style: AppEstilos.textoNormal,
    decoration: InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: icon != null
          ? Icon(icon, color: AppColores.verdePrimario)
          : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstantes.radioMedio),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstantes.radioMedio),
        borderSide: BorderSide(color: AppColores.verdePrimario, width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
    ),
  );

  // 🔒 Campo password
  Widget _construirCampoPassword(
    String key,
    String label,
    bool mostrar,
    VoidCallback onToggle,
  ) => TextFormField(
    controller: _controllers[key]!,
    obscureText: !mostrar,
    validator: key == 'password' ? _validarPassword : _validarConfirmPassword,
    style: AppEstilos.textoNormal,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(Icons.lock, color: AppColores.verdePrimario),
      suffixIcon: IconButton(
        icon: Icon(
          mostrar ? Icons.visibility : Icons.visibility_off,
          color: AppColores.verdePrimario,
        ),
        onPressed: onToggle,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstantes.radioMedio),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstantes.radioMedio),
        borderSide: BorderSide(color: AppColores.verdePrimario, width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
    ),
  );

  // 🚻 Selector género
  Widget _construirSelectorGenero() => Container(
    decoration: BoxDecoration(
      border: Border.all(color: AppColores.verdeSecundario),
      borderRadius: BorderRadius.circular(AppConstantes.radioMedio),
      color: Colors.white,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    child: Row(
      children: [
        Icon(Icons.wc, color: AppColores.verdePrimario),
        const SizedBox(width: AppConstantes.espacioChico),
        Expanded(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _genero,
              items: [
                DropdownMenuItem(value: 'masculino', child: Text('Masculino')),
                DropdownMenuItem(value: 'femenino', child: Text('Femenino')),
              ],
              onChanged: (valor) => setState(() => _genero = valor!),
            ),
          ),
        ),
      ],
    ),
  );

  // 🕐 Validación email tiempo real
  void _validarEmailTiempoReal() async {
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

  // 🕐 Validación usuario tiempo real
  void _validarUsuarioTiempoReal() async {
    final usuario = _controllers['usuario']!.text.trim();

    setState(() {
      _validacion['usuarioValidado'] = false;
      _validacion['usuarioExiste'] = false;
    });

    if (usuario.length < 3 || !RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(usuario))
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

  // ✅ Validaciones
  String? _validarEmail(String? email) {
    if (email?.trim().isEmpty ?? true) return 'Email requerido';
    if (!EmailValidator.validate(email!)) return 'Email inválido';
    if (_validacion['emailExiste']!) return 'Email ya registrado';
    return null;
  }

  String? _validarUsuario(String? usuario) {
    if (usuario?.trim().isEmpty ?? true) return 'Usuario requerido';
    if (usuario!.length < 3) return 'Mínimo 3 caracteres';
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(usuario))
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

  // 🎯 Verificar si puede registrar
  bool _puedeRegistrar() {
    return !_cargando &&
        !_validacion['emailExiste']! &&
        !_validacion['usuarioExiste']! &&
        !_validacion['validandoEmail']! &&
        !_validacion['validandoUsuario']! &&
        _validacion['emailValidado']! &&
        _validacion['usuarioValidado']! &&
        _controllers.values.every((c) => c.text.isNotEmpty) &&
        _controllers['password']!.text.length >= 6 &&
        _controllers['confirmPassword']!.text == _controllers['password']!.text;
  }

  // 🚀 Registrar usuario
  void _registrarUsuario() async {
    if (!_form.currentState!.validate()) return;

    setState(() => _cargando = true);

    try {
      // 1. Crear cuenta Auth
      final user = await AuthServicio.crearCuenta(
        _controllers['email']!.text,
        _controllers['password']!.text,
      );

      // 2. Crear modelo Usuario
      final usuario = Usuario.nuevo(
        email: _controllers['email']!.text,
        usuario: _controllers['usuario']!.text,
        nombre: _controllers['nombre']!.text,
        apellidos: _controllers['apellidos']!.text,
        grupo: _controllers['grupo']!.text,
        genero: _genero,
        uid: user.uid,
      );

      // 3. Guardar en Database
      await DatabaseServicio.guardarUsuario(usuario);

      // 4. Éxito
      _mostrarExito('¡Cuenta creada exitosamente! 🎉');
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PantallaGastos()),
        );
      }
    } catch (e) {
      _mostrarError(e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  // 📨 Mensajes
  void _mostrarError(String mensaje) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensaje),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );

  void _mostrarExito(String mensaje) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensaje),
          backgroundColor: AppColores.verdePrimario,
          behavior: SnackBarBehavior.floating,
        ),
      );

  @override
  void dispose() {
    _controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }
}
