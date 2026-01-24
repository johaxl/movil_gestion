import '../models/prestamos_models.dart';
import '../settings/database_connection.dart';

class PrestamosRepository {
  final tableName = "prestamos";
  final database = DatabaseConnection();

  Future<int> create(PrestamosModels data) async {
    final db = await database.db;
    return await db.insert(tableName, data.toMap());
  }

  Future<int> edit(PrestamosModels data) async {
    final db = await database.db;
    return await db.update(
      tableName,
      data.toMap(),
      where: 'id = ?',
      whereArgs: [data.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await database.db;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  // Listado con nombres de libro y usuario
  Future<List<PrestamosModels>> getAll() async {
    final db = await database.db;

    final response = await db.rawQuery('''
      SELECT
        p.id,
        p.id_libro,
        p.id_usuario,
        p.fecha_prestamo,
        p.fecha_devolucion,
        p.estado,
        l.titulo AS libro_nombre,
        u.nombre || ' ' || u.apellido AS usuario_nombre
      FROM prestamos p
      INNER JOIN libros l ON l.id = p.id_libro
      INNER JOIN usuarios u ON u.id = p.id_usuario
      ORDER BY p.id DESC
    ''');

    return response.map((e) => PrestamosModels.fromMap(e)).toList();
  }

  Future<bool> libroOcupado(int idLibro) async {
    final db = await database.db;

    final result = await db.rawQuery(
      '''
      SELECT COUNT(*) total
      FROM prestamos
      WHERE id_libro = ?
      AND estado IN ('ACTIVO', 'ATRASADO')
      ''',
      [idLibro],
    );

    return (result.first['total'] as int) > 0;
  }

  Future<bool> usuarioConDosLibros(int idUsuario) async {
    final db = await database.db;

    final result = await db.rawQuery(
      '''
      SELECT COUNT(*) total
      FROM prestamos
      WHERE id_usuario = ?
      AND estado IN ('ACTIVO', 'ATRASADO')
      ''',
      [idUsuario],
    );

    return (result.first['total'] as int) >= 2;
  }

  Future<void> actualizarAtrasados() async {
    final db = await database.db;

    final hoy = DateTime.now().toIso8601String().substring(0, 10);

    await db.rawUpdate(
      '''
      UPDATE prestamos
      SET estado = 'ATRASADO'
      WHERE estado = 'ACTIVO'
      AND fecha_devolucion < ?
      ''',
      [hoy],
    );
  }

  Future<void> marcarDevuelto(int id) async {
    final db = await database.db;
    await db.update(
      'prestamos',
      {'estado': 'DEVUELTO'},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<PrestamosModels>> reportePrestamos(
    String estado,
    String desde,
    String hasta,
  ) async {
    final db = await database.db;

    final response = await db.rawQuery(
      '''
    SELECT
      p.id,
      p.id_libro,
      p.id_usuario,
      p.fecha_prestamo,
      p.fecha_devolucion,
      p.estado,
      l.titulo AS libro_nombre,
      u.nombre || ' ' || u.apellido AS usuario_nombre
    FROM prestamos p
    INNER JOIN libros l ON l.id = p.id_libro
    INNER JOIN usuarios u ON u.id = p.id_usuario
    WHERE p.estado = ?
    AND date(p.fecha_prestamo) BETWEEN ? AND ?
    ORDER BY p.fecha_prestamo
  ''',
      [estado, desde, hasta],
    );

    return response.map((e) => PrestamosModels.fromMap(e)).toList();
  }
}
