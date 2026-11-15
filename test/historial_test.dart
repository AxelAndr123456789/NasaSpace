import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aplicacionasa/data/recomendaciones_estres.dart';
import 'package:aplicacionasa/data/recomendaciones_gad.dart';
import 'package:aplicacionasa/data/recomendaciones_phq.dart';
import 'package:aplicacionasa/data/recomendaciones_regulacion.dart';
import 'package:aplicacionasa/data/recomendaciones_resiliencia.dart';
import 'package:aplicacionasa/data/recomendaciones_ucla.dart';
import 'package:aplicacionasa/data/recomendaciones_who.dart';
import 'package:aplicacionasa/models/resultado_test_model.dart';
import 'package:aplicacionasa/pages/test_estres_page.dart';
import 'package:aplicacionasa/pages/test_gad_page.dart';
import 'package:aplicacionasa/pages/test_phq_page.dart';
import 'package:aplicacionasa/pages/test_resiliencia_page.dart';
import 'package:aplicacionasa/pages/test_ucla_page.dart';
import 'package:aplicacionasa/pages/test_who_page.dart';
import 'package:aplicacionasa/pages/historial_page.dart';
import 'package:aplicacionasa/pages/resultado_detalle_page.dart';
import 'package:aplicacionasa/pages/test_erq_page.dart';
import 'package:aplicacionasa/services/historial_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await HistorialService.instancia.limpiar();
  });

  test('Estrés bajo/moderado/alto según los rangos PSS-14', () {
    expect(NivelEstres.desdePuntuacion(0), NivelEstres.bajo);
    expect(NivelEstres.desdePuntuacion(16), NivelEstres.bajo);
    expect(NivelEstres.desdePuntuacion(17), NivelEstres.moderado);
    expect(NivelEstres.desdePuntuacion(34), NivelEstres.moderado);
    expect(NivelEstres.desdePuntuacion(35), NivelEstres.alto);
    expect(NivelEstres.desdePuntuacion(56), NivelEstres.alto);
  });

  test('La puntuación es la suma directa de las 14 respuestas (0 a 56)', () {
    // Mejor caso: todas las respuestas en 0 → 0 puntos.
    expect(TestEstresPageState.calcularPuntuacion(List.filled(14, 0)), 0);
    // Estado crítico: todas las respuestas en 4 → 56 puntos.
    expect(TestEstresPageState.calcularPuntuacion(List.filled(14, 4)), 56);
    // Mezcla de respuestas: se suman tal cual, sin invertir nada.
    const mezcla = [0, 1, 2, 3, 4, 0, 1, 2, 3, 4, 0, 1, 2, 3];
    final esperado = mezcla.fold(0, (a, b) => a + b);
    expect(TestEstresPageState.calcularPuntuacion(mezcla), esperado);
    // Rango válido siempre entre 0 y 56.
    expect(TestEstresPageState.calcularPuntuacion(mezcla), inInclusiveRange(0, 56));
  });

  test('Cada nivel recibe entre 2 y 3 recomendaciones', () {
    const esperado = {NivelEstres.bajo: 2, NivelEstres.moderado: 3, NivelEstres.alto: 3};
    for (final nivel in NivelEstres.values) {
      final recomendaciones = recomendacionesPara(nivel);
      expect(
        recomendaciones.length,
        esperado[nivel],
        reason: 'Nivel ${nivel.etiqueta} debe tener ${esperado[nivel]} sugerencias',
      );
    }
    // Las 8 recomendaciones quedan repartidas entre los niveles.
    final usadas = NivelEstres.values
        .expand(recomendacionesPara)
        .map((r) => r.texto)
        .toSet();
    expect(usadas, hasLength(recomendacionesEstres.length));
  });

  test('agregar() guarda el resultado y notifica', () async {
    final notificaciones = <Object?>[];
    HistorialService.instancia.addListener(() => notificaciones.add(null));

    await HistorialService.instancia.agregar(
      ResultadoTest(
        id: '1',
        nombreTest: 'Estrés percibido (PSS)',
        puntuacion: 28,
        nivel: NivelEstres.moderado.aResultado,
        fecha: DateTime(2026, 11, 12, 10, 30),
      ),
    );

    expect(HistorialService.instancia.resultados, hasLength(1));
    expect(notificaciones, isNotEmpty);

    // Persiste y recarga en una instancia limpia (simulando reinicio).
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('historial_resultados'), contains('28'));
  });

  testWidgets('Historial vacío muestra el estado inicial', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: HistorialPage())));
    await tester.pump();
    expect(find.text('Aún no hay resultados'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Historial lista los resultados guardados', (tester) async {
    await HistorialService.instancia.agregar(
      ResultadoTest(
        id: '2',
        nombreTest: 'Estrés percibido (PSS)',
        puntuacion: 40,
        nivel: NivelEstres.desdePuntuacion(40).aResultado,
        fecha: DateTime(2026, 11, 12, 9, 15),
      ),
    );

    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: HistorialPage())));
    await tester.pump();

    expect(find.text('Mis resultados'), findsOneWidget);
    expect(find.text('1 guardado'), findsOneWidget);
    expect(find.text('Estrés percibido (PSS)'), findsOneWidget);
    expect(find.text('40/56'), findsOneWidget);
    expect(find.text('Estrés alto'), findsOneWidget);
    expect(find.text('12 nov 2026 · 09:15'), findsOneWidget);
  });

  testWidgets('Tocar un resultado del historial muestra la pantalla completa', (tester) async {
    await HistorialService.instancia.agregar(
      ResultadoTest(
        id: '3',
        nombreTest: 'Estrés percibido (PSS)',
        puntuacion: 40,
        nivel: NivelEstres.desdePuntuacion(40).aResultado,
        fecha: DateTime(2026, 11, 12, 9, 15),
      ),
    );

    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: HistorialPage())));
    await tester.pump();

    // Tocar la tarjeta del historial abre el detalle.
    await tester.tap(find.text('Estrés percibido (PSS)'));
    await tester.pumpAndSettle();

    // Se ve el mismo resultado que al terminar el test: puntuación + recomendaciones + botones.
    expect(find.text('Resultado'), findsOneWidget);
    expect(find.text('TU PUNTUACIÓN'), findsOneWidget);
    expect(find.text('40'), findsOneWidget);
    expect(find.text('de 56 puntos'), findsOneWidget);
    expect(find.text('Recomendaciones para estrés alto'), findsOneWidget);
    expect(find.text('Repetir'), findsOneWidget);
    expect(find.text('Finalizar'), findsOneWidget);

    // "Finalizar" cierra el detalle y regresa al historial.
    await tester.tap(find.text('Finalizar'));
    await tester.pumpAndSettle();
    expect(find.text('Mis resultados'), findsOneWidget);
  });

  test('GAD-7: la puntuación es la suma directa de las 7 respuestas (0 a 21)', () {
    // Sin ansiedad: todas las respuestas en 0 → 0 puntos.
    expect(TestGadPageState.calcularPuntuacion(List.filled(7, 0)), 0);
    // Máximo: todas las respuestas en 3 → 21 puntos.
    expect(TestGadPageState.calcularPuntuacion(List.filled(7, 3)), 21);
    // Mezcla de respuestas: se suman tal cual.
    const mezcla = [0, 1, 2, 3, 2, 1, 0];
    final esperado = mezcla.fold(0, (a, b) => a + b);
    expect(TestGadPageState.calcularPuntuacion(mezcla), esperado);
    expect(TestGadPageState.calcularPuntuacion(mezcla), inInclusiveRange(0, 21));
  });

  test('GAD-7: niveles según la interpretación oficial del puntaje', () {
    expect(NivelAnsiedad.desdePuntuacion(0), NivelAnsiedad.minimo);
    expect(NivelAnsiedad.desdePuntuacion(4), NivelAnsiedad.minimo);
    expect(NivelAnsiedad.desdePuntuacion(5), NivelAnsiedad.leve);
    expect(NivelAnsiedad.desdePuntuacion(9), NivelAnsiedad.leve);
    expect(NivelAnsiedad.desdePuntuacion(10), NivelAnsiedad.moderado);
    expect(NivelAnsiedad.desdePuntuacion(14), NivelAnsiedad.moderado);
    expect(NivelAnsiedad.desdePuntuacion(15), NivelAnsiedad.severo);
    expect(NivelAnsiedad.desdePuntuacion(21), NivelAnsiedad.severo);
  });

  test('GAD-7: cada nivel recibe entre 2 y 3 recomendaciones', () {
    const esperado = {
      NivelAnsiedad.minimo: 2,
      NivelAnsiedad.leve: 3,
      NivelAnsiedad.moderado: 3,
      NivelAnsiedad.severo: 2,
    };
    for (final nivel in NivelAnsiedad.values) {
      final recomendaciones = recomendacionesGadPara(nivel);
      expect(
        recomendaciones.length,
        esperado[nivel],
        reason: 'Nivel ${nivel.etiqueta} debe tener ${esperado[nivel]} sugerencias',
      );
    }
    // Las 10 recomendaciones quedan repartidas entre los niveles.
    final usadas = NivelAnsiedad.values
        .expand(recomendacionesGadPara)
        .map((r) => r.texto)
        .toSet();
    expect(usadas, hasLength(recomendacionesGad.length));
  });

  testWidgets('GAD-7: responder las 7 preguntas muestra la suma y se guarda', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: TestGadPage())));
    await tester.pumpAndSettle();

    // Responder "Varios días" (1 punto) en las 7 preguntas → total 7.
    for (var i = 0; i < TestGadPageState.totalPreguntas; i++) {
      final opcion = find.text('Varios días');
      await tester.ensureVisible(opcion);
      await tester.tap(opcion);
      await tester.pumpAndSettle();
      final boton = find.text(i == TestGadPageState.totalPreguntas - 1 ? 'Ver resultado' : 'Siguiente');
      await tester.ensureVisible(boton);
      await tester.tap(boton);
      await tester.pumpAndSettle();
    }

    expect(find.text('TU PUNTUACIÓN'), findsOneWidget);
    expect(find.text('7'), findsOneWidget);
    expect(find.text('de 21 puntos'), findsOneWidget);
    expect(find.text('Ansiedad leve'), findsOneWidget);

    // Queda guardado en el historial con su puntuación máxima y recomendaciones.
    final guardado = HistorialService.instancia.resultados;
    expect(guardado, hasLength(1));
    expect(guardado.first.nombreTest, TestGadPage.nombre);
    expect(guardado.first.puntuacion, 7);
    expect(guardado.first.maximo, 21);
    expect(guardado.first.recomendaciones, hasLength(3));
  });

  test('PHQ-9: la puntuación es la suma directa de las 9 respuestas (0 a 27)', () {
    // Sin síntomas: todas las respuestas en 0 → 0 puntos.
    expect(TestPhqPageState.calcularPuntuacion(List.filled(9, 0)), 0);
    // Máximo: todas las respuestas en 3 → 27 puntos.
    expect(TestPhqPageState.calcularPuntuacion(List.filled(9, 3)), 27);
    // Mezcla de respuestas: se suman tal cual.
    const mezcla = [0, 1, 2, 3, 2, 1, 0, 1, 2];
    final esperado = mezcla.fold(0, (a, b) => a + b);
    expect(TestPhqPageState.calcularPuntuacion(mezcla), esperado);
    expect(TestPhqPageState.calcularPuntuacion(mezcla), inInclusiveRange(0, 27));
  });

  test('PHQ-9: niveles según la tabla oficial de severidad', () {
    expect(NivelDepresion.desdePuntuacion(0), NivelDepresion.minimo);
    expect(NivelDepresion.desdePuntuacion(4), NivelDepresion.minimo);
    expect(NivelDepresion.desdePuntuacion(5), NivelDepresion.leve);
    expect(NivelDepresion.desdePuntuacion(9), NivelDepresion.leve);
    expect(NivelDepresion.desdePuntuacion(10), NivelDepresion.moderado);
    expect(NivelDepresion.desdePuntuacion(14), NivelDepresion.moderado);
    expect(NivelDepresion.desdePuntuacion(15), NivelDepresion.moderadoSevero);
    expect(NivelDepresion.desdePuntuacion(19), NivelDepresion.moderadoSevero);
    expect(NivelDepresion.desdePuntuacion(20), NivelDepresion.severo);
    expect(NivelDepresion.desdePuntuacion(27), NivelDepresion.severo);
  });

  test('PHQ-9: cada nivel recibe entre 2 y 3 recomendaciones', () {
    const esperado = {
      NivelDepresion.minimo: 2,
      NivelDepresion.leve: 2,
      NivelDepresion.moderado: 3,
      NivelDepresion.moderadoSevero: 2,
      NivelDepresion.severo: 2,
    };
    for (final nivel in NivelDepresion.values) {
      final recomendaciones = recomendacionesPhqPara(nivel);
      expect(
        recomendaciones.length,
        esperado[nivel],
        reason: 'Nivel ${nivel.etiqueta} debe tener ${esperado[nivel]} sugerencias',
      );
    }
    // Las 11 recomendaciones quedan repartidas entre los niveles.
    final usadas = NivelDepresion.values
        .expand(recomendacionesPhqPara)
        .map((r) => r.texto)
        .toSet();
    expect(usadas, hasLength(recomendacionesPhq.length));
  });

  test('UCLA-3: la puntuación suma de 3 a 9 (respuestas de 1 a 3)', () {
    // Todas en «Casi nunca» (1) → 3 puntos (mínimo posible).
    expect(TestUclaPageState.calcularPuntuacion([1, 1, 1]), 3);
    // Todas en «A menudo» (3) → 9 puntos (máximo).
    expect(TestUclaPageState.calcularPuntuacion([3, 3, 3]), 9);
    // Mezcla: se suman tal cual.
    const mezcla = [1, 2, 3];
    expect(TestUclaPageState.calcularPuntuacion(mezcla), 6);
    expect(TestUclaPageState.calcularPuntuacion([1, 1, 1]), TestUclaPageState.minimo);
    expect(TestUclaPageState.calcularPuntuacion([3, 3, 3]), TestUclaPageState.maximo);
  });

  test('UCLA-3: niveles según el agrupamiento oficial (3–5 / 6–9)', () {
    expect(NivelSoledad.desdePuntuacion(3), NivelSoledad.noSolitario);
    expect(NivelSoledad.desdePuntuacion(5), NivelSoledad.noSolitario);
    expect(NivelSoledad.desdePuntuacion(6), NivelSoledad.solitario);
    expect(NivelSoledad.desdePuntuacion(9), NivelSoledad.solitario);
  });

  test('UCLA-3: solo el puntaje elevado recibe las 12 recomendaciones', () {
    // 3–5 (no solitario): sin recomendaciones.
    expect(recomendacionesUclaPara(NivelSoledad.noSolitario), isEmpty);
    // 6–9 (solitario): las 12 sugerencias completas.
    final elevadas = recomendacionesUclaPara(NivelSoledad.solitario);
    expect(elevadas, hasLength(12));
    expect(elevadas, hasLength(recomendacionesUcla.length));
    // Y todas quedan reservadas para ese nivel.
    final usadas = NivelSoledad.values
        .expand(recomendacionesUclaPara)
        .map((r) => r.texto)
        .toSet();
    expect(usadas, hasLength(recomendacionesUcla.length));
  });

  test('WHO-5: la puntuación invertida va de 0 (buen estado) a 25 (crítico)', () {
    // «Todo el tiempo» en todo (suma oficial 25) → 0 puntos = buen estado.
    expect(TestWhoPageState.calcularPuntuacion([5, 5, 5, 5, 5]), 0);
    // «Nunca» en todo (suma oficial 0) → 25 puntos = estado crítico.
    expect(TestWhoPageState.calcularPuntuacion([0, 0, 0, 0, 0]), 25);
    // Mezcla: siempre 25 − suma oficial.
    const mezcla = [5, 4, 3, 2, 1];
    final sumaOficial = mezcla.fold(0, (a, b) => a + b);
    expect(TestWhoPageState.calcularPuntuacion(mezcla), 25 - sumaOficial);
    expect(TestWhoPageState.calcularPuntuacion(mezcla), inInclusiveRange(0, 25));
  });

  test('WHO-5: estados 0–8 bueno, 9–17 regular, 18–25 crítico', () {
    expect(NivelBienestar.desdePuntuacion(0), NivelBienestar.bueno);
    expect(NivelBienestar.desdePuntuacion(8), NivelBienestar.bueno);
    expect(NivelBienestar.desdePuntuacion(9), NivelBienestar.regular);
    expect(NivelBienestar.desdePuntuacion(17), NivelBienestar.regular);
    expect(NivelBienestar.desdePuntuacion(18), NivelBienestar.critico);
    expect(NivelBienestar.desdePuntuacion(25), NivelBienestar.critico);
  });

  test('WHO-5: las 12 recomendaciones se dispersan entre los 3 estados', () {
    const esperado = {
      NivelBienestar.bueno: 4,
      NivelBienestar.regular: 4,
      NivelBienestar.critico: 4,
    };
    for (final nivel in NivelBienestar.values) {
      final recomendaciones = recomendacionesWhoPara(nivel);
      expect(
        recomendaciones.length,
        esperado[nivel],
        reason: 'Estado ${nivel.etiqueta} debe tener ${esperado[nivel]} sugerencias',
      );
    }
    // Las 12 recomendaciones quedan repartidas entre los estados.
    final usadas = NivelBienestar.values
        .expand(recomendacionesWhoPara)
        .map((r) => r.texto)
        .toSet();
    expect(usadas, hasLength(recomendacionesWho.length));
    expect(recomendacionesWho, hasLength(12));
  });

  test('Todos los tests entregan recomendaciones para cada nivel que muestran', () {
    // PSS-14: los 3 niveles reciben sugerencias.
    for (final nivel in NivelEstres.values) {
      expect(recomendacionesPara(nivel), isNotEmpty, reason: 'PSS-14 ${nivel.etiqueta}');
    }
    // GAD-7: los 4 niveles reciben sugerencias.
    for (final nivel in NivelAnsiedad.values) {
      expect(recomendacionesGadPara(nivel), isNotEmpty, reason: 'GAD-7 ${nivel.etiqueta}');
    }
    // PHQ-9: los 5 niveles reciben sugerencias.
    for (final nivel in NivelDepresion.values) {
      expect(recomendacionesPhqPara(nivel), isNotEmpty, reason: 'PHQ-9 ${nivel.etiqueta}');
    }
    // UCLA-3: el nivel «solitario» recibe las 12 («no solitario» es vacío
    // por decisión del usuario).
    expect(recomendacionesUclaPara(NivelSoledad.solitario), hasLength(12));
    // WHO-5: los 3 estados reciben 4 sugerencias cada uno.
    for (final nivel in NivelBienestar.values) {
      expect(recomendacionesWhoPara(nivel), hasLength(4), reason: 'WHO-5 ${nivel.etiqueta}');
    }
    // Resiliencia: los 3 niveles reciben 3 sugerencias cada uno.
    for (final nivel in NivelResiliencia.values) {
      expect(recomendacionesResilienciaPara(nivel), hasLength(3), reason: 'CD-RISC-10 ${nivel.etiqueta}');
    }
    // ERQ: los 3 niveles reciben 5 sugerencias cada uno.
    for (final nivel in NivelRegulacion.values) {
      expect(recomendacionesRegulacionPara(nivel), hasLength(5), reason: 'ERQ ${nivel.etiqueta}');
    }
  });

  test('Cualquier puntuación de cada test produce recomendaciones de su nivel', () {
    // Recorre todas las puntuaciones posibles de cada test y verifica que
    // el nivel resultante tenga sugerencias (UCLA no solitario: vacío).
    for (var p = 0; p <= 56; p++) {
      final nivel = NivelEstres.desdePuntuacion(p);
      expect(recomendacionesPara(nivel), isNotEmpty, reason: 'PSS-14 con $p puntos');
    }
    for (var p = 0; p <= 21; p++) {
      final nivel = NivelAnsiedad.desdePuntuacion(p);
      expect(recomendacionesGadPara(nivel), isNotEmpty, reason: 'GAD-7 con $p puntos');
    }
    for (var p = 0; p <= 27; p++) {
      final nivel = NivelDepresion.desdePuntuacion(p);
      expect(recomendacionesPhqPara(nivel), isNotEmpty, reason: 'PHQ-9 con $p puntos');
    }
    for (var p = 3; p <= 9; p++) {
      final nivel = NivelSoledad.desdePuntuacion(p);
      final esperado = nivel == NivelSoledad.solitario ? 12 : 0;
      expect(recomendacionesUclaPara(nivel), hasLength(esperado), reason: 'UCLA-3 con $p puntos');
    }
    for (var p = 0; p <= 25; p++) {
      final nivel = NivelBienestar.desdePuntuacion(p);
      expect(recomendacionesWhoPara(nivel), hasLength(4), reason: 'WHO-5 con $p puntos');
    }
    for (var p = 0; p <= 40; p++) {
      final nivel = NivelResiliencia.desdePuntuacion(p);
      expect(recomendacionesResilienciaPara(nivel), hasLength(3), reason: 'CD-RISC-10 con $p puntos');
    }
    for (var p = 10; p <= 70; p++) {
      final nivel = NivelRegulacion.desdePuntuacion(p);
      expect(recomendacionesRegulacionPara(nivel), hasLength(5), reason: 'ERQ con $p puntos');
    }
  });

  test('Historial: un resultado antiguo sin recomendaciones se recalcula por su test', () {
    // Estrés (formato antiguo: id de nivel como texto).
    expect(
      ResultadoDetallePage.recomendacionesDe(nombreTest: TestEstresPage.nombre, puntuacion: 40, idNivel: 'alto'),
      hasLength(3),
    );
    // GAD-7 no debe recibir recomendaciones de estrés.
    final gad = ResultadoDetallePage.recomendacionesDe(nombreTest: TestGadPage.nombre, puntuacion: 16, idNivel: 'severo');
    expect(gad, hasLength(2));
    expect(gad, recomendacionesGadPara(NivelAnsiedad.severo).map((r) => r.texto));
    // PHQ-9 por id y, si falta, por puntuación.
    expect(
      ResultadoDetallePage.recomendacionesDe(nombreTest: TestPhqPage.nombre, puntuacion: 12, idNivel: 'moderado'),
      hasLength(3),
    );
    expect(
      ResultadoDetallePage.recomendacionesDe(nombreTest: TestPhqPage.nombre, puntuacion: 12, idNivel: 'desconocido'),
      hasLength(3),
    );
    // UCLA-3: nivel solitario → 12; no solitario → ninguna.
    expect(
      ResultadoDetallePage.recomendacionesDe(nombreTest: TestUclaPage.nombre, puntuacion: 8, idNivel: 'solitario'),
      hasLength(12),
    );
    expect(
      ResultadoDetallePage.recomendacionesDe(nombreTest: TestUclaPage.nombre, puntuacion: 4, idNivel: 'noSolitario'),
      isEmpty,
    );
    // WHO-5: cada estado con sus 4.
    expect(
      ResultadoDetallePage.recomendacionesDe(nombreTest: TestWhoPage.nombre, puntuacion: 20, idNivel: 'critico'),
      hasLength(4),
    );
    expect(
      ResultadoDetallePage.recomendacionesDe(nombreTest: TestWhoPage.nombre, puntuacion: 3, idNivel: 'bueno'),
      hasLength(4),
    );
    // Resiliencia (CD-RISC-10).
    expect(
      ResultadoDetallePage.recomendacionesDe(nombreTest: TestResilienciaPage.nombre, puntuacion: 20, idNivel: 'baja'),
      hasLength(3),
    );
    expect(
      ResultadoDetallePage.recomendacionesDe(nombreTest: TestResilienciaPage.nombre, puntuacion: 38, idNivel: 'alta'),
      hasLength(3),
    );
    // ERQ.
    expect(
      ResultadoDetallePage.recomendacionesDe(nombreTest: TestErqPage.nombre, puntuacion: 25, idNivel: 'bajo'),
      hasLength(5),
    );
    expect(
      ResultadoDetallePage.recomendacionesDe(nombreTest: TestErqPage.nombre, puntuacion: 60, idNivel: 'alto'),
      hasLength(5),
    );
  });

  test('CD-RISC-10: la puntuación es la suma directa de los 10 ítems (0 a 40)', () {
    // En absoluto en todo → 0 puntos.
    expect(TestResilienciaPageState.calcularPuntuacion(List.filled(10, 0)), 0);
    // Casi siempre en todo → 40 puntos.
    expect(TestResilienciaPageState.calcularPuntuacion(List.filled(10, 4)), 40);
    // Mezcla de respuestas: se suman tal cual.
    const mezcla = [0, 1, 2, 3, 4, 0, 1, 2, 3, 4];
    final esperado = mezcla.fold(0, (a, b) => a + b);
    expect(TestResilienciaPageState.calcularPuntuacion(mezcla), esperado);
    expect(TestResilienciaPageState.calcularPuntuacion(mezcla), inInclusiveRange(0, 40));
    expect(TestResilienciaPageState.calcularPuntuacion(mezcla), TestResilienciaPageState.maximo ~/ 2);
  });

  test('CD-RISC-10: niveles según los cortes ≤27 baja, 28–35 moderada, ≥36 alta', () {
    expect(NivelResiliencia.desdePuntuacion(0), NivelResiliencia.baja);
    expect(NivelResiliencia.desdePuntuacion(27), NivelResiliencia.baja);
    expect(NivelResiliencia.desdePuntuacion(28), NivelResiliencia.moderada);
    expect(NivelResiliencia.desdePuntuacion(35), NivelResiliencia.moderada);
    expect(NivelResiliencia.desdePuntuacion(36), NivelResiliencia.alta);
    expect(NivelResiliencia.desdePuntuacion(40), NivelResiliencia.alta);
    // Las 9 recomendaciones quedan repartidas entre los niveles.
    final usadas = NivelResiliencia.values
        .expand(recomendacionesResilienciaPara)
        .map((r) => r.texto)
        .toSet();
    expect(usadas, hasLength(recomendacionesResiliencia.length));
    expect(recomendacionesResiliencia, hasLength(9));
  });

  testWidgets('CD-RISC-10: responder los 10 ítems muestra la suma y se guarda', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: TestResilienciaPage())));
    await tester.pumpAndSettle();

    // Responder «Casi siempre» (4 puntos) en los 10 ítems → total 40.
    for (var i = 0; i < TestResilienciaPageState.totalPreguntas; i++) {
      final opcion = find.text('Casi siempre');
      await tester.ensureVisible(opcion);
      await tester.tap(opcion);
      await tester.pumpAndSettle();
      final boton = find.text(i == TestResilienciaPageState.totalPreguntas - 1 ? 'Ver resultado' : 'Siguiente');
      await tester.ensureVisible(boton);
      await tester.tap(boton);
      await tester.pumpAndSettle();
    }

    expect(find.text('TU PUNTUACIÓN'), findsOneWidget);
    expect(find.text('40'), findsOneWidget);
    expect(find.text('de 40 puntos'), findsOneWidget);
    expect(find.text('Resiliencia alta'), findsOneWidget);
    expect(find.text('Recomendaciones para resiliencia alta'), findsOneWidget);

    // Queda guardado en el historial con su puntuación máxima y recomendaciones.
    final guardado = HistorialService.instancia.resultados;
    expect(guardado, hasLength(1));
    expect(guardado.first.nombreTest, TestResilienciaPage.nombre);
    expect(guardado.first.puntuacion, 40);
    expect(guardado.first.maximo, 40);
    expect(guardado.first.recomendaciones, hasLength(3));
  });

  test('ERQ: la puntuación total es la suma de los 10 ítems (10 a 70)', () {
    // «Totalmente en desacuerdo» en todo → 10 puntos (mínimo).
    expect(TestErqPageState.calcularPuntuacion(List.filled(10, 1)), 10);
    // «Totalmente de acuerdo» en todo → 70 puntos (máximo).
    expect(TestErqPageState.calcularPuntuacion(List.filled(10, 7)), 70);
    // Mezcla: se suman tal cual.
    const mezcla = [1, 2, 3, 4, 5, 6, 7, 1, 2, 3];
    final esperado = mezcla.fold(0, (a, b) => a + b);
    expect(TestErqPageState.calcularPuntuacion(mezcla), esperado);
    expect(TestErqPageState.calcularPuntuacion(mezcla), inInclusiveRange(10, 70));
  });

  test('ERQ: los subíndices separan reelaboración (6 ítems) y supresión (4)', () {
    // Respuestas 1..7 repartidas: cada subescala suma sus ítems.
    const respuestas = [1, 2, 3, 4, 5, 6, 7, 1, 2, 3];
    // Reelaboración: ítems 1, 3, 5, 7, 8, 10 → índices 0,2,4,6,7,9.
    expect(TestErqPageState.reelaboracion(respuestas), 1 + 3 + 5 + 7 + 1 + 3);
    // Supresión: ítems 2, 4, 6, 9 → índices 1,3,5,8.
    expect(TestErqPageState.supresion(respuestas), 2 + 4 + 6 + 2);
    // Los dos subíndices suman la puntuación total.
    expect(
      TestErqPageState.reelaboracion(respuestas) + TestErqPageState.supresion(respuestas),
      TestErqPageState.calcularPuntuacion(respuestas),
    );
    // Rangos propios de cada subescala.
    expect(TestErqPageState.reelaboracion(List.filled(10, 1)), 6);
    expect(TestErqPageState.reelaboracion(List.filled(10, 7)), 42);
    expect(TestErqPageState.supresion(List.filled(10, 1)), 4);
    expect(TestErqPageState.supresion(List.filled(10, 7)), 28);
    expect(TestErqPageState.itemsReelaboracion, hasLength(6));
    expect(TestErqPageState.itemsSupresion, hasLength(4));
  });

  test('ERQ: niveles 10–29 bajo, 30–49 moderado, 50–70 alto', () {
    expect(NivelRegulacion.desdePuntuacion(10), NivelRegulacion.bajo);
    expect(NivelRegulacion.desdePuntuacion(29), NivelRegulacion.bajo);
    expect(NivelRegulacion.desdePuntuacion(30), NivelRegulacion.moderado);
    expect(NivelRegulacion.desdePuntuacion(49), NivelRegulacion.moderado);
    expect(NivelRegulacion.desdePuntuacion(50), NivelRegulacion.alto);
    expect(NivelRegulacion.desdePuntuacion(70), NivelRegulacion.alto);
    // Las 15 recomendaciones quedan repartidas entre los niveles.
    final usadas = NivelRegulacion.values
        .expand(recomendacionesRegulacionPara)
        .map((r) => r.texto)
        .toSet();
    expect(usadas, hasLength(recomendacionesRegulacion.length));
    expect(recomendacionesRegulacion, hasLength(15));
  });

  test('ERQ: la interpretación muestra los dos subíndices', () {
    const reel = 24; // uso moderado (21–34)
    const sup = 9; //  uso bajo (4–11)
    final descripcion = NivelRegulacion.moderado.descripcionCon(
      reelaboracion: reel,
      supresion: sup,
    );
    expect(descripcion, contains('Reelaboración cognitiva: 24 de 42 (uso moderado)'));
    expect(descripcion, contains('Supresión expresiva: 9 de 28 (uso bajo)'));
    // El nivel alto con subíndices extremos también queda bien descrito.
    final alto = NivelRegulacion.alto.descripcionCon(reelaboracion: 42, supresion: 28);
    expect(alto, contains('Reelaboración cognitiva: 42 de 42 (uso alto)'));
    expect(alto, contains('Supresión expresiva: 28 de 28 (uso alto)'));
  });

  testWidgets('ERQ: responder los 10 ítems muestra la suma y se guarda', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: TestErqPage())));
    await tester.pumpAndSettle();

    // Responder «Totalmente de acuerdo» (7 puntos) en los 10 ítems → total 70.
    for (var i = 0; i < TestErqPageState.totalPreguntas; i++) {
      final opcion = find.text('Totalmente de acuerdo');
      await tester.ensureVisible(opcion);
      await tester.tap(opcion);
      await tester.pumpAndSettle();
      final boton = find.text(i == TestErqPageState.totalPreguntas - 1 ? 'Ver resultado' : 'Siguiente');
      await tester.ensureVisible(boton);
      await tester.tap(boton);
      await tester.pumpAndSettle();
    }

    expect(find.text('TU PUNTUACIÓN'), findsOneWidget);
    expect(find.text('70'), findsOneWidget);
    expect(find.text('de 70 puntos'), findsOneWidget);
    expect(find.text('Regulación emocional alta'), findsOneWidget);
    expect(find.text('Recomendaciones para mantener tu regulación emocional'), findsOneWidget);
    // Los dos subíndices aparecen en la interpretación.
    expect(find.textContaining('Reelaboración cognitiva: 42 de 42'), findsOneWidget);
    expect(find.textContaining('Supresión expresiva: 28 de 28'), findsOneWidget);

    // Queda guardado en el historial con su puntuación máxima y recomendaciones.
    final guardado = HistorialService.instancia.resultados;
    expect(guardado, hasLength(1));
    expect(guardado.first.nombreTest, TestErqPage.nombre);
    expect(guardado.first.puntuacion, 70);
    expect(guardado.first.maximo, 70);
    expect(guardado.first.recomendaciones, hasLength(5));
    expect(guardado.first.nivel.descripcion, contains('Reelaboración cognitiva'));
  });
}