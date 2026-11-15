import '../models/resultado_test_model.dart';

/// Recomendaciones de afrontamiento de la regulación emocional (ERQ) para
/// astronautas.
///
/// El ERQ puntúa el uso de dos estrategias (reelaboración cognitiva y
/// supresión expresiva) y aquí la puntuación principal es la suma total.
/// Cada nivel recibe 5 sugerencias (5 + 5 + 5 = 15):
///   - Bajo (5):      iniciarse en estrategias de regulación.
///   - Moderado (5):  ampliar y equilibrar el repertorio.
///   - Alto (5):      mantener y afinar el uso de las estrategias.
class RecomendacionRegulacion {
  const RecomendacionRegulacion({required this.texto, required this.niveles});

  final String texto;

  /// Niveles para los cuales esta recomendación se sugiere.
  final Set<NivelRegulacion> niveles;

  bool aplicaA(NivelRegulacion nivel) => niveles.contains(nivel);
}

/// Las 15 recomendaciones, en su orden original.
const List<RecomendacionRegulacion> recomendacionesRegulacion = [
  // 1 · Bajo (identificar emociones).
  RecomendacionRegulacion(
    texto:
        'Identificar y poner nombre a lo que sientes: Dedica unos minutos al día a reconocer la emoción que estás experimentando y a nombrarla con precisión (tristeza, enfado, frustración, alegría). Poder nombrar una emoción es el primer paso para regularla.',
    niveles: {NivelRegulacion.bajo},
  ),
  // 2 · Bajo (respiración).
  RecomendacionRegulacion(
    texto:
        'Practicar una técnica básica de calma: Cuando notes tensión, realiza respiraciones lentas durante dos o tres minutos, prestando atención a la inhalación y la exhalación. Es una estrategia sencilla que puedes usar antes de que la emoción se intensifique.',
    niveles: {NivelRegulacion.bajo},
  ),
  // 3 · Bajo (reelaboración inicial).
  RecomendacionRegulacion(
    texto:
        'Reformular una situación al día: Cuando algo te incomode, busca deliberadamente otra manera de interpretar lo ocurrido, considerando explicaciones alternativas y lo que puedes aprender de la experiencia. Con la práctica, este recurso se vuelve automático.',
    niveles: {NivelRegulacion.bajo},
  ),
  // 4 · Bajo (expresión).
  RecomendacionRegulacion(
    texto:
        'Expresar lo que sientes a alguien de confianza: Comparte con un compañero de tripulación o con el equipo de apoyo cómo te has sentido durante el día. Hablar de las emociones reduce su intensidad y evita que se acumulen.',
    niveles: {NivelRegulacion.bajo},
  ),
  // 5 · Bajo (actividad agradable).
  RecomendacionRegulacion(
    texto:
        'Reservar un momento agradable cada día: Programa una actividad que te guste, como leer, escuchar música, dibujar o mirar la Tierra desde la ventanilla. Las experiencias positivas sencillas ayudan a recuperar el equilibrio emocional.',
    niveles: {NivelRegulacion.bajo},
  ),
  // 6 · Moderado (ampliar repertorio).
  RecomendacionRegulacion(
    texto:
        'Ampliar tu repertorio de estrategias: Alterna la reformulación cognitiva con otras herramientas como actividad física, escritura reflexiva o ejercicios de atención plena. Contar con varias opciones evita que una sola estrategia deje de funcionar.',
    niveles: {NivelRegulacion.moderado},
  ),
  // 7 · Moderado (reelaboración bajo presión).
  RecomendacionRegulacion(
    texto:
        'Reelaborar antes de reaccionar: En situaciones exigentes de la misión, pausa un instante y pregúntate cómo podrías mirar el problema desde otra perspectiva antes de responder. Pensar con claridad primero reduce las reacciones impulsivas.',
    niveles: {NivelRegulacion.moderado},
  ),
  // 8 · Moderado (equilibrio expresión/ocultación).
  RecomendacionRegulacion(
    texto:
        'Equilibrar lo que expresas y lo que guardas: No todas las situaciones piden mostrar ni ocultar las emociones. Valora si conviene expresar lo que sientes ahora, más tarde o a otra persona, y reserva la contención para los momentos que la requieran.',
    niveles: {NivelRegulacion.moderado},
  ),
  // 9 · Moderado (diario emocional).
  RecomendacionRegulacion(
    texto:
        'Llevar un registro emocional breve: Anota al final de la jornada qué emoción predominó, qué la desencadenó y cómo la manejaste. Revisar tus registros te permite descubrir patrones y estrategias que ya te funcionan bien.',
    niveles: {NivelRegulacion.moderado},
  ),
  // 10 · Moderado (objetivos emocionales).
  RecomendacionRegulacion(
    texto:
        'Fijarte una meta emocional concreta: Elige una estrategia para trabajar durante la semana, por ejemplo reformular los pensamientos negativos antes de dormir o expresar algo que sueles callarte. Un objetivo pequeño y medible facilita el cambio sostenido.',
    niveles: {NivelRegulacion.moderado},
  ),
  // 11 · Alto (mantenimiento).
  RecomendacionRegulacion(
    texto:
        'Mantener tus estrategias en los momentos tranquilos: Continúa practicando la reformulación y la expresión adecuada de tus emociones incluso cuando todo marche bien. Las estrategias bien entrenadas responden mejor cuando llega la presión.',
    niveles: {NivelRegulacion.alto},
  ),
  // 12 · Alto (evitar la sobre-regulación).
  RecomendacionRegulacion(
    texto:
        'Evitar regular en exceso: Si siempre buscas controlar o posponer tus emociones, permítete sentirlas sin juzgarlas algunas veces. Las emociones desagradables también aportan información útil y ceden solas si no las combates.',
    niveles: {NivelRegulacion.alto},
  ),
  // 13 · Alto (ajustar la supresión).
  RecomendacionRegulacion(
    texto:
        'Cuidar la expresión emocional con la tripulación: Cuando contengas una emoción por convivencia o protocolo, busca después un espacio adecuado para procesarla, conversando con alguien de confianza o escribiéndola. Ocultar sin procesar agota recursos.',
    niveles: {NivelRegulacion.alto},
  ),
  // 14 · Alto (ensayar escenarios).
  RecomendacionRegulacion(
    texto:
        'Ensayar respuestas ante escenarios difíciles: Antes de fases exigentes de la misión, imagina situaciones estresantes y decide de antemano cómo vas a interpretarlas y qué harás. Preparar la respuesta emocional mejora el rendimiento bajo presión.',
    niveles: {NivelRegulacion.alto},
  ),
  // 15 · Alto (acompañamiento).
  RecomendacionRegulacion(
    texto:
        'Aprovechar tu buena regulación para apoyar al equipo: Comparte con tus compañeros las estrategias que te funcionan y ofréceles escucha sin juzgar. Además, solicita apoyo profesional si detectas que gestionas toda la misión demasiado a la defensiva.',
    niveles: {NivelRegulacion.alto},
  ),
];

/// Recomendaciones que aplican para un nivel dado, en orden original.
/// Siempre 5 por nivel (5 + 5 + 5 = 15).
List<RecomendacionRegulacion> recomendacionesRegulacionPara(NivelRegulacion nivel) =>
    recomendacionesRegulacion.where((r) => r.aplicaA(nivel)).toList();
