import 'package:flutter/material.dart';

import '../services/app_theme.dart';
import '../services/meeting_service.dart';
import 'reunion/reunion_io.dart'
    if (dart.library.js_interop) 'reunion/reunion_web.dart';

/// Pantalla de reunión: embebe la sala de video (Jitsi) en la app.
class ReunionPage extends StatelessWidget {
  const ReunionPage({super.key});

  /// Ruta de navegación desde "Inicio".
  static Route<void> ruta() {
    return MaterialPageRoute(builder: (_) => const ReunionPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navyDark,
      appBar: AppBar(
        backgroundColor: AppColors.navyDark,
        foregroundColor: AppColors.white,
        iconTheme: const IconThemeData(color: AppColors.white),
        elevation: 0,
        title: const Text(
          'Reunión en vivo',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share_rounded),
            tooltip: 'Compartir enlace',
            onPressed: MeetingService.compartirEnlace,
          ),
        ],
      ),
      body: const SafeArea(top: false, child: VistaReunion()),
    );
  }
}
