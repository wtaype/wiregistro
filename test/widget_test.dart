import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wiregistro/main.dart';

void main() {
  testWidgets('App inicia correctamente', (WidgetTester tester) async {
    // Configurar Firebase Mock
    setupFirebaseAuthMocks();

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MiApp());

    // Verificar que el título de la app existe
    expect(find.text('💰 Mis Gastos'), findsOneWidget);

    // Verificar que existe el botón de agregar
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}

// Mock para Firebase (necesario para testing)
void setupFirebaseAuthMocks() {
  TestWidgetsFlutterBinding.ensureInitialized();
}
