import 'package:flutter/material.dart';

/// Nivel obtenido en un test, con la etiqueta, color y descripción propios
/// de ese test. Se guarda en el historial tal como se mostró el resultado.
class NivelResultado {
  const NivelResultado({
    required this.id,
    required this.etiqueta,
    required this.color,
    required this.descripcion,
    this.tituloPersonalizado,
  });

  /// Identificador estable ('bajo', 'moderado', 'alto', 'minimo', ...).
  final String id;

  /// Ej.: 'Estrés moderado', 'Ansiedad leve'.
  final String etiqueta;

  final Color color;

  /// Interpretación del puntaje que se muestra en la pantalla de resultado.
  final String descripcion;

  /// Título alternativo para la tarjeta de recomendaciones; si no se indica,
  /// se usa 'Recomendaciones para ' + etiqueta en minúsculas.
  final String? tituloPersonalizado;

  /// Título resuelto de la tarjeta de recomendaciones.
  String get tituloRecomendaciones => tituloPersonalizado ?? 'Recomendaciones para ${etiqueta.toLowerCase()}';

  Map<String, dynamic> toJson() => {
    'id': id,
    'etiqueta': etiqueta,
    'color': color.toARGB32(),
    'descripcion': descripcion,
    'titulo': tituloPersonalizado,
  };

  /// Formato nuevo: un mapa. Formato antiguo: solo la id como texto
  /// ('bajo', 'moderado', 'alto'), propia del test de estrés.
  factory NivelResultado.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return NivelResultado(
        id: json['id'] as String,
        etiqueta: json['etiqueta'] as String? ?? '',
        color: Color((json['color'] as num?)?.toInt() ?? 0xFFFF9F43),
        descripcion: json['descripcion'] as String? ?? '',
        tituloPersonalizado: json['titulo'] as String?,
      );
    }
    final estres = NivelEstres.desdeId(json?.toString() ?? '');
    return (estres ?? NivelEstres.moderado).aResultado;
  }
}

/// Nivel de estrés percibido según la PSS-14 (0 a 56).
enum NivelEstres {
  bajo,
  moderado,
  alto;

  String get etiqueta => switch (this) {
    NivelEstres.bajo => 'Estrés bajo',
    NivelEstres.moderado => 'Estrés moderado',
    NivelEstres.alto => 'Estrés alto',
  };

  Color get color => switch (this) {
    NivelEstres.bajo => const Color(0xFF8CE84B),
    NivelEstres.moderado => const Color(0xFFFF9F43),
    NivelEstres.alto => const Color(0xFFEF8299),
  };

  /// Descripción corta que se muestra bajo el nivel en el resultado.
  String get descripcion => switch (this) {
    NivelEstres.bajo => 'Parece que estás manejando bien las situaciones del día a día. Mantén tus hábitos de cuidado.',
    NivelEstres.moderado => 'Hay situaciones que te generan tensión. Conviene atención a tu descanso y a los recursos de apoyo.',
    NivelEstres.alto => 'Tu nivel de estrés percibido es alto. Te recomendamos conversarlo con un profesional.',
  };

  /// Rangos orientativos de la PSS-14:
  /// 0–16 bajo · 17–34 moderado · 35–56 alto.
  static NivelEstres desdePuntuacion(int puntuacion) {
    if (puntuacion <= 16) return NivelEstres.bajo;
    if (puntuacion <= 34) return NivelEstres.moderado;
    return NivelEstres.alto;
  }

  /// Busca un nivel por su id ('bajo', 'moderado', 'alto').
  static NivelEstres? desdeId(String id) {
    for (final nivel in values) {
      if (nivel.name == id) return nivel;
    }
    return null;
  }

  /// Representación genérica para guardar en el historial.
  NivelResultado get aResultado => NivelResultado(
    id: name,
    etiqueta: etiqueta,
    color: color,
    descripcion: descripcion,
  );
}

/// Nivel de ansiedad según el GAD-7 (0 a 21).
enum NivelAnsiedad {
  minimo,
  leve,
  moderado,
  severo;

  String get etiqueta => switch (this) {
    NivelAnsiedad.minimo => 'Ansiedad mínima',
    NivelAnsiedad.leve => 'Ansiedad leve',
    NivelAnsiedad.moderado => 'Ansiedad moderada',
    NivelAnsiedad.severo => 'Ansiedad severa',
  };

