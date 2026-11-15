import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../services/app_theme.dart';
import 'login_page.dart';

/// Pantalla de carga (splash) con estética moderna AURA+:
/// logo con halo, anillo orbital en rotación y barra de progreso con %.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late final AnimationController _progress = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  );

  late final AnimationController _orbit = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 4),
  )..repeat();

  @override
  void initState() {
    super.initState();
    _progress.forward().whenComplete(_irAlLogin);
  }

  Future<void> _irAlLogin() async {
    if (!mounted) return;
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage()));
  }

  @override
  void dispose() {
    _progress.dispose();
    _orbit.dispose();
    super.dispose();
  }

  /// Valor de entrada (0→1) dentro del rango [start, end] con curva.
  double _enter(double v, double start, double end, Curve curve) {
    final t = ((v - start) / (end - start)).clamp(0.0, 1.0);
    return curve.transform(t);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppTheme.heroGradient),
        child: Stack(
          children: [
            // ----- Glows decorativos -----
            Positioned(
              top: -110,
              left: -80,
              child: _Glow(color: AppColors.cyan, size: 320),
            ),
            Positioned(
              bottom: -90,
              right: -70,
              child: _Glow(color: AppColors.lime, size: 280),
            ),
            Positioned(
              top: 120,
              right: -60,
              child: Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.white.withValues(alpha: 0.07),
                    width: 1.5,
                  ),
                ),
              ),
            ),

            // ----- Contenido -----
            SafeArea(
              child: AnimatedBuilder(
                animation: _progress,
                builder: (context, _) {
                  final v = _progress.value;
                  final logo = _enter(v, 0, 0.55, Curves.easeOutBack);
                  final marca = _enter(v, 0.3, 0.75, Curves.easeOutCubic);
                  final barra = _enter(v, 0.15, 0.9, Curves.easeOut);

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ----- Logo con anillo orbital -----
                      SizedBox(
                        width: 250,
                        height: 250,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned.fill(
                              child: AnimatedBuilder(
                                animation: _orbit,
                                builder: (context, _) => CustomPaint(
                                  painter: _OrbitPainter(
                                    angle: _orbit.value * 2 * math.pi,
                                  ),
                                ),
                              ),
                            ),
                            Transform.scale(
                              scale: 0.55 + 0.45 * logo,
                              child: Opacity(
                                opacity: logo.clamp(0.0, 1.0),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.cyan.withValues(
                                          alpha: 0.55,
                                        ),
                                        blurRadius: 55,
                                        spreadRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: Image.asset(
                                      'lib/images/aura.png',
                                      height: 130,
                                      width: 130,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 34),

                      // ----- Marca -----
                      Opacity(
                        opacity: marca.clamp(0.0, 1.0),
                        child: Transform.translate(
                          offset: Offset(0, 22 * (1 - marca)),
                          child: Column(
                            children: [
                              const Text(
                                'AURA+',
                                style: TextStyle(
                                  fontSize: 44,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.white,
                                  letterSpacing: 6,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Human Health, Beyond Earth.',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontStyle: FontStyle.italic,
                                  color: AppColors.cyan.withValues(alpha: 0.95),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 52),

                      // ----- Barra de progreso -----
                      Opacity(
                        opacity: barra.clamp(0.0, 1.0),
                        child: Column(
                          children: [
                            Container(
                              width: 210,
                              height: 7,
                              decoration: BoxDecoration(
                                color: AppColors.white.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: FractionallySizedBox(
                                  widthFactor: v,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: AppTheme.ctaGradient,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Cargando',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 2.4,
                                    color: AppColors.white.withValues(
                                      alpha: 0.7,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  '${(v * 100).round()}%',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.2,
                                    color: AppColors.cyan,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // ----- Pie -----
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Text(
                '© 2026 AURA+ · Human Health, Beyond Earth.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.white.withValues(alpha: 0.4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Glow radial suave de fondo.
class _Glow extends StatelessWidget {
  final Color color;
  final double size;

  const _Glow({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withValues(alpha: 0.3), color.withValues(alpha: 0)],
        ),
      ),
    );
  }
}

/// Anillo orbital: pista de fondo, arco cian→lima y punto en órbita.
class _OrbitPainter extends CustomPainter {
  final double angle;

  _OrbitPainter({required this.angle});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2 - 6;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Pista de fondo.
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = AppColors.white.withValues(alpha: 0.1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    canvas.translate(-center.dx, -center.dy);

    // Arco secundario tenue.
    canvas.drawArc(
      rect,
      2.4,
      1.5,
      false,
      Paint()
        ..color = AppColors.white.withValues(alpha: 0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );

    // Arco principal cian → lima.
    final shader = SweepGradient(
      colors: [AppColors.cyan, AppColors.lime],
    ).createShader(rect);
    canvas.drawArc(
      rect,
      -1.1,
      1.9,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round
        ..shader = shader,
    );

    // Punto en órbita (extremo del arco principal).
    const dotAngle = -1.1 + 1.9;
    final dot = Offset(
      center.dx + radius * math.cos(dotAngle),
      center.dy + radius * math.sin(dotAngle),
    );
    canvas.drawCircle(
      dot,
      14,
      Paint()..color = AppColors.lime.withValues(alpha: 0.3),
    );
    canvas.drawCircle(dot, 7, Paint()..color = AppColors.white);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _OrbitPainter oldDelegate) =>
      oldDelegate.angle != angle;
}
