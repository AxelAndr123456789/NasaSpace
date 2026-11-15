import 'package:flutter/material.dart';

import '../data/recomendaciones_regulacion.dart';
import '../models/resultado_test_model.dart';
import '../services/app_theme.dart';
import '../services/historial_service.dart';
import 'resultado_test_vista.dart';

/// Cuestionario de Regulación Emocional (ERQ; Canales et al. 2023;
/// versión original de Gross y John, 2003).
///
/// Los 10 ítems se responden con una escala de 1 a 7 (Totalmente en
/// desacuerdo = 1 … Totalmente de acuerdo = 7). La puntuación principal
/// es la suma total de los 10 ítems (10 a 70).
///
/// El ERQ evalúa además dos estrategias por separado, que se muestran en
/// la interpretación del resultado:
///   - Reelaboración cognitiva: ítems 1, 3, 5, 7, 8 y 10 (6 a 42).
///   - Supresión expresiva: ítems 2, 4, 6 y 9 (4 a 28).
class TestErqPage extends StatefulWidget {
  const TestErqPage({super.key});

  /// Nombre con el que queda guardado en el historial.
  static const nombre = 'Regulación emocional (ERQ)';

  @override
  State<TestErqPage> createState() => TestErqPageState();
}

class TestErqPageState extends State<TestErqPage> {
  static const totalPreguntas = 10;

  /// Puntuación mínima y máxima: 10 respuestas de 1 a 7.
  static const minimo = 10;
  static const maximo = 70;

  /// Ítems de cada subescala (índices base 0).
  static const itemsReelaboracion = [0, 2, 4, 6, 7, 9];
  static const itemsSupresion = [1, 3, 5, 8];

  static const preguntas = <String>[
    'Cuando quiero incrementar mis emociones positivas (p.ej. alegría, diversión), cambio el tema sobre el que estoy pensando.',
    'Guardo mis emociones para mí mismo.',
    'Cuando quiero reducir mis emociones negativas (p.ej. tristeza, enfado), cambio el tema sobre el que estoy pensando.',
    'Cuando estoy sintiendo emociones positivas, tengo cuidado de no expresarlas.',
    'Cuando me enfrento a una situación estresante, intento pensar en ella de un modo que me ayude a mantener la calma.',
    'Controlo mis emociones no expresándolas.',
    'Cuando quiero incrementar mis emociones positivas, cambio mi manera de pensar sobre la situación.',
    'Controlo mis emociones cambiando mi forma de pensar sobre la situación en la que me encuentro.',
    'Cuando estoy sintiendo emociones negativas, me aseguro de no expresarlas.',
    'Cuando quiero reducir mis emociones negativas, cambio mi manera de pensar sobre la situación.',
  ];

  /// Escala de 7 puntos de la tabla del cuestionario.
  static const opciones = <String>[
    'Totalmente en desacuerdo',
    'En desacuerdo',
    'Ligeramente en desacuerdo',
    'Ni acuerdo ni en desacuerdo',
    'Ligeramente de acuerdo',
    'De acuerdo',
    'Totalmente de acuerdo',
  ];

  /// Valor oficial de cada opción: Totalmente en desacuerdo = 1 …
  /// Totalmente de acuerdo = 7.
  static int valorOpcion(int indice) => indice + 1;

  /// Puntuación total: suma directa de los 10 ítems (1 a 7 cada uno).
  /// Todas en 1 → 10 puntos; todas en 7 → 70 puntos.
  static int calcularPuntuacion(List<int> respuestas) {
    var total = 0;
    for (final respuesta in respuestas) {
      total += respuesta;
    }
    return total;
  }

  /// Subíndice de reelaboración cognitiva: suma de los ítems 1, 3, 5, 7,
  /// 8 y 10 (6 a 42). Cuanto más alto, más se usa esta estrategia.
  static int reelaboracion(List<int> respuestas) {
    var total = 0;
    for (final i in itemsReelaboracion) {
      total += respuestas[i];
    }
    return total;
  }

  /// Subíndice de supresión expresiva: suma de los ítems 2, 4, 6 y 9
  /// (4 a 28). Cuanto más alto, más se contiene la expresión emocional.
  static int supresion(List<int> respuestas) {
    var total = 0;
    for (final i in itemsSupresion) {
      total += respuestas[i];
    }
    return total;
  }

  int _actual = 0;
  final List<int?> _respuestas = List<int?>.filled(totalPreguntas, null);
  bool _mostrandoResultado = false;
  bool _guardado = false;

  List<int> get _respuestasCompletas => [for (final r in _respuestas) r!];

  void _seleccionar(int valor) {
    setState(() => _respuestas[_actual] = valor);
  }

  void _siguiente() {
    if (_respuestas[_actual] == null) return;
    setState(() {
      if (_actual == totalPreguntas - 1) {
        _mostrandoResultado = true;
      } else {
        _actual++;
      }
    });
    // Al terminar el cuestionario, guarda el resultado en el historial.
    if (_mostrandoResultado && !_guardado) {
      _guardado = true;
      final respuestas = _respuestasCompletas;
      final puntuacion = calcularPuntuacion(respuestas);
      final nivel = NivelRegulacion.desdePuntuacion(puntuacion);
      HistorialService.instancia.agregar(
        ResultadoTest(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          nombreTest: TestErqPage.nombre,
          puntuacion: puntuacion,
          nivel: nivel.aResultado(
            reelaboracion: reelaboracion(respuestas),
            supresion: supresion(respuestas),
          ),
          fecha: DateTime.now(),
          maximo: maximo,
          recomendaciones: [for (final r in recomendacionesRegulacionPara(nivel)) r.texto],
        ),
      );
    }
  }

