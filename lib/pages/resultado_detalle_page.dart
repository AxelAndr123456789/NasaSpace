import 'package:flutter/material.dart';

import '../data/recomendaciones_estres.dart';
import '../data/recomendaciones_gad.dart';
import '../data/recomendaciones_phq.dart';
import '../data/recomendaciones_regulacion.dart';
import '../data/recomendaciones_resiliencia.dart';
import '../data/recomendaciones_ucla.dart';
import '../data/recomendaciones_who.dart';
import '../models/resultado_test_model.dart';
import 'resultado_test_vista.dart';
import 'test_erq_page.dart';
import 'test_estres_page.dart';
import 'test_gad_page.dart';
import 'test_phq_page.dart';
import 'test_resiliencia_page.dart';
import 'test_ucla_page.dart';
import 'test_who_page.dart';

/// Resultado guardado que se muestra al tocar una tarjeta del historial.
///
/// Reproduce exactamente la misma pantalla que aparece al terminar el test:
/// puntuación, interpretación, recomendaciones y botones Repetir / Finalizar.
class ResultadoDetallePage extends StatelessWidget {
  const ResultadoDetallePage({super.key, required this.resultado});

  final ResultadoTest resultado;

  /// Recomendaciones guardadas con el resultado. Los resultados antiguos
  /// (anteriores a guardarlas) se recalculan según el test al que
  /// pertenecen, de modo que cada test muestre sus propias sugerencias.
  List<String> _recomendaciones() {
    if (resultado.recomendaciones.isNotEmpty) return resultado.recomendaciones;
    return ResultadoDetallePage.recomendacionesDe(
      nombreTest: resultado.nombreTest,
      puntuacion: resultado.puntuacion,
      idNivel: resultado.nivel.id,
    );
  }

  /// Recalcula las recomendaciones de un resultado antiguo guardado sin
  /// ellas, usando el test y el nivel (o la puntuación) que se muestran.
  static List<String> recomendacionesDe({
    required String nombreTest,
    required int puntuacion,
    required String idNivel,
  }) {
    switch (nombreTest) {
      case TestGadPage.nombre:
        final nivel = NivelAnsiedad.desdeId(idNivel) ?? NivelAnsiedad.desdePuntuacion(puntuacion);
        return [for (final r in recomendacionesGadPara(nivel)) r.texto];
      case TestPhqPage.nombre:
        final nivel = NivelDepresion.desdeId(idNivel) ?? NivelDepresion.desdePuntuacion(puntuacion);
        return [for (final r in recomendacionesPhqPara(nivel)) r.texto];
      case TestUclaPage.nombre:
        final nivel = NivelSoledad.desdeId(idNivel) ?? NivelSoledad.desdePuntuacion(puntuacion);
        return [for (final r in recomendacionesUclaPara(nivel)) r.texto];
      case TestWhoPage.nombre:
        final nivel = NivelBienestar.desdeId(idNivel) ?? NivelBienestar.desdePuntuacion(puntuacion);
        return [for (final r in recomendacionesWhoPara(nivel)) r.texto];
      case TestResilienciaPage.nombre:
        final nivel = NivelResiliencia.desdeId(idNivel) ?? NivelResiliencia.desdePuntuacion(puntuacion);
        return [for (final r in recomendacionesResilienciaPara(nivel)) r.texto];
      case TestErqPage.nombre:
        final nivel = NivelRegulacion.desdeId(idNivel) ?? NivelRegulacion.desdePuntuacion(puntuacion);
        return [for (final r in recomendacionesRegulacionPara(nivel)) r.texto];
      default:
        // Estrés (PSS): tanto el id antiguo ('bajo'…) como la puntuación.
        final nivel = NivelEstres.desdeId(idNivel) ?? NivelEstres.desdePuntuacion(puntuacion);
        return [for (final r in recomendacionesPara(nivel)) r.texto];
    }
  }

  /// Página del test al que pertenece este resultado (para "Repetir").
  Widget _paginaTest() {
    if (resultado.nombreTest == TestGadPage.nombre) return const TestGadPage();
    if (resultado.nombreTest == TestPhqPage.nombre) return const TestPhqPage();
    if (resultado.nombreTest == TestUclaPage.nombre) return const TestUclaPage();
    if (resultado.nombreTest == TestWhoPage.nombre) return const TestWhoPage();
    if (resultado.nombreTest == TestResilienciaPage.nombre) return const TestResilienciaPage();
    if (resultado.nombreTest == TestErqPage.nombre) return const TestErqPage();
    return const TestEstresPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: ResultadoTestVista(
          puntuacion: resultado.puntuacion,
          maximo: resultado.maximo,
          nivel: resultado.nivel,
          recomendaciones: _recomendaciones(),
          // "Repetir" desde el historial: reemplaza el detalle por un test nuevo.
          onReiniciar: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(builder: (_) => _paginaTest()),
          ),
          // "Finalizar" cierra el detalle y vuelve a la lista del historial.
          onFinalizar: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}
