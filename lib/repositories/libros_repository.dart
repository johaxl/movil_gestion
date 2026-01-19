import '../models/libros_models.dart';
import '../settings/database_connection.dart';

class LibrosRepository {
  final tableName = "libros";
  final database = DatabaseConnection();

  // Funcion para insertar datos
  Future<int> create(LibrosModels data) async {
    // 1. llama a la funcion
    final db = await database.db;
    // 2. ejecuta el sql
    return await db.insert(tableName, data.toMap());
  }

  // funcion para editar datos
  Future<int> edit(LibrosModels data) async {
    // 1. llama a la funcion
    final db = await database.db;
    // 2. ejecuta el sql
    return await db.update(
      tableName,
      data.toMap(),
      where: 'id = ?',
      whereArgs: [data.id],
    );
  }

  // Funcion para eliminar datos
  Future<int> delete(int id) async {
    // 1. llama a la funcion
    final db = await database.db;
    // 2. ejecuta el sql
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  // Funcion para listar datos
  Future<List<LibrosModels>> getAll() async {
    // 1. llama a la funcion
    final db = await database.db;
    // 2. ejecuta el sql
    final response = await db.query(tableName);
    // 3. retorna y trasformar los datos de json a clase
    return response.map((e) => LibrosModels.fromMap(e)).toList();
  }
}
