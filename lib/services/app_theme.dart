import 'package:flutter/material.dart';

/// Paleta extraída del logo AURA+ (lib/images/aura.png):
/// azul marino institucional, cian orbital y verde lima del pulso.
class AppColors {
  static const navy = Color(0xFF0D1B4C);
  static const navyDark = Color(0xFF071031);
  static const cyan = Color(0xFF2EDDF5);
  static const softCyan = Color(0xFF9CCFE3);
  static const lime = Color(0xFF8CE84B);
  static const background = Color(0xFFF5F8FD);
  static const white = Colors.white;

  /// Estados de atención.
  static const pendiente = Color(0xFFFF9F43);
  static const enCurso = Color(0xFF2EDDF5);
  static const completada = Color(0xFF8CE84B);
}

/// Tema visual de la aplicación basado en la identidad AURA+.
class AppTheme {
  /// Degradado del encabezado (marino profundo).
  static const heroGradient = LinearGradient(
    colors: [Color(0xFF101D43), Color(0xFF1B3B62)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Degradado celeste suave para acciones y detalles de perfil.
  static const ctaGradient = LinearGradient(
    colors: [Color(0xFFD5EAF3), Color(0xFF9CCFE3)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static ThemeData light() {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.navy,
          brightness: Brightness.light,
        ).copyWith(
          primary: AppColors.navy,
          onPrimary: AppColors.white,
          secondary: AppColors.cyan,
          onSecondary: AppColors.navyDark,
          tertiary: AppColors.lime,
          onTertiary: AppColors.navyDark,
          surface: AppColors.background,
          onSurface: AppColors.navy,
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.navy,
        foregroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.white,
        indicatorColor: AppColors.cyan.withValues(alpha: 0.28),
        elevation: 6,
        height: 68,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? AppColors.navy
                : AppColors.navy.withValues(alpha: 0.55),
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
            color: AppColors.navy,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.navy.withValues(alpha: 0.12)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.navy.withValues(alpha: 0.12)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.cyan, width: 2),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.navy,
        contentTextStyle: const TextStyle(color: AppColors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.cyan.withValues(alpha: 0.18),
        labelStyle: const TextStyle(
          color: AppColors.navy,
          fontWeight: FontWeight.w600,
        ),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.navy.withValues(alpha: 0.08),
      ),
    );
  }
}
