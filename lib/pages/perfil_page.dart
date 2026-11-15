import 'package:flutter/material.dart';

import '../services/app_theme.dart';
import 'login_page.dart';

/// Perfil del paciente.
class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 28),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: AppTheme.heroGradient,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.navy.withValues(alpha: .18),
                blurRadius: 20,
                offset: const Offset(0, 9),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppTheme.ctaGradient,
                  border: Border.all(color: Colors.white.withValues(alpha: .7), width: 3),
                ),
                child: const Icon(Icons.person_rounded, size: 39, color: AppColors.navyDark),
              ),
              const SizedBox(width: 15),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mi perfil', style: TextStyle(color: AppColors.softCyan, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: .5)),
                    SizedBox(height: 5),
                    Text('Usuario ASA', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                    SizedBox(height: 4),
                    Text('Paciente', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        const Text(
          'Información de la cuenta',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.navyDark),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.navy.withValues(alpha: .07)),
            boxShadow: [
              BoxShadow(color: AppColors.navy.withValues(alpha: .04), blurRadius: 14, offset: const Offset(0, 5)),
            ],
          ),
          child: const Column(
            children: [
              _DatoPerfil(icono: Icons.person_outline_rounded, etiqueta: 'Nombre', valor: 'Usuario ASA'),
              Divider(height: 1, indent: 52),
              _DatoPerfil(icono: Icons.email_outlined, etiqueta: 'Correo electrónico', valor: 'usuario@asa.com'),
              Divider(height: 1, indent: 52),
              _DatoPerfil(icono: Icons.badge_outlined, etiqueta: 'Tipo de cuenta', valor: 'Paciente'),
            ],
          ),
        ),
        const SizedBox(height: 22),
        const Text(
          'Tu espacio de salud',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.navyDark),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.navy.withValues(alpha: .07)),
            boxShadow: [
              BoxShadow(color: AppColors.navy.withValues(alpha: .04), blurRadius: 14, offset: const Offset(0, 5)),
            ],
          ),
          child: Column(
            children: [
              _ResumenPerfil(icono: Icons.assignment_rounded, color: AppColors.softCyan, texto: 'Explora los tipos de test y conoce cómo te sientes.'),
              const SizedBox(height: 14),
              _ResumenPerfil(icono: Icons.history_rounded, color: const Color(0xFF849FC4), texto: 'Consulta tu historial para tener tus atenciones a mano.'),
            ],
          ),
        ),
        const SizedBox(height: 18),
        FilledButton.icon(
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginPage()),
              (_) => false,
            );
          },
          icon: const Icon(Icons.logout_rounded, size: 18),
          label: const Text('Cerrar sesión'),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.navy,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
          ),
        ),
      ],
    );
  }
}

class _ResumenPerfil extends StatelessWidget {
  const _ResumenPerfil({required this.icono, required this.color, required this.texto});

  final IconData icono;
  final Color color;
  final String texto;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: color.withValues(alpha: .12), borderRadius: BorderRadius.circular(13)),
        child: Icon(icono, color: color, size: 21),
      ),
      const SizedBox(width: 12),
      Expanded(child: Text(texto, style: TextStyle(fontSize: 12, height: 1.4, color: AppColors.navy.withValues(alpha: .72)))),
    ],
  );
}

class _DatoPerfil extends StatelessWidget {
  const _DatoPerfil({required this.icono, required this.etiqueta, required this.valor});

  final IconData icono;
  final String etiqueta;
  final String valor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: AppColors.softCyan.withValues(alpha: .18), borderRadius: BorderRadius.circular(13)),
            child: Icon(icono, color: AppColors.navy, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(etiqueta, style: TextStyle(fontSize: 11, color: AppColors.navy.withValues(alpha: .58))),
                const SizedBox(height: 3),
                Text(valor, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.navyDark)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
