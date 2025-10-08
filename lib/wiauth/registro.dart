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
  final _email = TextEditingController();
  final _usuario = TextEditingController();
  final _nombre = TextEditingController();
  final _apellidos = TextEditingController();
  final _grupo = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  String _genero = 'masculino';
  bool _cargando = false;
  bool _verPassword = false;
  bool _verConfirm = false;

  // 🚨 Estados de validación CORREGIDOS
  bool _emailExiste = false;
  bool _usuarioExiste = false;
  bool _validandoEmail = false;
  bool _validandoUsuario = false;
  bool _emailValidado = false; // 🔥 NUEVO: si ya verificamos en Firebase
  bool _usuarioValidado = false; // 🔥 NUEVO: si ya verificamos en Firebase

  @override
  void initState() {
    super.initState();
    _email.addListener(_validarEmailTiempoReal);
    _usuario.addListener(_validarUsuarioTiempoReal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColores.verdeClaro,
      appBar: AppBar(
        title: Text('Registro', style: AppEstilos.textoBoton),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: AppColores.verdePrimario,
      ),
      body: SingleChildScrollView(
        padding: AppConstantes.miwp,
        child: Form(
          key: _form,
          child: Column(
            children: [
              _construirLogo(),
              const SizedBox(height: AppConstantes.espacioGrande),

              _construirCampoEmail(),
              const SizedBox(height: AppConstantes.espacioMedio),

              _construirCampoUsuario(),
              const SizedBox(height: AppConstantes.espacioMedio),

              Row(
                children: [
                  Expanded(
                    child: _construirCampo(
                      controller: _nombre,
                      label: 'Nombre',
                      hint: 'Tu nombre',
                      icon: Icons.badge,
                      validator: (v) =>
                          v?.trim().isEmpty ?? true ? 'Nombre requerido' : null,
                    ),
                  ),
                  const SizedBox(width: AppConstantes.espacioChico),
                  Expanded(
                    child: _construirCampo(
                      controller: _apellidos,
                      label: 'Apellidos',
                      hint: 'Tus apellidos',
                      validator: (v) => v?.trim().isEmpty ?? true
                          ? 'Apellidos requeridos'
                          : null,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppConstantes.espacioMedio),

              _construirCampo(
                controller: _grupo,
                label: 'Grupo',
                hint: 'familia, amigos, trabajo',
                icon: Icons.group,
                validator: (v) =>
                    v?.trim().isEmpty ?? true ? 'Grupo requerido' : null,
              ),

              const SizedBox(height: AppConstantes.espacioMedio),
              _construirSelectorGenero(),
              const SizedBox(height: AppConstantes.espacioMedio),

              _construirCampoPassword(
                controller: _password,
                label: 'Contraseña',
                mostrar: _verPassword,
                onToggle: () => setState(() => _verPassword = !_verPassword),
                validator: (v) {
                  if (v?.isEmpty ?? true) return 'Contraseña requerida';
                  if (v!.length < 6) return 'Mínimo 6 caracteres';
                  return null;
                },
              ),

              const SizedBox(height: AppConstantes.espacioMedio),

              _construirCampoPassword(
                controller: _confirmPassword,
                label: 'Confirmar Contraseña',
                mostrar: _verConfirm,
                onToggle: () => setState(() => _verConfirm = !_verConfirm),
                validator: (v) {
                  if (v?.isEmpty ?? true) return 'Confirma tu contraseña';
                  if (v != _password.text) return 'Contraseñas no coinciden';
                  return null;
                },
              ),

              const SizedBox(height: AppConstantes.espacioGigante),

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
              'https://wiregistro.web.app/smile.png',
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

  // 📧 Campo email con validación CORREGIDA
  Widget _construirCampoEmail() => TextFormField(
    controller: _email,
    keyboardType: TextInputType.emailAddress,
    validator: _validarEmail,
    style: AppEstilos.textoNormal,
    decoration: InputDecoration(
      labelText: 'Email',
      hintText: 'tu@email.com',
      prefixIcon: Icon(Icons.email, color: AppColores.verdePrimario),
      suffixIcon: _validandoEmail
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : _emailExiste
          ? Icon(Icons.error, color: Colors.red) // ❌ Existe
          : _emailValidado && EmailValidator.validate(_email.text)
          ? Icon(
              Icons.check_circle,
              color: Colors.green,
            ) // ✅ Solo después de verificar Firebase
          : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstantes.radioMedio),
        borderSide: BorderSide(
          color: _emailExiste ? Colors.red : AppColores.verdeSecundario,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstantes.radioMedio),
        borderSide: BorderSide(
          color: _emailExiste ? Colors.red : AppColores.verdePrimario,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstantes.radioMedio),
        borderSide: BorderSide(color: Colors.red, width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
    ),
  );

  // 👤 Campo usuario con validación CORREGIDA
  Widget _construirCampoUsuario() => TextFormField(
    controller: _usuario,
    validator: _validarUsuario,
    style: AppEstilos.textoNormal,
    decoration: InputDecoration(
      labelText: 'Usuario',
      hintText: 'usuario_unico',
      prefixIcon: Icon(Icons.person, color: AppColores.verdePrimario),
      suffixIcon: _validandoUsuario
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : _usuarioExiste
          ? Icon(Icons.error, color: Colors.red) // ❌ Existe
          : _usuarioValidado &&
                _usuario.text.length >= 3 &&
                RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(_usuario.text)
          ? Icon(
              Icons.check_circle,
              color: Colors.green,
            ) // ✅ Solo después de verificar Firebase
          : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstantes.radioMedio),
        borderSide: BorderSide(
          color: _usuarioExiste ? Colors.red : AppColores.verdeSecundario,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstantes.radioMedio),
        borderSide: BorderSide(
          color: _usuarioExiste ? Colors.red : AppColores.verdePrimario,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstantes.radioMedio),
        borderSide: BorderSide(color: Colors.red, width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
    ),
  );

  Widget _construirCampo({
    required TextEditingController controller,
    required String label,
    required String hint,
    IconData? icon,
    required String? Function(String?) validator,
  }) => TextFormField(
    controller: controller,
    validator: validator,
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

  Widget _construirCampoPassword({
    required TextEditingController controller,
    required String label,
    required bool mostrar,
    required VoidCallback onToggle,
    required String? Function(String?) validator,
  }) => TextFormField(
    controller: controller,
    obscureText: !mostrar,
    validator: validator,
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

  // 🕐 Validación email tiempo real CORREGIDA
  void _validarEmailTiempoReal() async {
    final email = _email.text.trim();

    // Reset estados
    setState(() {
      _emailValidado = false;
      _emailExiste = false;
    });

    // Si está vacío o formato incorrecto, no verificar Firebase
    if (email.isEmpty || !EmailValidator.validate(email)) {
      return;
    }

    setState(() => _validandoEmail = true);

    try {
      final existe = await DatabaseServicio.emailExiste(email);
      if (mounted) {
        setState(() {
          _emailExiste = existe;
          _emailValidado = true; // 🔥 Marca que ya verificamos Firebase
          _validandoEmail = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _emailExiste = false;
          _emailValidado = false;
          _validandoEmail = false;
        });
      }
    }
  }

  // 🕐 Validación usuario tiempo real CORREGIDA
  void _validarUsuarioTiempoReal() async {
    final usuario = _usuario.text.trim();

    // Reset estados
    setState(() {
      _usuarioValidado = false;
      _usuarioExiste = false;
    });

    // Si formato incorrecto, no verificar Firebase
    if (usuario.length < 3 || !RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(usuario)) {
      return;
    }

    setState(() => _validandoUsuario = true);

    try {
      final existe = await DatabaseServicio.usuarioExiste(usuario);
      if (mounted) {
        setState(() {
          _usuarioExiste = existe;
          _usuarioValidado = true; // 🔥 Marca que ya verificamos Firebase
          _validandoUsuario = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _usuarioExiste = false;
          _usuarioValidado = false;
          _validandoUsuario = false;
        });
      }
    }
  }

  String? _validarEmail(String? email) {
    if (email?.trim().isEmpty ?? true) return 'Email requerido';
    if (!EmailValidator.validate(email!)) return 'Email inválido';
    if (_emailExiste) return 'Email ya registrado';
    return null;
  }

  String? _validarUsuario(String? usuario) {
    if (usuario?.trim().isEmpty ?? true) return 'Usuario requerido';
    if (usuario!.length < 3) return 'Mínimo 3 caracteres';
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(usuario))
      return 'Solo letras, números y _';
    if (_usuarioExiste) return 'Usuario no disponible';
    return null;
  }

  bool _puedeRegistrar() {
    return !_cargando &&
        !_emailExiste &&
        !_usuarioExiste &&
        !_validandoEmail &&
        !_validandoUsuario &&
        _emailValidado && // 🔥 Debe haber verificado en Firebase
        _usuarioValidado && // 🔥 Debe haber verificado en Firebase
        _email.text.isNotEmpty &&
        _usuario.text.isNotEmpty &&
        _nombre.text.isNotEmpty &&
        _apellidos.text.isNotEmpty &&
        _grupo.text.isNotEmpty &&
        _password.text.length >= 6 &&
        _confirmPassword.text == _password.text;
  }

  void _registrarUsuario() async {
    if (!_form.currentState!.validate()) return;

    setState(() => _cargando = true);

    try {
      // 1. Crear cuenta Auth
      final user = await AuthServicio.crearCuenta(_email.text, _password.text);

      // 2. Crear modelo Usuario
      final usuario = Usuario.nuevo(
        email: _email.text,
        usuario: _usuario.text,
        nombre: _nombre.text,
        apellidos: _apellidos.text,
        grupo: _grupo.text,
        genero: _genero,
        uid: user.uid,
      );

      // 3. Guardar en Realtime Database
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
    _email.dispose();
    _usuario.dispose();
    _nombre.dispose();
    _apellidos.dispose();
    _grupo.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }
}
