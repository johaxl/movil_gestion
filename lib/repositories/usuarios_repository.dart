import '../models/usuarios_models.dart';
import '../settings/database_connection.dart';

class UsuariosRepository {
  final tableName = "usuarios";
  final database = DatabaseConnection();

  // insertar un usuario
  Future<int> create(UsuariosModels data) async {
    final db = await database.db;
    return await db.insert(tableName, data.toMap());
  }

  // editar un usuario
  Future<int> edit(UsuariosModels data) async {
    final db = await database.db;
    return await db.update(
      tableName,
      data.toMap(),
      where: 'id = ?',
      whereArgs: [data.id],
    );
  }

  // eliminar usuario solo si no está relacionado
  Future<int> delete(int id) async {
    final db = await database.db;

    // verificar si el usuario tiene registros relacionados en prestamos
    final response = await db.rawQuery(
      'SELECT COUNT(*) as total FROM prestamos WHERE id_usuario = ?',
      [id],
    );

    final total = response.first['total'] as int;

    // si tiene relación no se elimina
    if (total > 0) {
      return -1;
    }

    // eliminar si no tiene relación
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  // listar todos los usuarios
  Future<List<UsuariosModels>> getAll() async {
    final db = await database.db;
    final response = await db.query(tableName);
    return response.map((e) => UsuariosModels.fromMap(e)).toList();
  }
}
