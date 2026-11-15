/// Modelo que representa al usuario que inicia sesión.
class UserModel {
  final String nombre;
  final String email;
  final String rol;

  const UserModel({
    required this.nombre,
    required this.email,
    required this.rol,
  });

  factory UserModel.demo() => const UserModel(
    nombre: 'Usuario ASA',
    email: 'usuario@asa.com',
    rol: 'Paciente',
  );

  UserModel copyWith({String? nombre, String? email, String? rol}) {
    return UserModel(
      nombre: nombre ?? this.nombre,
      email: email ?? this.email,
      rol: rol ?? this.rol,
    );
  }
}
