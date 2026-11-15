import 'package:flutter/material.dart';

import '../models/resultado_test_model.dart';
import '../services/app_theme.dart';
import '../services/historial_service.dart';
import 'resultado_detalle_page.dart';

/// Sección "Historial": lista los resultados de los tests realizados.
class HistorialPage extends StatefulWidget {
  const HistorialPage({super.key});

  @override
  State<HistorialPage> createState() => _HistorialPageState();
}

class _HistorialPageState extends State<HistorialPage> {
  @override
  void initState() {
    super.initState();
    // Carga en segundo plano; al terminar, el servicio notifica y se reconstruye.
    HistorialService.instancia.cargar();
  }

  @override
  Widget build(BuildContext context) {
    // Se reconstruye cuando el servicio notifica un cambio (carga o nuevo resultado).
    return ListenableBuilder(
      listenable: HistorialService.instancia,
      builder: (context, _) {
        final resultados = HistorialService.instancia.resultados;
        if (resultados.isEmpty) return const _HistorialVacio();
        return ListView(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
          children: [
            Row(
              children: [
                const Text('Mis resultados', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: AppColors.navyDark)),
                const Spacer(),
                Text('${resultados.length} ${resultados.length == 1 ? 'guardado' : 'guardados'}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.navy.withValues(alpha: .58))),
              ],
            ),
            const SizedBox(height: 12),
            for (final resultado in resultados) ...[
              _TarjetaResultado(resultado: resultado),
              const SizedBox(height: 13),
            ],
          ],
        );
      },
    );
  }
}

class _HistorialVacio extends StatelessWidget {
  const _HistorialVacio();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(color: AppColors.navy.withValues(alpha: .06), shape: BoxShape.circle),
              child: Icon(Icons.history_rounded, size: 36, color: AppColors.navy.withValues(alpha: .4)),
            ),
            const SizedBox(height: 16),
            const Text('Aún no hay resultados', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.navyDark)),
            const SizedBox(height: 6),
            Text(
              'Cuando termines un test, tu resultado quedará guardado aquí.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, height: 1.4, color: AppColors.navy.withValues(alpha: .55)),
            ),
          ],
        ),
      ),
    );
  }
}

class _TarjetaResultado extends StatelessWidget {
  const _TarjetaResultado({required this.resultado});

  final ResultadoTest resultado;

  static const _meses = ['ene', 'feb', 'mar', 'abr', 'may', 'jun', 'jul', 'ago', 'sep', 'oct', 'nov', 'dic'];

  String get _fecha {
    final f = resultado.fecha;
    final hora = f.hour.toString().padLeft(2, '0');
    final minuto = f.minute.toString().padLeft(2, '0');
    return '${f.day} ${_meses[f.month - 1]} ${f.year} · $hora:$minuto';
  }

  @override
  Widget build(BuildContext context) {
    final nivel = resultado.nivel;
    return Material(
      color: Colors.white,
      elevation: 2,
      shadowColor: AppColors.navy.withValues(alpha: .06),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: AppColors.navy.withValues(alpha: .07)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        // Al tocar se abre el mismo resultado que al terminar el test.
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => ResultadoDetallePage(resultado: resultado)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [nivel.color.withValues(alpha: .25), nivel.color.withValues(alpha: .1)]),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(Icons.assignment_rounded, size: 26, color: nivel.color),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(resultado.nombreTest, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: AppColors.navyDark)),
                    const SizedBox(height: 4),
                    Text(_fecha, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.navy.withValues(alpha: .5))),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${resultado.puntuacion}/${resultado.maximo}', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.navyDark)),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(color: nivel.color.withValues(alpha: .2), borderRadius: BorderRadius.circular(12)),
                    child: Text(nivel.etiqueta, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: AppColors.navy)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
