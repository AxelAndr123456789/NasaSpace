import '../models/user_model.dart';

/// Servicio de autenticación (simulado).
/// En la demo se permite ingresar con cualquier dato.
class AuthService {
  /// Valida las credenciales y devuelve el usuario autenticado.
  Future<UserModel> login(String email, String password) async {
    // Simula una petición al servidor.
    await Future.delayed(const Duration(milliseconds: 700));

    final correo = email.trim();
    final nombre = correo.isEmpty ? 'Usuario AURA+' : correo.split('@').first;

    return UserModel(
      nombre: nombre,
      email: correo.isEmpty ? 'usuario@asa.com' : correo,
      rol: 'Paciente',
    );
  }
}
