import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aplicacionasa/main.dart';

void main() {
  testWidgets('Splash → login vacío → home con 4 secciones',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Pantalla de carga con el logo.
    expect(find.text('AURA+'), findsOneWidget);
    expect(find.text('Cargando'), findsOneWidget);

    // Avanzar hasta el login.
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    // Login con campos vacíos.
    expect(find.text('Iniciar sesión'), findsOneWidget);
    expect(find.text('Ingresar al panel'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));

    // Ingresar sin escribir nada.
    await tester.ensureVisible(find.text('Ingresar al panel'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ingresar al panel'));
    await tester.pumpAndSettle();

    // Barra inferior con las 4 opciones.
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('En vivo'), findsWidgets);
    expect(find.text('Atenciones'), findsWidgets);
    expect(find.text('Historial'), findsWidgets);
    expect(find.text('Perfil'), findsWidgets);

    // Cambiar a la sección Perfil.
    await tester.tap(find.byIcon(Icons.person_rounded));
    await tester.pumpAndSettle();
    expect(
      find.descendant(of: find.byType(AppBar), matching: find.text('Perfil')),
      findsOneWidget,
    );
  });
}
