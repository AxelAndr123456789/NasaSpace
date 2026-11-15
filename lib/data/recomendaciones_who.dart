import '../models/resultado_test_model.dart';

/// Recomendaciones de afrontamiento del bienestar (WHO-5) para astronautas.
///
/// Las 12 recomendaciones quedan dispersas entre los tres estados
/// (4 en cada uno):
///   - Buen estado (4):     mantenimiento de hábitos de bienestar.
///   - Estado regular (4):  herramientas para sostener y mejorar el ánimo.
///   - Estado crítico (4):  conexión, apoyo emocional y acompañamiento.
class RecomendacionWho {
  const RecomendacionWho({required this.texto, required this.niveles});

  final String texto;

  /// Estados para los cuales esta recomendación se sugiere.
  final Set<NivelBienestar> niveles;

  bool aplicaA(NivelBienestar nivel) => niveles.contains(nivel);
}

/// Las 12 recomendaciones, en su orden original.
const List<RecomendacionWho> recomendacionesWho = [
  // 1 · Buen estado (mantenimiento).
  RecomendacionWho(
    texto:
        'Incorporar actividades agradables en la rutina diaria. Programar diariamente actividades recreativas que generen satisfacción, como leer, escuchar música, dibujar, observar la Tierra desde las ventanas de la nave o disfrutar de una película. Priorizar actividades que resulten personalmente significativas.',
    niveles: {NivelBienestar.bueno},
  ),
  // 2 · Buen estado (mantenimiento).
  RecomendacionWho(
    texto:
        'Mantener una rutina de actividad física. Realizar ejercicio de acuerdo con el programa físico de la misión y las indicaciones médicas. La actividad física regular puede contribuir a mejorar el estado de ánimo, la energía y la sensación de vitalidad.',
    niveles: {NivelBienestar.bueno},
  ),
  // 3 · Estado regular (herramientas de regulación).
  RecomendacionWho(
    texto:
        'Practicar técnicas de relajación y atención plena. Dedicar entre 5 y 10 minutos a ejercicios de respiración consciente, meditación guiada o relajación muscular progresiva. Estas prácticas pueden favorecer la tranquilidad y ayudar a gestionar la tensión acumulada.',
    niveles: {NivelBienestar.regular},
  ),
  // 4 · Estado regular (motivación y propósito).
  RecomendacionWho(
    texto:
        'Establecer objetivos personales alcanzables. Definir pequeñas metas diarias y semanales relacionadas con el aprendizaje, el trabajo, la recreación o el desarrollo personal. Reconocer los avances permite fortalecer la percepción de eficacia y propósito.',
    niveles: {NivelBienestar.regular},
  ),
  // 5 · Estado crítico (conexión afectiva).
  RecomendacionWho(
    texto:
        'Fortalecer los vínculos afectivos. Reservar momentos para comunicarse con familiares y amistades mediante los canales disponibles durante la misión. Compartir experiencias, emociones y acontecimientos cotidianos puede favorecer la conexión emocional y el bienestar.',
    niveles: {NivelBienestar.critico},
  ),
  // 6 · Estado regular (convivencia con la tripulación).
  RecomendacionWho(
    texto:
        'Promover interacciones positivas con la tripulación. Participar en comidas compartidas, actividades recreativas, conversaciones informales y celebraciones grupales. Procurar mantener espacios de convivencia que no estén relacionados exclusivamente con las responsabilidades operativas.',
    niveles: {NivelBienestar.regular},
  ),
  // 7 · Buen estado (mantenimiento).
  RecomendacionWho(
    texto:
        'Regular los horarios de sueño y descanso. Mantener, en la medida de lo posible, horarios consistentes de sueño y vigilia, respetar los periodos de descanso y realizar actividades relajantes antes de dormir. Comunicar al equipo médico cualquier dificultad persistente que afecte la recuperación o el funcionamiento diario.',
    niveles: {NivelBienestar.bueno},
  ),
  // 8 · Buen estado (mantenimiento).
  RecomendacionWho(
    texto:
        'Practicar el reconocimiento de experiencias positivas. Al finalizar cada jornada, identificar tres acontecimientos agradables, logros personales o situaciones por las que se sienta agradecimiento. Registrar estas experiencias en un diario puede ayudar a dirigir la atención hacia aspectos satisfactorios de la vida cotidiana.',
    niveles: {NivelBienestar.bueno},
  ),
  // 9 · Estado crítico (conexión con lo significativo).
  RecomendacionWho(
    texto:
        'Favorecer el contacto con experiencias significativas. Incorporar fotografías, música, grabaciones, lecturas y objetos personales autorizados que permitan mantener una conexión con los intereses, recuerdos y personas importantes para cada integrante de la tripulación.',
    niveles: {NivelBienestar.critico},
  ),
  // 10 · Estado crítico (expresión emocional).
  RecomendacionWho(
    texto:
        'Identificar y expresar las necesidades emocionales. Reconocer cambios en el estado de ánimo, disminución del interés, agotamiento o dificultades para disfrutar de las actividades. Compartir estas experiencias con personas de confianza y solicitar apoyo cuando sea necesario.',
    niveles: {NivelBienestar.critico},
  ),
  // 11 · Estado regular (equilibrio laboral y recuperación).
  RecomendacionWho(
    texto:
        'Alternar las exigencias laborales con momentos de recuperación. Organizar pausas breves entre actividades, respetar los tiempos de descanso y distribuir las tareas de acuerdo con las prioridades de la misión. Evitar que la rutina esté compuesta exclusivamente por actividades operativas.',
    niveles: {NivelBienestar.regular},
  ),
  // 12 · Estado crítico (acompañamiento profesional).
  RecomendacionWho(
    texto:
        'Solicitar acompañamiento psicológico ante un deterioro persistente del bienestar. Cuando la disminución del bienestar se mantenga, se intensifique o interfiera con las relaciones interpersonales, el desempeño o las actividades cotidianas, solicitar una evaluación por parte del equipo de salud mental. Las estrategias de autocuidado pueden complementar, pero no sustituir, la atención profesional.',
    niveles: {NivelBienestar.critico},
  ),
];

/// Recomendaciones que aplican para un estado dado, en orden original.
/// Siempre 4 por estado (4 + 4 + 4 = 12).
List<RecomendacionWho> recomendacionesWhoPara(NivelBienestar nivel) =>
    recomendacionesWho.where((r) => r.aplicaA(nivel)).toList();
