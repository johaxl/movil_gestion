import '../models/autores_models.dart';
import '../settings/database_connection.dart';

class AutoresRepository {
  final tableName = "autores";
  final database = DatabaseConnection();

  // Funcion para insertar datos
  Future<int> create(AutoresModels data) async {
    // 1. llama a la funcion
    final db = await database.db;
    // 2. ejecuta el sql
    return await db.insert(tableName, data.toMap());
  }

  // funcion para editar datos
  Future<int> edit(AutoresModels data) async {
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
  Future<List<AutoresModels>> getAll() async {
    // 1. llama a la funcion
    final db = await database.db;
    // 2. ejecuta el sql
    final response = await db.query(tableName);
    // 3. retorna y trasformar los datos de json a clase
    return response.map((e) => AutoresModels.fromMap(e)).toList();
  }
}