  Color get color => switch (this) {
    NivelAnsiedad.minimo => const Color(0xFF8CE84B),
    NivelAnsiedad.leve => const Color(0xFFF2C94C),
    NivelAnsiedad.moderado => const Color(0xFFFF9F43),
    NivelAnsiedad.severo => const Color(0xFFEB5757),
  };

  /// Interpretación oficial del puntaje (GAD-7), en español.
  String get descripcion => switch (this) {
    NivelAnsiedad.minimo => 'Es posible que no sea clínicamente indicado un tratamiento para la ansiedad.',
    NivelAnsiedad.leve => 'El profesional de salud mental valora las necesidades de tratamiento según el caso, la duración y la gravedad de los síntomas.',
    NivelAnsiedad.moderado => 'Los objetivos de tratamiento y las intervenciones se centran en los síntomas específicos que indican tus respuestas.',
    NivelAnsiedad.severo => 'Los objetivos de tratamiento se centran en los síntomas específicos que indican tus respuestas. Esta puntuación suele justificar tratamiento con medicación, terapia o ambos.',
  };

  /// Rangos oficiales del GAD-7:
  /// 0–4 mínima · 5–9 leve · 10–14 moderada · 15–21 moderada a severa.
  static NivelAnsiedad desdePuntuacion(int puntuacion) {
    if (puntuacion <= 4) return NivelAnsiedad.minimo;
    if (puntuacion <= 9) return NivelAnsiedad.leve;
    if (puntuacion <= 14) return NivelAnsiedad.moderado;
    return NivelAnsiedad.severo;
  }

  /// Busca un nivel por su id ('minimo', 'leve', ...).
  static NivelAnsiedad? desdeId(String id) {
    for (final nivel in values) {
      if (nivel.name == id) return nivel;
    }
    return null;
  }

  /// Representación genérica para guardar en el historial.
  NivelResultado get aResultado => NivelResultado(
    id: name,
    etiqueta: etiqueta,
    color: color,
    descripcion: descripcion,
  );
}

/// Nivel de severidad de depresión según el PHQ-9 (0 a 27).
enum NivelDepresion {
  minimo,
  leve,
  moderado,
  moderadoSevero,
  severo;

  String get etiqueta => switch (this) {
    NivelDepresion.minimo => 'Depresión ninguna o mínima',
    NivelDepresion.leve => 'Depresión leve',
    NivelDepresion.moderado => 'Depresión moderada',
    NivelDepresion.moderadoSevero => 'Depresión moderadamente severa',
    NivelDepresion.severo => 'Depresión severa',
  };

  Color get color => switch (this) {
    NivelDepresion.minimo => const Color(0xFF8CE84B),
    NivelDepresion.leve => const Color(0xFFF2C94C),
    NivelDepresion.moderado => const Color(0xFFFF9F43),
    NivelDepresion.moderadoSevero => const Color(0xFFEF8299),
    NivelDepresion.severo => const Color(0xFFEB5757),
  };

  /// Acciones de tratamiento propuestas según la tabla oficial del PHQ-9
  /// (Kroenke K., Spitzer R. L., Psychiatric Annals 2002;32:509-521), en español.
  String get descripcion => switch (this) {
    NivelDepresion.minimo => 'No se requiere tratamiento para la depresión.',
    NivelDepresion.leve => 'Observación expectante; repetir el PHQ-9 en el seguimiento.',
    NivelDepresion.moderado => 'Plan de tratamiento, considerando consejería, seguimiento y/o farmacoterapia.',
    NivelDepresion.moderadoSevero => 'Tratamiento activo con farmacoterapia y/o psicoterapia.',
    NivelDepresion.severo => 'Inicio inmediato de farmacoterapia y, si hay deterioro severo o mala respuesta a la terapia, derivación urgente a un especialista en salud mental para psicoterapia y/o manejo colaborativo.',
  };

  /// Rangos oficiales del PHQ-9:
  /// 0–4 ninguna o mínima · 5–9 leve · 10–14 moderada ·
  /// 15–19 moderadamente severa · 20–27 severa.
  static NivelDepresion desdePuntuacion(int puntuacion) {
    if (puntuacion <= 4) return NivelDepresion.minimo;
    if (puntuacion <= 9) return NivelDepresion.leve;
    if (puntuacion <= 14) return NivelDepresion.moderado;
    if (puntuacion <= 19) return NivelDepresion.moderadoSevero;
    return NivelDepresion.severo;
  }

  /// Busca un nivel por su id ('minimo', 'leve', ...).
  static NivelDepresion? desdeId(String id) {
    for (final nivel in values) {
      if (nivel.name == id) return nivel;
    }
    return null;
  }

