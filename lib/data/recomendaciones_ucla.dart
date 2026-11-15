import '../models/resultado_test_model.dart';

/// Recomendaciones de afrontamiento para puntuaciones elevadas en la UCLA-3.
///
/// Se muestran únicamente cuando la puntuación agrupa a la persona como
/// «solitaria» (6 a 9 puntos). Con 3 a 5 puntos («no solitarios») no se
/// sugieren recomendaciones.
class RecomendacionUcla {
  const RecomendacionUcla({required this.texto, required this.niveles});

  final String texto;

  /// Niveles para los cuales esta recomendación se sugiere.
  final Set<NivelSoledad> niveles;

  bool aplicaA(NivelSoledad nivel) => niveles.contains(nivel);
}

/// Las 12 recomendaciones, en su orden original.
const List<RecomendacionUcla> recomendacionesUcla = [
  RecomendacionUcla(
    texto:
        'Fortalecer la comunicación con personas significativas: Establecer momentos programados para comunicarse con familiares, amistades o personas importantes mediante los canales disponibles durante la misión. Procurar que estos intercambios incluyan conversaciones personales y significativas, además de actualizaciones operativas.',
    niveles: {NivelSoledad.solitario},
  ),
  RecomendacionUcla(
    texto:
        'Promover la conexión emocional con la tripulación: Participar en conversaciones informales, compartir experiencias cotidianas y dedicar momentos a conocer los intereses y perspectivas de los demás integrantes. La cercanía física no siempre implica conexión emocional.',
    niveles: {NivelSoledad.solitario},
  ),
  RecomendacionUcla(
    texto:
        'Crear rituales sociales dentro de la misión: Incorporar actividades compartidas, como comidas grupales, celebraciones de fechas importantes, noches de películas, juegos o espacios breves de conversación. La repetición de estos momentos puede favorecer el sentido de pertenencia.',
    niveles: {NivelSoledad.solitario},
  ),
  RecomendacionUcla(
    texto:
        'Expresar las necesidades de compañía y apoyo: Identificar cuándo se necesita conversar, recibir escucha o compartir una preocupación, y comunicarlo de manera directa y respetuosa a los compañeros o al equipo de apoyo psicológico.',
    niveles: {NivelSoledad.solitario},
  ),
  RecomendacionUcla(
    texto:
        'Participar activamente en actividades colaborativas: Involucrarse en tareas grupales, proyectos recreativos y actividades de resolución conjunta de problemas. Estas experiencias pueden facilitar la cooperación y fortalecer los vínculos interpersonales.',
    niveles: {NivelSoledad.solitario},
  ),
  RecomendacionUcla(
    texto:
        'Mantener vínculos con la identidad y la vida en la Tierra: Conservar fotografías, cartas, grabaciones de voz, música u objetos personales autorizados que permitan mantener una conexión simbólica con personas, lugares y experiencias significativas.',
    niveles: {NivelSoledad.solitario},
  ),
  RecomendacionUcla(
    texto:
        'Desarrollar habilidades de comunicación interpersonal: Practicar la escucha activa, la validación emocional, la expresión asertiva y la resolución constructiva de desacuerdos. Estas habilidades ayudan a prevenir que los conflictos cotidianos se conviertan en experiencias persistentes de distanciamiento.',
    niveles: {NivelSoledad.solitario},
  ),
  RecomendacionUcla(
    texto:
        'Reconocer y cuestionar pensamientos asociados al rechazo o la exclusión: Cuando aparezcan interpretaciones como «no les importo» o «no encajo con los demás», identificar qué hechos las respaldan y considerar explicaciones alternativas antes de asumir que existe un rechazo personal.',
    niveles: {NivelSoledad.solitario},
  ),
  RecomendacionUcla(
    texto:
        'Ampliar las oportunidades de conexión social: Alternar las interacciones con distintos integrantes de la tripulación, evitando depender exclusivamente de una persona para satisfacer todas las necesidades de compañía y apoyo emocional.',
    niveles: {NivelSoledad.solitario},
  ),
  RecomendacionUcla(
    texto:
        'Incorporar actividades compartidas con significado personal: Proponer actividades artísticas, musicales, recreativas, educativas o culturales que permitan descubrir intereses comunes y generar experiencias positivas con los demás integrantes.',
    niveles: {NivelSoledad.solitario},
  ),
  RecomendacionUcla(
    texto:
        'Practicar la autocompasión y la aceptación de momentos de soledad: Reconocer que experimentar soledad durante una misión prolongada no representa una debilidad ni una incapacidad para relacionarse. Utilizar ejercicios breves de respiración, atención plena o escritura reflexiva para gestionar el malestar sin juzgarse.',
    niveles: {NivelSoledad.solitario},
  ),
  RecomendacionUcla(
    texto:
        'Solicitar acompañamiento psicológico cuando la desconexión sea persistente: Si los sentimientos de soledad se mantienen, aumentan o afectan el estado de ánimo, la comunicación, el desempeño o la convivencia, comunicarlo al equipo de salud mental y solicitar una evaluación individualizada.',
    niveles: {NivelSoledad.solitario},
  ),
];

/// Recomendaciones que aplican para un nivel dado, en orden original.
/// Solo el nivel «solitario» (6 a 9) recibe sugerencias: las 12.
List<RecomendacionUcla> recomendacionesUclaPara(NivelSoledad nivel) =>
    recomendacionesUcla.where((r) => r.aplicaA(nivel)).toList();
