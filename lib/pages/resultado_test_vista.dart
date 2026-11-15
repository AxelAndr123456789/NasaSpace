import 'package:flutter/material.dart';

import '../models/resultado_test_model.dart';
import '../services/app_theme.dart';

/// Pantalla de resultado de un test: tarjeta de puntuación, interpretación
/// del nivel, recomendaciones y botones Repetir / Finalizar.
///
/// Se muestra al terminar el test y también al abrir un resultado guardado
/// desde el historial, para que sea idéntica en ambos casos.
class ResultadoTestVista extends StatelessWidget {
  const ResultadoTestVista({
    super.key,
    required this.puntuacion,
    required this.maximo,
    required this.nivel,
    required this.recomendaciones,
    required this.onReiniciar,
    required this.onFinalizar,
  });

  /// Puntuación directa obtenida.
  final int puntuacion;

  /// Puntuación máxima posible del test (56 en la PSS-14, 21 en la GAD-7).
  final int maximo;

  /// Nivel con su etiqueta, color e interpretación.
  final NivelResultado nivel;

  /// Textos de las recomendaciones (2 o 3) para ese nivel.
  final List<String> recomendaciones;

  /// Vuelve a empezar el test.
  final VoidCallback onReiniciar;

  /// Cierra la pantalla de resultado.
  final VoidCallback onFinalizar;

  @override
  Widget build(BuildContext context) {
    final colorNivel = nivel.color;
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      gradient: AppTheme.heroGradient,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [BoxShadow(color: AppColors.navy.withValues(alpha: .2), blurRadius: 20, offset: const Offset(0, 9))],
                    ),
                    child: Column(
                      children: [
                        const Text('TU PUNTUACIÓN', style: TextStyle(color: AppColors.cyan, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
                        const SizedBox(height: 10),
                        Text('$puntuacion', style: const TextStyle(color: Colors.white, fontSize: 52, fontWeight: FontWeight.w800, height: 1)),
                        Text('de $maximo puntos', style: TextStyle(color: Colors.white.withValues(alpha: .7), fontSize: 13, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(color: colorNivel.withValues(alpha: .22), borderRadius: BorderRadius.circular(20), border: Border.all(color: colorNivel.withValues(alpha: .6))),
                          child: Text(nivel.etiqueta, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)),
                        ),
                        const SizedBox(height: 12),
                        Text(nivel.descripcion, textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withValues(alpha: .82), fontSize: 13, height: 1.45)),
                      ],
                    ),
                  ),
                  if (recomendaciones.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    // Recomendaciones clasificadas según el nivel obtenido.
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: colorNivel.withValues(alpha: .45)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.tips_and_updates_rounded, size: 18, color: colorNivel),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(nivel.tituloRecomendaciones, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.navyDark)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text('${recomendaciones.length} sugerencias personalizadas', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.navy.withValues(alpha: .55))),
                          const SizedBox(height: 12),
                          for (var i = 0; i < recomendaciones.length; i++) ...[
                            _Recomendacion(
                              numero: i + 1,
                              texto: recomendaciones[i],
                              color: colorNivel,
                            ),
                            if (i < recomendaciones.length - 1) const SizedBox(height: 10),
                          ],
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: onReiniciar,
                icon: const Icon(Icons.refresh_rounded, size: 17),
                label: const Text('Repetir'),
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
                  onPressed: onFinalizar,
                  icon: const Icon(Icons.check_rounded, size: 18),
                  label: const Text('Finalizar'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.navy,
                    foregroundColor: Colors.white,
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

class _Recomendacion extends StatelessWidget {
  const _Recomendacion({required this.numero, required this.texto, required this.color});

  final int numero;
  final String texto;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: color.withValues(alpha: .18), shape: BoxShape.circle),
          child: Text('$numero', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.navy)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(texto, style: TextStyle(fontSize: 12.5, height: 1.45, color: AppColors.navy.withValues(alpha: .75))),
        ),
      ],
    );
  }
}
