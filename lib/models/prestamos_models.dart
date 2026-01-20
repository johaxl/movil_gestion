class PrestamosModels {
  int? id;
  int idLibro;
  int idUsuario;
  String fechaPrestamo;
  String fechaDevolucion;
  String estado;

  // Nombres solo para lectura
  String? libroNombre;
  String? usuarioNombre;

  PrestamosModels({
    this.id,
    required this.idLibro,
    required this.idUsuario,
    required this.fechaPrestamo,
    required this.fechaDevolucion,
    required this.estado,
    this.libroNombre,
    this.usuarioNombre,
  });

  factory PrestamosModels.fromMap(Map<String, dynamic> data) {
    return PrestamosModels(
      id: data['id'],
      idLibro: data['id_libro'],
      idUsuario: data['id_usuario'],
      fechaPrestamo: data['fecha_prestamo'],
      fechaDevolucion: data['fecha_devolucion'],
      estado: data['estado'],
      libroNombre: data['libro_nombre'],
      usuarioNombre: data['usuario_nombre'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_libro': idLibro,
      'id_usuario': idUsuario,
      'fecha_prestamo': fechaPrestamo,
      'fecha_devolucion': fechaDevolucion,
      'estado': estado,
    };
  }
}
