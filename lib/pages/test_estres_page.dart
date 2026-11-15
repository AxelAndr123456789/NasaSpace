import 'package:flutter/material.dart';

import '../data/recomendaciones_estres.dart';
import '../models/resultado_test_model.dart';
import '../services/app_theme.dart';
import '../services/historial_service.dart';
import 'resultado_test_vista.dart';

/// Escala de Estrés Percibido (PSS) de Cohen, S., Kamarck, T., & Mermelstein, R. (1983),
/// versión española (2.0) adaptada por el Dr. Eduardo Remor. Cuestionario completo de 14 ítems.
///
/// Cada respuesta se puntúa de 0 a 4 y la puntuación total es la suma directa
/// de las 14 respuestas (0 a 56): 0 = perfectas condiciones, 56 = estado crítico.
/// A mayor puntaje, mayor nivel de estrés percibido.
class TestEstresPage extends StatefulWidget {
  const TestEstresPage({super.key});

  /// Nombre con el que queda guardado en el historial.
  static const nombre = 'Estrés percibido (PSS)';

  @override
  State<TestEstresPage> createState() => TestEstresPageState();
}

class TestEstresPageState extends State<TestEstresPage> {
  static const totalPreguntas = 14;

  /// Puntuación máxima posible: 14 respuestas de 0 a 4.
  static const maximo = 56;

  static const preguntas = <String>[
    'En el último mes, ¿con qué frecuencia ha estado afectado por algo que le ha ocurrido inesperadamente?',
    'En el último mes, ¿con qué frecuencia se ha sentido incapaz de controlar las cosas importantes en su vida?',
    'En el último mes, ¿con qué frecuencia se ha sentido nervioso o estresado?',
    'En el último mes, ¿con qué frecuencia ha manejado con éxito los pequeños problemas o incidencias que han ido surgiendo?',
    'En el último mes, ¿con qué frecuencia ha sentido que ha afrontado efectivamente los cambios importantes que han estado ocurriendo en su vida?',
    'En el último mes, ¿con qué frecuencia ha estado seguro sobre su capacidad para manejar sus problemas personales?',
    'En el último mes, ¿con qué frecuencia ha sentido que las cosas le van bien?',
    'En el último mes, ¿con qué frecuencia ha sentido que no podía afrontar todas las cosas que tenía que hacer?',
    'En el último mes, ¿con qué frecuencia ha podido controlar las dificultades de su vida?',
    'En el último mes, ¿con qué frecuencia se ha sentido que tenía todo bajo control?',
    'En el último mes, ¿con qué frecuencia ha estado enfadado porque las cosas que le han ocurrido estaban fuera de su control?',
    'En el último mes, ¿con qué frecuencia ha pensado sobre las cosas que le quedan por hacer?',
    'En el último mes, ¿con qué frecuencia ha podido controlar la forma de pasar el tiempo?',
    'En el último mes, ¿con qué frecuencia ha sentido que las dificultades se acumulan tanto que no puede superarlas?',
  ];

  static const opciones = <String>['Nunca', 'Casi nunca', 'De vez en cuando', 'A menudo', 'Muy a menudo'];

  int _actual = 0;
  final List<int?> _respuestas = List<int?>.filled(totalPreguntas, null);
  bool _mostrandoResultado = false;
  bool _guardado = false;

  /// Puntuación total: suma directa de las 14 respuestas (0 a 4 cada una).
  /// Todas en 0 → 0 puntos (mejor caso); todas en 4 → 56 (estado crítico).
  static int calcularPuntuacion(List<int> respuestas) {
    var total = 0;
    for (final respuesta in respuestas) {
      total += respuesta;
    }
    return total;
  }

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
      final nivel = NivelEstres.desdePuntuacion(puntuacion);
      HistorialService.instancia.agregar(
        ResultadoTest(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          nombreTest: TestEstresPage.nombre,
          puntuacion: puntuacion,
          nivel: nivel.aResultado,
          fecha: DateTime.now(),
          maximo: maximo,
          recomendaciones: [for (final r in recomendacionesPara(nivel)) r.texto],
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

  /// Pantalla de resultado con la puntuación, el nivel y las recomendaciones.
  Widget _vistaResultado() {
    final nivel = NivelEstres.desdePuntuacion(_puntuacion);
    return ResultadoTestVista(
      puntuacion: _puntuacion,
      maximo: maximo,
      nivel: nivel.aResultado,
      recomendaciones: [for (final r in recomendacionesPara(nivel)) r.texto],
      onReiniciar: _reiniciar,
      onFinalizar: () => Navigator.of(context).pop(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_mostrandoResultado ? 'Resultado' : TestEstresPage.nombre),
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
    const total = TestEstresPageState.totalPreguntas;
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
                  const Text('Marca cómo te has sentido o pensado:', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.navy)),
                  const SizedBox(height: 12),
                  for (var i = 0; i < 5; i++) ...[
                    _Opcion(
                      etiqueta: TestEstresPageState.opciones[i],
                      valor: i,
                      seleccionada: respuesta == i,
                      onTap: () => onSeleccionar(i),
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
