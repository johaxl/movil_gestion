import '../models/autores_models.dart';
import '../settings/database_connection.dart';

class AutoresRepository {
  final tableName = "autores";
  final database = DatabaseConnection();

  // Funcion para insertar datos
  Future<int> create(AutoresModels data) async {
    // Llama a la base de datos
    final db = await database.db;
    // Inserta el autor
    return await db.insert(tableName, data.toMap());
  }

  // Funcion para editar datos
  Future<int> edit(AutoresModels data) async {
    // Llama a la base de datos
    final db = await database.db;
    // Actualiza el autor por id
    return await db.update(
      tableName,
      data.toMap(),
      where: 'id = ?',
      whereArgs: [data.id],
    );
  }

  // Funcion para eliminar datos
  Future<int> delete(int id) async {
    // Llama a la base de datos
    final db = await database.db;
    // Elimina el autor por id
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  // Funcion para listar datos
  Future<List<AutoresModels>> getAll() async {
    // Llama a la base de datos
    final db = await database.db;
    // Consulta todos los autores
    final response = await db.query(tableName);
    // Convierte los datos a lista de objetos
    return response.map((e) => AutoresModels.fromMap(e)).toList();
  }

  // Funcion para validar si el autor tiene relacion con libros
  Future<bool> tieneRelacion(int autorId) async {
    // Llama a la base de datos
    final db = await database.db;

    // Consulta si existe al menos un libro con este autor
    final response = await db.query(
      'libros',
      where: 'id_autor = ?',
      whereArgs: [autorId],
      limit: 1,
    );

    // Retorna true si hay relacion
    return response.isNotEmpty;
  }
}
