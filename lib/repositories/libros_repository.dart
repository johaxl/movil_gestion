import '../models/libros_models.dart';
import '../settings/database_connection.dart';

class LibrosRepository {
  final tableName = "libros";
  final database = DatabaseConnection();

  // insertar libro
  Future<int> create(LibrosModels data) async {
    final db = await database.db;
    return await db.insert(tableName, data.toMap());
  }

  // editar libro
  Future<int> edit(LibrosModels data) async {
    final db = await database.db;
    return await db.update(
      tableName,
      data.toMap(),
      where: 'id = ?',
      whereArgs: [data.id],
    );
  }

  // valida si el libro tiene relación con préstamos
  Future<bool> tieneRelacion(int libroId) async {
    final db = await database.db;

    final response = await db.query(
      'prestamos',
      where: 'id_libro = ?',
      whereArgs: [libroId],
      limit: 1,
    );

    return response.isNotEmpty;
  }

  // eliminar libro SOLO si no tiene relación
  Future<int> delete(int id) async {
    final db = await database.db;

    // valida relación
    final relacionado = await tieneRelacion(id);

    if (relacionado) {
      // no permite eliminar
      return -1;
    }

    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  // listar libros con nombre del autor
  Future<List<LibrosModels>> getAll() async {
    final db = await database.db;

    final response = await db.rawQuery('''
      SELECT 
        l.id,
        l.titulo,
        l.isbn,
        l.id_autor,
        l.anio_publicacion,
        l.editorial,
        a.nombre || ' ' || a.apellido AS autor_nombre
      FROM libros l
      INNER JOIN autores a ON a.id = l.id_autor
    ''');

    return response.map((e) => LibrosModels.fromMap(e)).toList();
  }
}
