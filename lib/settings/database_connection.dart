import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// capa logica para el manejo de los datos
class DatabaseConnection {
  // generando un contructor para el llado
  static final DatabaseConnection instance = DatabaseConnection.internal();
  factory DatabaseConnection() => instance;

  DatabaseConnection.internal();

  // crear un llamado de la base de datos (? es para dar valor null )
  static Database? database;

  // Funcion para crear la conexion a la base de datos (db es la conexion) (! este es para variables null)
  Future<Database> get db async {
    if (database != null)
      return database!; // Retorna la base de datos si ya esta inicializada

    database =
        await inicializarDb(); // Inicializa la conexion con la nueva conexion
    return database!; // Retorna la conexion  con la nueva conexion
  }

  // Funcion para inicializar
  Future<Database> inicializarDb() async {
    // ruta de la base de datos
    final rutaDb =
        await getDatabasesPath(); // ruta donde estan las base de datos
    final rutaFinal = join(rutaDb, 'gestion.db'); // esto pone la ruta final

    return await openDatabase(
      rutaFinal,
      version: 1,
      onCreate: (Database db, int version) async {
        // Crear todos los script de las tablas o datos iniciales
        await db.execute('''
            CREATE TABLE autores (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              nombre TEXT NOT NULL,
              apellido TEXT NOT NULL,
              nacionalidad TEXT,
              fecha_nacimiento TEXT,
              generoliterario TEXT
          )
      ''');
        await db.execute('''
            CREATE TABLE libros (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              titulo TEXT NOT NULL,
              isbn TEXT UNIQUE,
              anio_publicacion INTEGER,
              id_autor INTEGER,
              editorial TEXT,
              FOREIGN KEY (id_autor) REFERENCES autores(id)
          )
      ''');
        await db.execute('''
            CREATE TABLE usuarios (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              nombre TEXT NOT NULL,
              apellido TEXT NOT NULL,
              cedula TEXT UNIQUE,
              telefono TEXT NOT NULL,
              correo TEXT NOT NULL
            )
      ''');
        await db.execute('''
            CREATE TABLE prestamos (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              id_libro INTEGER NOT NULL,
              id_usuario INTEGER NOT NULL,
              fecha_prestamo TEXT NOT NULL,
              fecha_devolucion TEXT,
              estado TEXT,
              FOREIGN KEY (id_libro) REFERENCES libros(id),
              FOREIGN KEY (id_usuario) REFERENCES usuarios(id)
          )
      ''');
      },
    );
  }
}
