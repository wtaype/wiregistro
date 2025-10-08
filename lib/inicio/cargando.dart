import 'package:flutter/material.dart';
import '../recursos/colores.dart';
import '../wiauth/registro.dart'; // 📝 Importación directa para velocidad

class PantallaCargando extends StatefulWidget {
  const PantallaCargando({super.key});

  @override
  State<PantallaCargando> createState() => _PantallaCargandoState();
}

class _PantallaCargandoState extends State<PantallaCargando>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _controller.forward();
    _navegar();
  }

  // 🚀 Navegación directa (más rápida que routes)
  _navegar() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PantallaRegistro()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColores.verdeClaro,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) => FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColores.verdePrimario,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('WiRegistro', style: AppEstilos.tituloGrande),
                  const SizedBox(height: 40),
                  CircularProgressIndicator(color: AppColores.verdePrimario),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
