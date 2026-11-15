import '../models/resultado_test_model.dart';

/// Recomendaciones de afrontamiento de la resiliencia (CD-RISC-10) para
/// astronautas.
///
/// Cada nivel recibe 3 sugerencias (3 + 3 + 3 = 9):
///   - Baja (3):       construcción de recursos de afrontamiento.
///   - Moderada (3):   refuerzo de los recursos existentes.
///   - Alta (3):       mantenimiento y transmisión al equipo.
class RecomendacionResiliencia {
  const RecomendacionResiliencia({required this.texto, required this.niveles});

  final String texto;

  /// Niveles para los cuales esta recomendación se sugiere.
  final Set<NivelResiliencia> niveles;

  bool aplicaA(NivelResiliencia nivel) => niveles.contains(nivel);
}

/// Las 9 recomendaciones, en su orden original.
const List<RecomendacionResiliencia> recomendacionesResiliencia = [
  // 1 · Baja (red de apoyo).
  RecomendacionResiliencia(
    texto:
        'Construir una red de apoyo a bordo: Identifica a dos o tres compañeros con quienes puedas conversar con confianza y procura comunicarte con ellos de forma regular. Contar con personas disponibles reduce la sensación de aislamiento y facilita el afrontamiento de los problemas.',
    niveles: {NivelResiliencia.baja},
  ),
  // 2 · Baja (afrontamiento gradual).
  RecomendacionResiliencia(
    texto:
        'Afrontar los problemas paso a paso: Ante una situación difícil, divídela en acciones pequeñas y concretas y resuelve primero las que dependan de ti. Este enfoque reduce la sensación de abrumo y devuelve una mayor sensación de control.',
    niveles: {NivelResiliencia.baja},
  ),
  // 3 · Baja (recuperar confianza).
  RecomendacionResiliencia(
    texto:
        'Recuperar la confianza recordando logros anteriores: Dedica unos minutos a escribir tres dificultades que has superado y cómo lo lograste. Revisar tus experiencias exitosas ayuda a reconocer tus propias fortalezas frente a los nuevos desafíos.',
    niveles: {NivelResiliencia.baja},
  ),
  // 4 · Moderada (diálogo interno).
  RecomendacionResiliencia(
    texto:
        'Reforzar el diálogo interno positivo: Cuando cometas un error, sustituye las autocríticas duras por un lenguaje más equilibrado y constructivo. Hablarte con la misma consideración con la que hablarías a un compañero favorece la recuperación después del fracaso.',
    niveles: {NivelResiliencia.moderada},
  ),
  // 5 · Moderada (reencuadre humorístico).
  RecomendacionResiliencia(
    texto:
        'Practicar el reencuadre humorístico: Ante contratiempos, busca deliberadamente su lado cómico o una perspectiva más liviana. La capacidad de reírse de las pequeñas adversidades modula la tensión y mejora la convivencia durante la misión.',
    niveles: {NivelResiliencia.moderada},
  ),
  // 6 · Moderada (autocuidado).
  RecomendacionResiliencia(
    texto:
        'Sostener los hábitos de autocuidado: Mantén horarios regulares de sueño, el programa de actividad física de la misión y una alimentación adecuada. El descanso y la energía física sostienen la capacidad de concentración y la tolerancia a la presión.',
    niveles: {NivelResiliencia.moderada},
  ),
  // 7 · Alta (mantenimiento).
  RecomendacionResiliencia(
    texto:
        'Mantener tus rutinas de afrontamiento: Conserva las prácticas que te han funcionado, como la planificación, el ejercicio o el contacto con seres queridos, incluso cuando todo marche bien. La resiliencia se sostiene con hábitos constantes, no solo en situaciones críticas.',
    niveles: {NivelResiliencia.alta},
  ),
  // 8 · Alta (transmisión al equipo).
  RecomendacionResiliencia(
    texto:
        'Compartir tus estrategias con la tripulación: Ofrece tu apoyo y explica cómo manejas la presión o los contratiempos a compañeros que lo estén pasando más difícil. Enseñar tus recursos refuerza tu propio sentido de competencia y fortalece al equipo.',
    niveles: {NivelResiliencia.alta},
  ),
  // 9 · Alta (preparación anticipada).
  RecomendacionResiliencia(
    texto:
        'Prepararte con antelación para los momentos críticos: Antes de fases exigentes de la misión, anticipa escenarios difíciles y define con tiempo tu plan de acción y tus señales de alerta. Estar preparado reduce el impacto del imprevisto y mantiene tu foco bajo presión.',
    niveles: {NivelResiliencia.alta},
  ),
];

/// Recomendaciones que aplican para un nivel dado, en orden original.
/// Siempre 3 por nivel (3 + 3 + 3 = 9).
List<RecomendacionResiliencia> recomendacionesResilienciaPara(NivelResiliencia nivel) =>
    recomendacionesResiliencia.where((r) => r.aplicaA(nivel)).toList();