  /// Representación genérica para guardar en el historial.
  NivelResultado get aResultado => NivelResultado(
    id: name,
    etiqueta: etiqueta,
    color: color,
    descripcion: descripcion,
  );
}

/// Nivel de soledad percibida según la UCLA-3 (3 a 9).
///
/// Cada pregunta se puntúa de 1 a 3 (Casi nunca = 1, Algunas veces = 2,
/// A menudo = 3). Los investigadores agrupan 3–5 como «no solitarios»
/// y 6–9 como «solitarios».
enum NivelSoledad {
  noSolitario,
  solitario;

  String get etiqueta => switch (this) {
    NivelSoledad.noSolitario => 'No solitario',
    NivelSoledad.solitario => 'Solitario',
  };

  Color get color => switch (this) {
    NivelSoledad.noSolitario => const Color(0xFF8CE84B),
    NivelSoledad.solitario => const Color(0xFFEF8299),
  };

  /// Interpretación según el agrupamiento oficial de la UCLA-3.
  String get descripcion => switch (this) {
    NivelSoledad.noSolitario => 'Tu puntuación (3 a 5) se agrupa en el grupo de «no solitarios»: no se percibe una soledad marcada.',
    NivelSoledad.solitario => 'Tu puntuación (6 a 9) se agrupa en el grupo de «solitarios»: conviene reforzar tus conexiones de compañía y apoyo.',
  };

  /// Título de la tarjeta de recomendaciones (solo hay para puntajes elevados).
  String get _tituloRecomendaciones => switch (this) {
    NivelSoledad.noSolitario => 'Recomendaciones para personas no solitarias',
    NivelSoledad.solitario => 'Recomendaciones para personas solitarias',
  };

  /// Agrupamiento oficial: 3–5 no solitario · 6–9 solitario.
  static NivelSoledad desdePuntuacion(int puntuacion) {
    if (puntuacion <= 5) return NivelSoledad.noSolitario;
    return NivelSoledad.solitario;
  }

  /// Busca un nivel por su id ('noSolitario', 'solitario').
  static NivelSoledad? desdeId(String id) {
    for (final nivel in values) {
      if (nivel.name == id) return nivel;
    }
    return null;
  }

  /// Representación genérica para guardar en el historial.
  NivelResultado get aResultado => NivelResultado(
    id: name,
    etiqueta: etiqueta,
    color: color,
    descripcion: descripcion,
    tituloPersonalizado: _tituloRecomendaciones,
  );
}

/// Nivel de bienestar según el WHO-5 (0 a 25, escala invertida).
///
/// Las 5 preguntas son positivas y se puntúan de 0 a 5 según la escala
/// oficial (Nunca = 0 … Todo el tiempo = 5), pero la puntuación que se
/// muestra se calcula como `25 − suma` para que 0 sea el buen estado y
/// 25 el estado crítico, igual que en los demás tests.
///
/// Rangos: 0–8 buen estado · 9–17 estado regular · 18–25 estado crítico.
enum NivelBienestar {
  bueno,
  regular,
  critico;

  String get etiqueta => switch (this) {
    NivelBienestar.bueno => 'Buen estado',
    NivelBienestar.regular => 'Estado regular',
    NivelBienestar.critico => 'Estado crítico',
  };

  Color get color => switch (this) {
    NivelBienestar.bueno => const Color(0xFF8CE84B),
    NivelBienestar.regular => const Color(0xFFF2C94C),
    NivelBienestar.critico => const Color(0xFFEB5757),
  };

  String get descripcion => switch (this) {
    NivelBienestar.bueno => 'Tu puntuación indica un buen estado de bienestar durante las últimas dos semanas. Mantén tus hábitos de cuidado.',
    NivelBienestar.regular => 'Tu puntuación indica un bienestar intermedio. Conviene atención a tu descanso y a las actividades que te reportan satisfacción.',
    NivelBienestar.critico => 'Tu puntuación indica un estado de bienestar bajo. Te recomendamos conversarlo con un profesional de salud mental.',
  };

  /// Agrupamiento oficial: 0–13 bienestar bajo · 14–25 buen bienestar,
  /// traducido a tres tramos en la escala invertida.
  static NivelBienestar desdePuntuacion(int puntuacion) {
    if (puntuacion <= 8) return NivelBienestar.bueno;
    if (puntuacion <= 17) return NivelBienestar.regular;
    return NivelBienestar.critico;
  }

