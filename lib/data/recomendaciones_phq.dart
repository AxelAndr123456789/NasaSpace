import '../models/resultado_test_model.dart';

/// Recomendaciones de afrontamiento de la depresión (PHQ-9) para astronautas.
///
/// Cada nivel recibe entre 2 y 3 sugerencias (2 + 2 + 3 + 2 + 2 = 11):
///   - Ninguno o mínimo (2): mantenimiento del bienestar.
///   - Leve (2):             activación y estructura diaria.
///   - Moderado (3):         herramientas activas de ánimo y energía.
///   - Moderadamente severo (2): expresión emocional y autocompasión.
///   - Severo (2):           vínculos y apoyo interpersonal.
class RecomendacionPhq {
  const RecomendacionPhq({required this.texto, required this.niveles});

  final String texto;

  /// Niveles para los cuales esta recomendación se sugiere.
  final Set<NivelDepresion> niveles;

  bool aplicaA(NivelDepresion nivel) => niveles.contains(nivel);
}

/// Las 11 recomendaciones, en su orden original.
const List<RecomendacionPhq> recomendacionesPhq = [
  // 1 · Leve (activación conductual).
  RecomendacionPhq(
    texto:
        'Activación conductual: Procura incorporar actividades agradables y significativas dentro de tu rutina diaria, siempre que las condiciones de la misión lo permitan. Puedes dedicar tiempo a escuchar música, leer, dibujar o realizar actividades recreativas. Mantener espacios de disfrute puede contribuir a recuperar la motivación y el interés por las actividades cotidianas.',
    niveles: {NivelDepresion.leve},
  ),
  // 2 · Leve (estructura diaria).
  RecomendacionPhq(
    texto:
        'Establecimiento de rutinas saludables: Mantén una estructura diaria que contemple horarios de trabajo, alimentación, descanso y recreación. Contar con una rutina organizada puede favorecer la estabilidad emocional y proporcionar una mayor sensación de continuidad durante la misión.',
    niveles: {NivelDepresion.leve},
  ),
  // 3 · Moderado (ánimo y energía).
  RecomendacionPhq(
    texto:
        'Actividad física adaptada: Incorpora ejercicios físicos de acuerdo con los protocolos y programas de acondicionamiento establecidos para la misión. La actividad física regular puede favorecer el estado de ánimo, contribuir a disminuir la fatiga y mejorar el bienestar general.',
    niveles: {NivelDepresion.moderado},
  ),
  // 4 · Severo (vínculos afectivos).
  RecomendacionPhq(
    texto:
        'Fortalecimiento de los vínculos afectivos: Aprovecha las oportunidades de comunicación con familiares y personas significativas. Compartir experiencias, expresar emociones y mantener contacto con tus seres queridos puede ayudarte a conservar una sensación de conexión durante los periodos de aislamiento.',
    niveles: {NivelDepresion.severo},
  ),
  // 5 · Moderado (percepción de eficacia).
  RecomendacionPhq(
    texto:
        'Reconocimiento de logros personales: Dedica unos minutos a reconocer las actividades que has completado satisfactoriamente durante el día, incluso aquellas que parecen pequeñas. Registrar tus avances puede ayudarte a fortalecer la percepción de eficacia personal y reconocer tus capacidades frente a las exigencias de la misión.',
    niveles: {NivelDepresion.moderado},
  ),
  // 6 · Ninguno o mínimo (mantenimiento).
  RecomendacionPhq(
    texto:
        'Higiene del sueño: Procura mantener horarios de descanso regulares, respetando las pautas de sueño establecidas para la misión. Cuando sea posible, reduce la exposición a estímulos que dificulten el descanso y utiliza actividades relajantes antes de dormir.',
    niveles: {NivelDepresion.minimo},
  ),
  // 7 · Moderadamente severo (expresión emocional).
  RecomendacionPhq(
    texto:
        'Expresión emocional: Busca espacios adecuados para reconocer y expresar tus emociones. Puedes utilizar un diario personal para registrar tus experiencias, preocupaciones y pensamientos. Identificar lo que estás sintiendo puede facilitar la comprensión de tus necesidades emocionales y la búsqueda de apoyo.',
    niveles: {NivelDepresion.moderadoSevero},
  ),
  // 8 · Severo (apoyo entre compañeros).
  RecomendacionPhq(
    texto:
        'Fortalecimiento del apoyo entre compañeros: Mantén una comunicación respetuosa y cercana con los integrantes de la tripulación. Participar en actividades compartidas, ofrecer ayuda y expresar tus necesidades puede favorecer el sentido de pertenencia y disminuir la sensación de aislamiento.',
    niveles: {NivelDepresion.severo},
  ),
  // 9 · Moderadamente severo (autocompasión).
  RecomendacionPhq(
    texto:
        'Autocompasión y autovaloración: Procura mantener una actitud comprensiva hacia ti mismo durante los momentos de dificultad. Reconoce que experimentar cansancio, frustración o desmotivación no significa que hayas perdido tus capacidades. Evita establecer expectativas excesivamente exigentes y reconoce tus esfuerzos.',
    niveles: {NivelDepresion.moderadoSevero},
  ),
  // 10 · Ninguno o mínimo (mantenimiento).
  RecomendacionPhq(
    texto:
        'Conexión con experiencias significativas: Cuando sea posible, dedica tiempo a actividades que te permitan mantener contacto con tus intereses, valores y experiencias personales. Puedes observar fotografías, escuchar música significativa o realizar actividades creativas que favorezcan la conexión con tu identidad y tu vida fuera de la misión.',
    niveles: {NivelDepresion.minimo},
  ),
  // 11 · Moderado (relajación).
  RecomendacionPhq(
    texto:
        'Técnicas de relajación: Si experimentas tensión emocional, puedes realizar ejercicios de respiración consciente, relajación muscular progresiva o mindfulness. Estas prácticas pueden ayudarte a gestionar el malestar y favorecer momentos de recuperación psicológica.',
    niveles: {NivelDepresion.moderado},
  ),
];

/// Recomendaciones que aplican para un nivel dado, en orden original.
/// Siempre entre 2 y 3 por nivel.
List<RecomendacionPhq> recomendacionesPhqPara(NivelDepresion nivel) =>
    recomendacionesPhq.where((r) => r.aplicaA(nivel)).toList();
