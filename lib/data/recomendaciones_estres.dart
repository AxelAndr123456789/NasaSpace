import '../models/resultado_test_model.dart';

/// Recomendaciones de afrontamiento del estrés (misiones espaciales).
///
/// Cada nivel de estrés percibido recibe entre 2 y 3 sugerencias:
///   - Bajo (2):      prácticas de mantenimiento.
///   - Moderado (3):  herramientas para aliviar la tensión.
///   - Alto (3):      descanso y apoyo social.
class RecomendacionEstres {
  const RecomendacionEstres({required this.texto, required this.niveles});

  final String texto;

  /// Niveles para los cuales esta recomendación se sugiere.
  final Set<NivelEstres> niveles;

  bool aplicaA(NivelEstres nivel) => niveles.contains(nivel);
}

/// Las 8 recomendaciones, en su orden original.
const List<RecomendacionEstres> recomendacionesEstres = [
  // 1 · Bajo (mantenimiento).
  RecomendacionEstres(
    texto:
        'Práctica de mindfulness: Dedica unos minutos al día a realizar ejercicios de atención plena. Concéntrate en tu respiración, las sensaciones corporales y el momento presente, procurando observar tus pensamientos sin juzgarlos. Esta práctica puede ayudarte a gestionar la tensión asociada a las exigencias de las misiones espaciales.',
    niveles: {NivelEstres.bajo},
  ),
  // 2 · Moderado (alivio de la tensión).
  RecomendacionEstres(
    texto:
        'Respiración controlada: Cuando experimentes tensión o sobrecarga emocional, realiza respiraciones lentas y cómodas, prestando atención a la inhalación y la exhalación. Puedes practicar este ejercicio durante unos minutos en un espacio tranquilo y seguro de la nave.',
    niveles: {NivelEstres.moderado},
  ),
  // 3 · Moderado.
  RecomendacionEstres(
    texto:
        'Organización de actividades: Establece prioridades y divide las tareas de la misión en objetivos pequeños y alcanzables. Mantener una planificación estructurada puede ayudarte a reducir la sensación de sobrecarga y mejorar la percepción de control sobre tus responsabilidades.',
    niveles: {NivelEstres.moderado},
  ),
  // 4 · Alto (descanso).
  RecomendacionEstres(
    texto:
        'Pausas de recuperación psicológica: Incorpora pequeños momentos de descanso entre tus actividades, siempre que las operaciones de la misión lo permitan. Puedes escuchar música, realizar ejercicios de relajación o dedicar unos minutos a una actividad recreativa.',
    niveles: {NivelEstres.alto},
  ),
  // 5 · Alto (apoyo social).
  RecomendacionEstres(
    texto:
        'Fortalecimiento de las relaciones interpersonales: Procura mantener una comunicación abierta y respetuosa con los demás integrantes de la tripulación. Compartir preocupaciones, expresar necesidades y ofrecer apoyo puede favorecer la convivencia y disminuir la sensación de aislamiento.',
    niveles: {NivelEstres.alto},
  ),
  // 6 · Moderado.
  RecomendacionEstres(
    texto:
        'Tolerancia a la incertidumbre: Durante una misión espacial pueden presentarse situaciones inesperadas que escapen de tu control. Procura identificar qué aspectos puedes modificar y concentrar tus esfuerzos en las acciones disponibles, evitando invertir demasiada energía en circunstancias que no dependen de ti.',
    niveles: {NivelEstres.moderado},
  ),
  // 7 · Bajo (mantenimiento).
  RecomendacionEstres(
    texto:
        'Visualización positiva: Dedica unos minutos a imaginar situaciones en las que hayas afrontado satisfactoriamente desafíos anteriores. Puedes recordar tus capacidades, experiencias y recursos personales para fortalecer tu confianza ante las exigencias de la misión.',
    niveles: {NivelEstres.bajo},
  ),
  // 8 · Alto (apoyo social).
  RecomendacionEstres(
    texto:
        'Contacto con seres queridos: Cuando las condiciones de comunicación lo permitan, reserva momentos para mantener contacto con familiares y personas significativas. Estas interacciones pueden contribuir a conservar el sentido de conexión y apoyo emocional durante el aislamiento espacial.',
    niveles: {NivelEstres.alto},
  ),
];

/// Recomendaciones que aplican para un nivel dado, en orden original.
/// Siempre entre 2 y 3 por nivel.
List<RecomendacionEstres> recomendacionesPara(NivelEstres nivel) =>
    recomendacionesEstres.where((r) => r.aplicaA(nivel)).toList();
