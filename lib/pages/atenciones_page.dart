import 'package:flutter/material.dart';

import '../services/app_theme.dart';
import 'test_estres_page.dart';
import 'test_gad_page.dart';
import 'test_phq_page.dart';
import 'test_resiliencia_page.dart';
import 'test_erq_page.dart';
import 'test_ucla_page.dart';
import 'test_who_page.dart';

class AtencionesPage extends StatefulWidget {
  const AtencionesPage({super.key});

  @override
  State<AtencionesPage> createState() => _AtencionesPageState();
}

class _AtencionesPageState extends State<AtencionesPage> {
  /// Tipos de test disponibles. Con el tiempo se irán agregando más,
  /// igual que antes se listaban las especialidades.
  static final _tests = <_TipoTest>[
    _TipoTest(
      nombre: TestEstresPage.nombre,
      descripcion: 'Detecta qué tan estresado te has sentido durante el último mes con el cuestionario PSS-14.',
      icono: Icons.self_improvement_rounded,
      color: const Color(0xFF9C83F7),
      etiqueta: '14 preguntas · 3 min',
      pagina: () => const TestEstresPage(),
    ),
    _TipoTest(
      nombre: TestGadPage.nombre,
      descripcion: 'Detecta con qué frecuencia te ha molestado la ansiedad durante las últimas 2 semanas con el cuestionario GAD-7.',
      icono: Icons.psychology_alt_rounded,
      color: const Color(0xFF4CC2FF),
      etiqueta: '7 preguntas · 2 min',
      pagina: () => const TestGadPage(),
    ),
    _TipoTest(
      nombre: TestPhqPage.nombre,
      descripcion: 'Detecta con qué frecuencia te han molestado síntomas de depresión durante las últimas 2 semanas con el cuestionario PHQ-9.',
      icono: Icons.sentiment_very_dissatisfied_rounded,
      color: const Color(0xFFEF8299),
      etiqueta: '9 preguntas · 2 min',
      pagina: () => const TestPhqPage(),
    ),
    _TipoTest(
      nombre: TestUclaPage.nombre,
      descripcion: 'Mide qué tan seguido sientes que te falta compañía, que estás excluido o aislado de los demás durante las últimas semanas.',
      icono: Icons.person_off_rounded,
      color: const Color(0xFFF2C94C),
      etiqueta: '3 preguntas · 1 min',
      pagina: () => const TestUclaPage(),
    ),
    _TipoTest(
      nombre: TestWhoPage.nombre,
      descripcion: 'Mide cómo te has sentido alegre, tranquilo, activo y con intereses durante las últimas 2 semanas (índice OMS de bienestar).',
      icono: Icons.sentiment_very_satisfied_rounded,
      color: const Color(0xFF8CE84B),
      etiqueta: '5 preguntas · 1 min',
      pagina: () => const TestWhoPage(),
    ),
    _TipoTest(
      nombre: TestResilienciaPage.nombre,
      descripcion: 'Mide tu capacidad para adaptarte a los cambios, enfrentar dificultades y recuperarte ante la presión durante el último mes.',
      icono: Icons.local_fire_department_rounded,
      color: const Color(0xFF9B51E0),
      etiqueta: '10 preguntas · 2 min',
      pagina: () => const TestResilienciaPage(),
    ),
    _TipoTest(
      nombre: TestErqPage.nombre,
      descripcion: 'Mide cómo gestionas tus emociones: cuánto reelaboras la situación y cuánto contienes la expresión de lo que sientes.',
      icono: Icons.blur_on_rounded,
      color: const Color(0xFF2F80ED),
      etiqueta: '10 preguntas · 2 min',
      pagina: () => const TestErqPage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
      children: [
        const _EncabezadoAtenciones(),
        const SizedBox(height: 22),
        Row(
          children: [
            const Text('Tipos de test', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: AppColors.navyDark)),
            const Spacer(),
            Text('${_tests.length} disponibles', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.navy.withValues(alpha: .58))),
          ],
        ),
        const SizedBox(height: 12),
        for (final test in _tests) ...[
          _TarjetaTest(
            test: test,
            onIniciar: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => test.pagina()),
            ),
          ),
          const SizedBox(height: 13),
        ],
      ],
    );
  }
}

class _TipoTest {
  _TipoTest({required this.nombre, required this.descripcion, required this.icono, required this.color, required this.etiqueta, required this.pagina});
  final String nombre;
  final String descripcion;
  final IconData icono;
  final Color color;
  final String etiqueta;

  /// Página del test al que navega esta tarjeta.
  final Widget Function() pagina;
}

class _EncabezadoAtenciones extends StatelessWidget {
  const _EncabezadoAtenciones();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.heroGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: AppColors.navy.withValues(alpha: .2), blurRadius: 20, offset: const Offset(0, 9))],
      ),
      child: Stack(
        children: [
          Positioned(right: -18, top: -28, child: Icon(Icons.health_and_safety_rounded, size: 130, color: Colors.white.withValues(alpha: .07))),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: AppColors.cyan.withValues(alpha: .18), borderRadius: BorderRadius.circular(20)),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.auto_awesome_rounded, size: 14, color: AppColors.cyan), SizedBox(width: 6), Text('AURA+ CONTIGO', style: TextStyle(color: AppColors.cyan, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1))]),
            ),
            const SizedBox(height: 14),
            const Text('Conoce cómo te sientes', style: TextStyle(color: Colors.white, fontSize: 21, height: 1.2, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text('Elige un tipo de test y responde a tu ritmo. Al final obtendrás un resultado orientativo.', style: TextStyle(color: Colors.white.withValues(alpha: .78), fontSize: 13, height: 1.45)),
            const SizedBox(height: 16),
            Row(children: [
              const Icon(Icons.bolt_rounded, color: AppColors.softCyan, size: 17),
              const SizedBox(width: 7),
              Text('Resultado al instante', style: TextStyle(color: Colors.white.withValues(alpha: .9), fontSize: 12, fontWeight: FontWeight.w600)),
            ]),
          ]),
        ],
      ),
    );
  }
}

class _TarjetaTest extends StatelessWidget {
  const _TarjetaTest({required this.test, required this.onIniciar});
  final _TipoTest test;
  final VoidCallback onIniciar;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.navy.withValues(alpha: .07)),
        boxShadow: [BoxShadow(color: AppColors.navy.withValues(alpha: .045), blurRadius: 14, offset: const Offset(0, 5))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [test.color.withValues(alpha: .22), test.color.withValues(alpha: .08)]),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Icon(test.icono, size: 28, color: test.color),
          ),
          const SizedBox(width: 13),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(test.nombre, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.navyDark)),
            const SizedBox(height: 5),
            Text(test.descripcion, style: TextStyle(fontSize: 12.5, height: 1.4, color: AppColors.navy.withValues(alpha: .68))),
          ])),
        ]),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(child: Row(children: [Icon(Icons.check_circle_rounded, size: 15, color: test.color), const SizedBox(width: 6), Flexible(child: Text(test.etiqueta, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.navy.withValues(alpha: .65))))])),
          const SizedBox(width: 10),
          FilledButton.icon(
            onPressed: onIniciar,
            icon: const Icon(Icons.arrow_forward_rounded, size: 18),
            label: const Text('Iniciar test'),
            style: FilledButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11), textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13))),
          ),
        ]),
      ]),
    );
  }
}
