import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/resultado_test_model.dart';

/// Almacena los resultados de los tests realizados.
///
/// Se guardan en `shared_preferences` como JSON para que el historial
/// sobreviva a los reinicios de la aplicación.
class HistorialService extends ChangeNotifier {
  HistorialService._();
  static final HistorialService instancia = HistorialService._();

  static const _clave = 'historial_resultados';

  final List<ResultadoTest> _resultados = [];

  /// Resultados guardados, del más reciente al más antiguo.
  List<ResultadoTest> get resultados => List.unmodifiable(_resultados);

  /// Carga los resultados guardados (si no se han cargado ya).
  Future<void> cargar() async {
    if (_resultados.isNotEmpty) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final datos = prefs.getString(_clave);
      if (datos == null || datos.isEmpty) return;
      final lista = jsonDecode(datos) as List<dynamic>;
      _resultados
        ..clear()
        ..addAll(
          lista.map(
            (e) => ResultadoTest.fromJson(Map<String, dynamic>.from(e as Map)),
          ),
        );
      notifyListeners();
    } catch (_) {
      // Si el almacenamiento no está disponible, se trabaja en memoria.
    }
  }

  /// Agrega un resultado al inicio del historial y lo persiste.
  Future<void> agregar(ResultadoTest resultado) async {
    _resultados.insert(0, resultado);
    notifyListeners();
    await _guardar();
  }

  Future<void> _guardar() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final datos = jsonEncode(_resultados.map((e) => e.toJson()).toList());
      await prefs.setString(_clave, datos);
    } catch (_) {
      // Sin persistencia disponible el resultado queda solo en memoria.
    }
  }

  /// Elimina todos los resultados (para pruebas o limpieza manual).
  Future<void> limpiar() async {
    _resultados.clear();
    notifyListeners();
    await _guardar();
  }
}