  /// Busca un estado por su id ('bueno', 'regular', 'critico').
  static NivelBienestar? desdeId(String id) {
    for (final nivel in values) {
      if (nivel.name == id) return nivel;
    }
    return null;
  }

  /// Representación genérica para guardar en el historial.
  NivelResultado get aResultado => NivelResultado(
    id: name,
    etiqueta: etiqueta,
    color: color,
    descripcion: descripcion,
    // Cada estado muestra sus recomendaciones con un título propio.
    tituloPersonalizado: switch (this) {
      NivelBienestar.bueno => 'Recomendaciones para mantener tu buen estado',
      NivelBienestar.regular => 'Recomendaciones para mejorar tu bienestar',
      NivelBienestar.critico => 'Recomendaciones para recuperar tu bienestar',
    },
  );
}

/// Nivel de resiliencia según el CD-RISC-10 (0 a 40).
///
/// Escala de Resiliencia de Connor-Davidson (10 ítems), versión española.
/// Cada ítem se puntúa de 0 a 4 (En absoluto = 0 … Casi siempre = 4) y la
/// puntuación total es la suma directa de los 10 ítems.
///
/// Cortes según la interpretación de referencia (N = 1400, 18–80 años):
/// ≤ 27 puntuación baja · 28–35 intermedia · ≥ 36 puntuación alta.
enum NivelResiliencia {
  baja,
  moderada,
  alta;

  String get etiqueta => switch (this) {
    NivelResiliencia.baja => 'Resiliencia baja',
    NivelResiliencia.moderada => 'Resiliencia moderada',
    NivelResiliencia.alta => 'Resiliencia alta',
  };

  Color get color => switch (this) {
    NivelResiliencia.baja => const Color(0xFFEB5757),
    NivelResiliencia.moderada => const Color(0xFFF2C94C),
    NivelResiliencia.alta => const Color(0xFF8CE84B),
  };

  /// Interpretación de la puntuación según los cortes indicados.
  String get descripcion => switch (this) {
    NivelResiliencia.baja => 'Tu puntuación (27 o menos) se considera resiliencia baja: conviene fortalecer tus recursos de afrontamiento ante los cambios y las dificultades de la misión.',
    NivelResiliencia.moderada => 'Tu puntuación (28 a 35) se considera resiliencia moderada: cuentas con recursos de afrontamiento que pueden reforzarse.',
    NivelResiliencia.alta => 'Tu puntuación (36 o más) se considera resiliencia alta: afrontas los cambios y las dificultades con recursos sólidos.',
  };

  /// Cortes del CD-RISC-10: 0–27 baja · 28–35 moderada · 36–40 alta.
  static NivelResiliencia desdePuntuacion(int puntuacion) {
    if (puntuacion <= 27) return NivelResiliencia.baja;
    if (puntuacion <= 35) return NivelResiliencia.moderada;
    return NivelResiliencia.alta;
  }

  /// Busca un nivel por su id ('baja', 'moderada', 'alta').
  static NivelResiliencia? desdeId(String id) {
    for (final nivel in values) {
      if (nivel.name == id) return nivel;
    }
    return null;
  }

  /// Representación genérica para guardar en el historial.
  NivelResultado get aResultado => NivelResultado(
    id: name,
    etiqueta: etiqueta,
    color: color,
    descripcion: descripcion,
  );
}

/// Nivel de uso de estrategias de regulación emocional según el ERQ
/// (10 ítems con escala 1 a 7, puntuación total 10 a 70).
///
/// El ERQ de Gross y John (2003) evalúa dos estrategias por separado:
/// reelaboración cognitiva (6 ítems, 6 a 42) y supresión expresiva
/// (4 ítems, 4 a 28). Aquí la puntuación principal es la suma total de
/// los 10 ítems y la interpretación muestra además ambos subíndices.
///
/// Rangos: 10–29 uso bajo · 30–49 uso moderado · 50–70 uso elevado.
enum NivelRegulacion {
  bajo,
  moderado,
  alto;

  String get etiqueta => switch (this) {
    NivelRegulacion.bajo => 'Regulación emocional baja',
    NivelRegulacion.moderado => 'Regulación emocional moderada',
    NivelRegulacion.alto => 'Regulación emocional alta',
  };

  Color get color => switch (this) {
    NivelRegulacion.bajo => const Color(0xFFEB5757),
    NivelRegulacion.moderado => const Color(0xFFF2C94C),
    NivelRegulacion.alto => const Color(0xFF8CE84B),
  };

