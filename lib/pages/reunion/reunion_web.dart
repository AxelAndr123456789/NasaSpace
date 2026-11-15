import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

import '../../services/meeting_service.dart';

/// Reunión de video embebida en el navegador.
///
/// Jitsi no publica plugin para web, así que la sala se muestra dentro de un
/// `<iframe>` con permisos de cámara y micrófono habilitados.
class VistaReunion extends StatelessWidget {
  const VistaReunion({super.key});

  static const String _viewType = 'aura_reunion_jitsi';
  static bool _registrada = false;

  /// Registra una sola vez la fábrica que crea el elemento `<iframe>`.
  static void _registrar() {
    if (_registrada) return;
    _registrada = true;

    ui_web.platformViewRegistry.registerViewFactory(
      _viewType,
      (int viewId, {Object? params}) {
        final frame = web.HTMLIFrameElement()
          ..src = MeetingService.enlace
          // Permite que el iframe use la cámara y el micrófono del equipo.
          ..allow = 'camera; microphone; fullscreen; autoplay'
          ..allowFullscreen = true;
        frame.style.cssText =
            'display:block;width:100%;height:100%;border:0;margin:0;';
        return frame;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _registrar();
    return const HtmlElementView(viewType: _viewType);
  }
}
