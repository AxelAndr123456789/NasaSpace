/// Modelo que representa una atención registrada.
class AtencionModel {
  final String id;
  final String titulo;
  final String estado;
  final DateTime? fecha;

  const AtencionModel({
    required this.id,
    required this.titulo,
    required this.estado,
    this.fecha,
  });
}
