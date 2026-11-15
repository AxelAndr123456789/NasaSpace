import 'package:flutter/material.dart';

import '../data/recomendaciones_who.dart';
import '../models/resultado_test_model.dart';
import '../services/app_theme.dart';
import '../services/historial_service.dart';
import 'resultado_test_vista.dart';

/// WHO (Five) Well Being Index (1998) / OMS (cinco) Índice de Bienestar.
///
/// Las 5 afirmaciones positivas se puntúan con la escala oficial
/// (Nunca = 0 … Todo el tiempo = 5) y la puntuación mostrada se calcula
/// como `25 − suma` para que 0 sea el buen estado y 25 el estado crítico,
/// igual que en los demás tests de la app.
///
/// Rangos: 0–8 buen estado · 9–17 estado regular · 18–25 estado crítico.
class TestWhoPage extends StatefulWidget {
  const TestWhoPage({super.key});

  /// Nombre con el que queda guardado en el historial.
  static const nombre = 'Bienestar (WHO-5)';

  @override
  State<TestWhoPage> createState() => TestWhoPageState();
}

class TestWhoPageState extends State<TestWhoPage> {
  static const totalPreguntas = 5;

  /// Puntuación máxima posible (estado crítico).
  static const maximo = 25;

  static const preguntas = <String>[
    'En las últimas 2 semanas, ¿con qué frecuencia te has sentido alegre y de buen humor?',
    'En las últimas 2 semanas, ¿con qué frecuencia te has sentido tranquilo y relajado?',
    'En las últimas 2 semanas, ¿con qué frecuencia te has sentido activo y enérgico?',
    'En las últimas 2 semanas, ¿con qué frecuencia te has despertado fresco y descansado?',
    'En las últimas 2 semanas, ¿con qué frecuencia tu vida cotidiana ha estado llena de cosas que te interesan?',
  ];

  /// Opciones en el orden de la tabla oficial: de mayor a menor frecuencia.
  static const opciones = <String>[
    'Todo el tiempo',
    'La mayor parte del tiempo',
    'Más de la mitad del tiempo',
    'Menos de la mitad del tiempo',
    'De vez en cuando',
    'Nunca',
  ];

  /// Valor oficial de cada opción: Todo el tiempo = 5 … Nunca = 0.
  static int valorOpcion(int indice) => 5 - indice;

  /// Puntuación mostrada: `25 − suma oficial`.
  /// «Todo el tiempo» en todo → 0 puntos (buen estado);
  /// «Nunca» en todo → 25 puntos (estado crítico).
  static int calcularPuntuacion(List<int> respuestas) {
    var sumaOficial = 0;
    for (final respuesta in respuestas) {
      sumaOficial += respuesta;
    }
    return maximo - sumaOficial;
  }

  int _actual = 0;
  final List<int?> _respuestas = List<int?>.filled(totalPreguntas, null);
  bool _mostrandoResultado = false;
  bool _guardado = false;

  int get _puntuacion => calcularPuntuacion([for (final r in _respuestas) r!]);

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
      final puntuacion = _puntuacion;
      final nivel = NivelBienestar.desdePuntuacion(puntuacion);
      HistorialService.instancia.agregar(
        ResultadoTest(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          nombreTest: TestWhoPage.nombre,
          puntuacion: puntuacion,
          nivel: nivel.aResultado,
          fecha: DateTime.now(),
          maximo: maximo,
          recomendaciones: [for (final r in recomendacionesWhoPara(nivel)) r.texto],
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

  /// Pantalla de resultado con la puntuación, el estado y las recomendaciones.
  Widget _vistaResultado() {
    final nivel = NivelBienestar.desdePuntuacion(_puntuacion);
    return ResultadoTestVista(
      puntuacion: _puntuacion,
      maximo: maximo,
      nivel: nivel.aResultado,
      recomendaciones: [for (final r in recomendacionesWhoPara(nivel)) r.texto],
      onReiniciar: _reiniciar,
      onFinalizar: () => Navigator.of(context).pop(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_mostrandoResultado ? 'Resultado' : TestWhoPage.nombre),
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
    const total = TestWhoPageState.totalPreguntas;
    final opciones = TestWhoPageState.opciones;
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
                  const Text('Marca qué define mejor cómo te has sentido:', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.navy)),
                  const SizedBox(height: 12),
                  for (var i = 0; i < opciones.length; i++) ...[
                    _Opcion(
                      etiqueta: opciones[i],
                      valor: TestWhoPageState.valorOpcion(i),
                      seleccionada: respuesta == TestWhoPageState.valorOpcion(i),
                      onTap: () => onSeleccionar(TestWhoPageState.valorOpcion(i)),
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