  String get descripcion => switch (this) {
    NivelRegulacion.bajo => 'Tu puntuación total (10 a 29) indica un uso poco frecuente de estrategias de regulación emocional.',
    NivelRegulacion.moderado => 'Tu puntuación total (30 a 49) indica un uso moderado de estrategias de regulación emocional.',
    NivelRegulacion.alto => 'Tu puntuación total (50 a 70) indica un uso frecuente de estrategias de regulación emocional.',
  };

  /// Título de la tarjeta de recomendaciones.
  String get _tituloRecomendaciones => switch (this) {
    NivelRegulacion.bajo => 'Recomendaciones para fortalecer tu regulación emocional',
    NivelRegulacion.moderado => 'Recomendaciones para potenciar tu regulación emocional',
    NivelRegulacion.alto => 'Recomendaciones para mantener tu regulación emocional',
  };

  /// Rangos: 10–29 bajo · 30–49 moderado · 50–70 alto.
  static NivelRegulacion desdePuntuacion(int puntuacion) {
    if (puntuacion <= 29) return NivelRegulacion.bajo;
    if (puntuacion <= 49) return NivelRegulacion.moderado;
    return NivelRegulacion.alto;
  }

  /// Busca un nivel por su id ('bajo', 'moderado', 'alto').
  static NivelRegulacion? desdeId(String id) {
    for (final nivel in values) {
      if (nivel.name == id) return nivel;
    }
    return null;
  }

  /// Descripción con los dos subíndices del ERQ añadidos:
  /// reelaboración (6 a 42) y supresión (4 a 28), ambos con su frecuencia.
  String descripcionCon({required int reelaboracion, required int supresion}) {
    const umbralReel = [20, 34]; // 6–20 baja · 21–34 moderada · 35–42 alta
    const umbralSup = [11, 19]; //  4–11 baja · 12–19 moderada · 20–28 alta
    final usoReel = reelaboracion <= umbralReel[0]
        ? 'bajo'
        : reelaboracion <= umbralReel[1] ? 'moderado' : 'alto';
    final usoSup = supresion <= umbralSup[0]
        ? 'bajo'
        : supresion <= umbralSup[1] ? 'moderado' : 'alto';
    return '$descripcion Reelaboración cognitiva: $reelaboracion de 42 (uso $usoReel) · Supresión expresiva: $supresion de 28 (uso $usoSup).';
  }

  /// Representación genérica para guardar en el historial.
  NivelResultado aResultado({required int reelaboracion, required int supresion}) => NivelResultado(
    id: name,
    etiqueta: etiqueta,
    color: color,
    descripcion: descripcionCon(reelaboracion: reelaboracion, supresion: supresion),
    tituloPersonalizado: _tituloRecomendaciones,
  );
}

/// Resultado de un test realizado por el usuario.
class ResultadoTest {
  const ResultadoTest({
    required this.id,
    required this.nombreTest,
    required this.puntuacion,
    required this.nivel,
    required this.fecha,
    this.maximo = 56,
    this.recomendaciones = const [],
  });

  final String id;
  final String nombreTest;

  /// Puntuación directa (0 a 56 en la PSS-14, 0 a 21 en la GAD-7).
  final int puntuacion;

  final NivelResultado nivel;
  final DateTime fecha;

  /// Puntuación máxima posible en este test (56 en la PSS-14, 21 en la GAD-7).
  final int maximo;

  /// Textos de las recomendaciones que se mostraron al terminar el test,
  /// para reproducir el mismo resultado al abrirlo desde el historial.
  final List<String> recomendaciones;

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombreTest': nombreTest,
    'puntuacion': puntuacion,
    'nivel': nivel.toJson(),
    'fecha': fecha.toIso8601String(),
    'maximo': maximo,
    'recomendaciones': recomendaciones,
  };

  factory ResultadoTest.fromJson(Map<String, dynamic> json) => ResultadoTest(
    id: json['id'] as String,
    nombreTest: json['nombreTest'] as String,
    puntuacion: (json['puntuacion'] as num).toInt(),
    nivel: NivelResultado.fromJson(json['nivel']),
    fecha: DateTime.tryParse(json['fecha'] as String? ?? '') ?? DateTime.now(),
    // Resultados antiguos: solo existía la puntuación máxima de la PSS-14.
    maximo: (json['maximo'] as num?)?.toInt() ?? 56,
    recomendaciones: (json['recomendaciones'] as List?)?.cast<String>() ?? const [],
  );
}
