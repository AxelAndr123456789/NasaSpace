import 'package:flutter/material.dart';

import '../services/app_theme.dart';
import '../services/meeting_service.dart';
import '../widgets/custom_button.dart';
import 'reunion_page.dart';

/// Sección "Inicio": pantalla informativa de la atención.
///
/// Debajo se muestra el botón **Entrar a la reunión**, que lleva a la
/// videollamada real (cámara y micrófono).
class InicioPage extends StatelessWidget {
  const InicioPage({super.key});

  Future<void> _entrar(BuildContext context) async {
    await Navigator.of(context).push(ReunionPage.ruta());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            children: const [
              _HeroTeleconsulta(),
              SizedBox(height: 20),
              _Titulo('Tu atención'),
              SizedBox(height: 10),
              _Beneficio(
                icono: Icons.videocam_rounded,
                titulo: 'Videoconsulta en vivo',
                texto:
                    'Conecta por video con tu especialista en tiempo real, con '
                    'audio y cámara.',
              ),
              SizedBox(height: 10),
              _Beneficio(
                icono: Icons.description_rounded,
                titulo: 'Informe y receta digital',
                texto:
                    'Al finalizar la atención recibirás el resumen médico y tu '
                    'receta.',
              ),
              SizedBox(height: 10),
              _Beneficio(
                icono: Icons.favorite_rounded,
                titulo: 'Seguimiento de tu caso',
                texto:
                    'El equipo de AURA+ da seguimiento a tu evolución después '
                    'de la consulta.',
              ),
              SizedBox(height: 20),
              _Titulo('Cómo funciona'),
              SizedBox(height: 10),
              _Paso(
                numero: '1',
                titulo: 'Prepara tu espacio',
                texto: 'Busca un lugar tranquilo, con buena luz y conexión.',
              ),
              SizedBox(height: 8),
              _Paso(
                numero: '2',
                titulo: 'Revisa cámara y micrófono',
                texto: 'El navegador te pedirá permiso al entrar a la sala.',
              ),
              SizedBox(height: 8),
              _Paso(
                numero: '3',
                titulo: 'Únete a la sala',
                texto:
                    'Al entrar verás la videollamada dentro de la aplicación.',
              ),
              SizedBox(height: 20),
              _AvisoRequisitos(),
              SizedBox(height: 12),
            ],
          ),
        ),

        // Acción principal, siempre visible abajo.
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: CustomButton(
              text: 'Entrar a la reunión',
              icon: Icons.video_camera_front_rounded,
              solidBlue: true,
              onPressed: () => _entrar(context),
            ),
          ),
        ),
      ],
    );
  }
}

/// Encabezado informativo con la identidad AURA+.
class _HeroTeleconsulta extends StatelessWidget {
  const _HeroTeleconsulta();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.heroGradient,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipOval(
                child: Image.asset(
                  'lib/images/aura.png',
                  height: 44,
                  width: 44,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Teleconsulta AURA+',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Tu sesión de video está lista para comenzar. Al entrar a la sala '
            'podrás hablar y ver a tu especialista en tiempo real.',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _ChipDato(icono: Icons.lock_rounded, texto: 'Sala segura'),
              _ChipDato(
                icono: Icons.mic_rounded,
                texto: 'Cámara y micrófono',
              ),
              _ChipDato(icono: Icons.high_quality_rounded, texto: 'Video HD'),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChipDato extends StatelessWidget {
  const _ChipDato({required this.icono, required this.texto});

  final IconData icono;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.cyan.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, size: 14, color: AppColors.cyan),
          const SizedBox(width: 6),
          Text(
            texto,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _Titulo extends StatelessWidget {
  const _Titulo(this.texto);

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: AppColors.navyDark,
        letterSpacing: 0.2,
      ),
    );
  }
}

/// Tarjeta de beneficio de la atención.
class _Beneficio extends StatelessWidget {
  const _Beneficio({
    required this.icono,
    required this.titulo,
    required this.texto,
  });

  final IconData icono;
  final String titulo;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.navy.withValues(alpha: 0.07)),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: AppColors.cyan.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icono, size: 22, color: AppColors.navy),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.navyDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  texto,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: AppColors.navy.withValues(alpha: 0.68),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Paso numerado de "Cómo funciona".
class _Paso extends StatelessWidget {
  const _Paso({
    required this.numero,
    required this.titulo,
    required this.texto,
  });

  final String numero;
  final String titulo;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 30,
          width: 30,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            gradient: AppTheme.ctaGradient,
            shape: BoxShape.circle,
          ),
          child: Text(
            numero,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.navyDark,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navyDark,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                texto,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: AppColors.navy.withValues(alpha: 0.68),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Aviso de requisitos antes de entrar a la sala.
class _AvisoRequisitos extends StatelessWidget {
  const _AvisoRequisitos();

  static const List<String> _requisitos = [
    'Cámara y micrófono habilitados.',
    'Conexión a internet estable.',
    'Comparte el enlace para que la otra persona se una.',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cyan.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cyan.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline_rounded,
                  size: 18, color: AppColors.navy),
              SizedBox(width: 8),
              Text(
                'Antes de entrar',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.navyDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          for (final item in _requisitos)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle_rounded,
                      size: 16, color: AppColors.softCyan),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.35,
                        color: AppColors.navy.withValues(alpha: 0.75),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.link_rounded, size: 16, color: AppColors.navy),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  MeetingService.enlace,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: AppColors.navy.withValues(alpha: 0.7),
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Compartir enlace',
                icon: const Icon(Icons.ios_share_rounded,
                    size: 18, color: AppColors.navy),
                onPressed: MeetingService.compartirEnlace,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
