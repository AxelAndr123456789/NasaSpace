import 'package:flutter/material.dart';
import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/app_theme.dart';
import '../../services/meeting_service.dart';

/// Reunión de video fuera de la web.
///
/// * Android / iOS: abre la sala con el SDK nativo de Jitsi (pantalla completa).
/// * Windows / macOS / Linux: el SDK no existe, así que se abre la sala en el
///   navegador predeterminado con la cámara y el micrófono activos.
class VistaReunion extends StatefulWidget {
  const VistaReunion({super.key});

  @override
  State<VistaReunion> createState() => _VistaReunionState();
}

enum _Estado { abriendo, finalizada, enNavegador, error }

class _VistaReunionState extends State<VistaReunion> {
  _Estado _estado = _Estado.abriendo;
  String? _detalle;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _entrar());
  }

  Future<void> _entrar() async {
    setState(() {
      _estado = _Estado.abriendo;
      _detalle = null;
    });

    try {
      final respuesta = await JitsiMeetWrapper.joinMeeting(
        options: JitsiMeetingOptions(
          roomNameOrUrl: MeetingService.sala,
          serverUrl: MeetingService.servidor,
          subject: 'Consulta AURA+',
          userDisplayName: 'Participante AURA+',
          isAudioMuted: false,
          isVideoMuted: false,
        ),
      );

      if (!mounted) return;

      // El wrapper devuelve isSuccess:false cuando el plugin no existe
      // (escritorio / web): en ese caso abrimos la sala en el navegador.
      if (respuesta.isSuccess) {
        setState(() => _estado = _Estado.finalizada);
      } else {
        await _abrirEnNavegador(motivo: respuesta.message);
      }
    } catch (e) {
      if (!mounted) return;
      await _abrirEnNavegador(motivo: '$e');
    }
  }

  Future<void> _abrirEnNavegador({String? motivo}) async {
    final uri = Uri.parse(MeetingService.enlace);
    try {
      final abierto =
          await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!mounted) return;
      setState(() {
        _estado = abierto ? _Estado.enNavegador : _Estado.error;
        _detalle = abierto ? motivo : 'No se pudo abrir el navegador.';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _estado = _Estado.error;
        _detalle = '$e';
      });
    }
  }

  Future<void> _compartir() => MeetingService.compartirEnlace();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: _TarjetaEstado(
            estado: _estado,
            detalle: _detalle,
            onReintentar: _entrar,
            onCompartir: _compartir,
          ),
        ),
      ),
    );
  }
}

class _TarjetaEstado extends StatelessWidget {
  const _TarjetaEstado({
    required this.estado,
    required this.detalle,
    required this.onReintentar,
    required this.onCompartir,
  });

  final _Estado estado;
  final String? detalle;
  final VoidCallback onReintentar;
  final VoidCallback onCompartir;

  @override
  Widget build(BuildContext context) {
    final (icono, titulo, texto) = switch (estado) {
      _Estado.abriendo => (
          Icons.video_camera_front_rounded,
          'Abriendo la reunión…',
          'Preparando la cámara y el micrófono para la consulta.',
        ),
      _Estado.finalizada => (
          Icons.check_circle_rounded,
          'Reunión finalizada',
          'Gracias por usar AURA+. Puedes volver a entrar cuando quieras.',
        ),
      _Estado.enNavegador => (
          Icons.open_in_new_rounded,
          'Reunión abierta en el navegador',
          'La sala de Jitsi se abrió en una pestaña nueva con tu cámara y '
              'micrófono. Comparte el enlace para que la otra persona se una.',
        ),
      _Estado.error => (
          Icons.error_outline_rounded,
          'No se pudo iniciar la reunión',
          detalle ?? 'Inténtalo de nuevo.',
        ),
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.navy.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 68,
            width: 68,
            decoration: BoxDecoration(
              gradient: AppTheme.ctaGradient,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Icon(icono, size: 34, color: AppColors.navyDark),
          ),
          const SizedBox(height: 18),
          Text(
            titulo,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.navyDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            texto,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.45,
              color: AppColors.navy.withValues(alpha: 0.7),
            ),
          ),
          if (estado == _Estado.abriendo) ...[
            const SizedBox(height: 20),
            const SizedBox(
              width: 26,
              height: 26,
              child: CircularProgressIndicator(
                strokeWidth: 2.6,
                color: AppColors.cyan,
              ),
            ),
          ],
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onCompartir,
                  icon: const Icon(Icons.ios_share_rounded, size: 18),
                  label: const Text('Compartir'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.navy,
                    side: BorderSide(
                      color: AppColors.navy.withValues(alpha: 0.25),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: onReintentar,
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: Text(
                    estado == _Estado.finalizada ? 'Volver a entrar' : 'Reintentar',
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.navyDark,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
