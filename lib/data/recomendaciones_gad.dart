import '../models/resultado_test_model.dart';

/// Recomendaciones de afrontamiento de la ansiedad (GAD-7) para astronautas.
///
/// Cada nivel recibe entre 2 y 3 sugerencias (2 + 3 + 3 + 2 = 10):
///   - Mínimo (2):     mantenimiento del bienestar.
///   - Leve (3):       herramientas de relajación inmediata.
///   - Moderado (3):   trabajo sobre la preocupación.
///   - Moderada a severa (2): regulación intensa y apoyo interpersonal.
class RecomendacionAnsiedad {
  const RecomendacionAnsiedad({required this.texto, required this.niveles});

  final String texto;

  /// Niveles para los cuales esta recomendación se sugiere.
  final Set<NivelAnsiedad> niveles;

  bool aplicaA(NivelAnsiedad nivel) => niveles.contains(nivel);
}

/// Las 10 recomendaciones, en su orden original.
const List<RecomendacionAnsiedad> recomendacionesGad = [
  // 1 · Mínimo (mantenimiento).
  RecomendacionAnsiedad(
    texto:
        'Práctica de mindfulness: Dedica unos minutos al día a ejercicios de atención plena. Concéntrate en tu respiración y en las sensaciones del momento presente, procurando observar tus pensamientos sin juzgarlos. Esta práctica puede ayudarte a gestionar las preocupaciones relacionadas con las exigencias de la misión.',
    niveles: {NivelAnsiedad.minimo},
  ),
  // 2 · Leve (relajación inmediata).
  RecomendacionAnsiedad(
    texto:
        'Respiración diafragmática: Cuando experimentes nerviosismo o tensión, realiza respiraciones lentas y cómodas, procurando que el abdomen se expanda suavemente al inhalar. Mantén la atención en el ritmo respiratorio durante unos minutos para favorecer la relajación.',
    niveles: {NivelAnsiedad.leve},
  ),
  // 3 · Moderado (trabajo sobre la preocupación).
  RecomendacionAnsiedad(
    texto:
        'Identificación de pensamientos anticipatorios: Cuando aparezcan preocupaciones sobre posibles acontecimientos negativos, identifica qué estás pensando y diferencia los hechos comprobables de las situaciones que solamente estás anticipando. Esto puede ayudarte a desarrollar una respuesta más equilibrada ante la incertidumbre.',
    niveles: {NivelAnsiedad.moderado},
  ),
  // 4 · Moderada a severa (conexión con el presente).
  RecomendacionAnsiedad(
    texto:
        'Técnicas de grounding: Si experimentas preocupación intensa o dificultad para concentrarte en el presente, realiza un ejercicio de conexión con el entorno. Identifica mentalmente cinco elementos que puedas observar, cuatro sensaciones físicas y tres sonidos que puedas escuchar. Esta actividad puede ayudarte a orientar nuevamente tu atención hacia el momento presente.',
    niveles: {NivelAnsiedad.severo},
  ),
  // 5 · Leve (relajación muscular).
  RecomendacionAnsiedad(
    texto:
        'Relajación muscular progresiva: Dedica unos minutos a identificar las zonas de tu cuerpo donde acumulas tensión, como los hombros, las manos y la mandíbula. Alterna suavemente la contracción y relajación de diferentes grupos musculares, siempre que las condiciones físicas y operacionales lo permitan.',
    niveles: {NivelAnsiedad.leve},
  ),
  // 6 · Moderado (organización de las preocupaciones).
  RecomendacionAnsiedad(
    texto:
        'Organización de las preocupaciones: Reserva un momento específico para identificar y registrar las situaciones que te generan inquietud. Clasifícalas según su importancia y posibilidad de intervención, estableciendo acciones concretas para aquellas que puedan resolverse. Esto puede evitar que las preocupaciones interfieran constantemente con tus actividades.',
    niveles: {NivelAnsiedad.moderado},
  ),
  // 7 · Mínimo (rutinas de descanso).
  RecomendacionAnsiedad(
    texto:
        'Establecimiento de rutinas de descanso: Procura mantener horarios regulares de sueño y descanso de acuerdo con el cronograma de la misión. Evita realizar actividades estimulantes inmediatamente antes de dormir y utiliza técnicas de relajación para facilitar la transición hacia el descanso.',
    niveles: {NivelAnsiedad.minimo},
  ),
  // 8 · Moderada a severa (apoyo interpersonal).
  RecomendacionAnsiedad(
    texto:
        'Comunicación y apoyo interpersonal: Comparte tus preocupaciones con compañeros de tripulación o profesionales de apoyo psicológico cuando lo necesites. Expresar tus inquietudes y escuchar otras perspectivas puede ayudarte a manejar situaciones emocionalmente exigentes.',
    niveles: {NivelAnsiedad.severo},
  ),
  // 9 · Moderado (tolerancia a la incertidumbre).
  RecomendacionAnsiedad(
    texto:
        'Tolerancia a la incertidumbre: Reconoce que durante una misión espacial pueden existir acontecimientos difíciles de anticipar. En lugar de intentar controlar todas las posibilidades, concentra tu atención en los procedimientos establecidos y en las acciones que puedes realizar en el presente.',
    niveles: {NivelAnsiedad.moderado},
  ),
  // 10 · Leve (pausas de regulación emocional).
  RecomendacionAnsiedad(
    texto:
        'Pausas de regulación emocional: Cuando las actividades de la misión lo permitan, realiza pausas breves para desconectarte de las demandas operacionales. Puedes escuchar música, practicar respiración consciente o realizar alguna actividad recreativa que favorezca tu bienestar.',
    niveles: {NivelAnsiedad.leve},
  ),
];

/// Recomendaciones que aplican para un nivel dado, en orden original.
/// Siempre entre 2 y 3 por nivel.
List<RecomendacionAnsiedad> recomendacionesGadPara(NivelAnsiedad nivel) =>
    recomendacionesGad.where((r) => r.aplicaA(nivel)).toList();