  void _anterior() {
    if (_actual == 0) return;
    setState(() => _actual--);
  }

  void _reiniciar() {
    setState(() {
      _actual = 0;
      _respuestas.fillRange(0, totalPreguntas, null);
      _mostrandoResultado = false;
      _guardado = false;
    });
  }

  /// Pantalla de resultado con la puntuación total, la interpretación
  /// (que incluye los dos subíndices) y las recomendaciones.
  Widget _vistaResultado() {
    final respuestas = _respuestasCompletas;
    final puntuacion = calcularPuntuacion(respuestas);
    final nivel = NivelRegulacion.desdePuntuacion(puntuacion);
    return ResultadoTestVista(
      puntuacion: puntuacion,
      maximo: maximo,
      nivel: nivel.aResultado(
        reelaboracion: reelaboracion(respuestas),
        supresion: supresion(respuestas),
      ),
      recomendaciones: [for (final r in recomendacionesRegulacionPara(nivel)) r.texto],
      onReiniciar: _reiniciar,
      onFinalizar: () => Navigator.of(context).pop(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_mostrandoResultado ? 'Resultado' : TestErqPage.nombre),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: _mostrandoResultado
            ? _vistaResultado()
            : _PreguntaVista(
                indice: _actual,
                pregunta: preguntas[_actual],
                respuesta: _respuestas[_actual],
                onSeleccionar: _seleccionar,
                onAnterior: _actual == 0 ? null : _anterior,
                onSiguiente: _siguiente,
              ),
      ),
    );
  }
}

class _PreguntaVista extends StatelessWidget {
  const _PreguntaVista({
    required this.indice,
    required this.pregunta,
    required this.respuesta,
    required this.onSeleccionar,
    required this.onAnterior,
    required this.onSiguiente,
  });

  final int indice;
  final String pregunta;
  final int? respuesta;
  final ValueChanged<int> onSeleccionar;
  final VoidCallback? onAnterior;
  final VoidCallback onSiguiente;

  @override
  Widget build(BuildContext context) {
    const total = TestErqPageState.totalPreguntas;
    final opciones = TestErqPageState.opciones;
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Pregunta ${indice + 1} de $total', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.navyDark)),
              const Spacer(),
              Text('${((indice + 1) / total * 100).round()}%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.navy.withValues(alpha: .55))),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: (indice + 1) / total,
              minHeight: 9,
              backgroundColor: AppColors.navy.withValues(alpha: .08),
              color: AppColors.cyan,
            ),
          ),
          const SizedBox(height: 22),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(17),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.navy.withValues(alpha: .07)),
                      boxShadow: [BoxShadow(color: AppColors.navy.withValues(alpha: .045), blurRadius: 14, offset: const Offset(0, 5))],
                    ),
                    child: Text(pregunta, style: const TextStyle(fontSize: 16, height: 1.5, fontWeight: FontWeight.w700, color: AppColors.navyDark)),
                  ),
                  const SizedBox(height: 18),
                  const Text('Marca tu grado de acuerdo con esta frase:', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.navy)),
                  const SizedBox(height: 12),
                  for (var i = 0; i < opciones.length; i++) ...[
                    _Opcion(
                      etiqueta: opciones[i],
                      valor: TestErqPageState.valorOpcion(i),
                      seleccionada: respuesta == TestErqPageState.valorOpcion(i),
                      onTap: () => onSeleccionar(TestErqPageState.valorOpcion(i)),
                    ),
                    const SizedBox(height: 10),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: onAnterior,
                icon: const Icon(Icons.arrow_back_rounded, size: 17),
                label: const Text('Anterior'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.navy,
                  side: BorderSide(color: AppColors.navy.withValues(alpha: .25)),
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                  textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: respuesta == null ? null : onSiguiente,
                  icon: Icon(indice == total - 1 ? Icons.assessment_rounded : Icons.arrow_forward_rounded, size: 18),
                  label: Text(indice == total - 1 ? 'Ver resultado' : 'Siguiente'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.navy,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.navy.withValues(alpha: .3),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Opcion extends StatelessWidget {
  const _Opcion({required this.etiqueta, required this.valor, required this.seleccionada, required this.onTap});

  final String etiqueta;
  final int valor;
  final bool seleccionada;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: seleccionada ? AppColors.cyan.withValues(alpha: .16) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: seleccionada ? AppColors.cyan : AppColors.navy.withValues(alpha: .12),
            width: seleccionada ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: seleccionada ? AppColors.navy : AppColors.navy.withValues(alpha: .06),
                shape: BoxShape.circle,
              ),
              child: Text('$valor', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: seleccionada ? Colors.white : AppColors.navy)),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(etiqueta, style: TextStyle(fontSize: 14, fontWeight: seleccionada ? FontWeight.w800 : FontWeight.w600, color: AppColors.navyDark))),
            if (seleccionada) const Icon(Icons.check_circle_rounded, size: 20, color: AppColors.cyan),
          ],
        ),
      ),
    );
  }
}
