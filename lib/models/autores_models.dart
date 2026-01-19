class AutoresModels {
  int? id;
  String nombre;
  String apellido;
  String nacionalidad;
  String fechaNacimiento;
  String generoliterario;

  AutoresModels({
    this.id,
    required this.nombre,
    required this.apellido,
    required this.nacionalidad,
    required this.fechaNacimiento,
    required this.generoliterario,
  });

  factory AutoresModels.fromMap(Map<String, dynamic> data) {
    return AutoresModels(
      id: data['id'],
      nombre: data['nombre'],
      apellido: data['apellido'],
      nacionalidad: data['nacionalidad'],
      fechaNacimiento: data['fecha_nacimiento'],
      generoliterario: data['generoliterario'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'apellido': apellido,
      'nacionalidad': nacionalidad,
      'fecha_nacimiento': fechaNacimiento,
      'generoliterario': generoliterario,
    };
  }
}
