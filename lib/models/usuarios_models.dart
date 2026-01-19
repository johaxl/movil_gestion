class UsuariosModels {
  int? id;
  String nombre;
  String apellido;
  String cedula;
  String telefono;
  String correo;

  UsuariosModels({
    this.id,
    required this.nombre,
    required this.apellido,
    required this.cedula,
    required this.telefono,
    required this.correo,
  });

  factory UsuariosModels.fromMap(Map<String, dynamic> data) {
    return UsuariosModels(
      id: data['id'],
      nombre: data['nombre'],
      apellido: data['apellido'],
      cedula: data['cedula'],
      telefono: data['telefono'],
      correo: data['correo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'apellido': apellido,
      'cedula': cedula,
      'telefono': telefono,
      'correo': correo,
    };
  }
}
