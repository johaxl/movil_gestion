import 'package:flutter/material.dart';
import '../models/libros_models.dart';
import '../repositories/libros_repository.dart';

class LibroScreen extends StatefulWidget {
  const LibroScreen({super.key});
  // pantalla principal de libros

  @override
  State<LibroScreen> createState() => _LibroScreenState();
  // crea el estado de la pantalla
}

class _LibroScreenState extends State<LibroScreen> {
  final LibrosRepository repo = LibrosRepository();
  // objeto para acceder a la base de datos

  List<LibrosModels> libros = [];
  // lista donde se guardan los libros

  bool cargando = true;
  // controla si se estan cargando los datos

  @override
  void initState() {
    super.initState();
    cargarLibros();
    // se ejecuta al iniciar la pantalla
  }

  Future<void> cargarLibros() async {
    setState(() => cargando = true);
    // activa el estado cargando

    libros = await repo.getAll();
    // obtiene todos los libros

    setState(() => cargando = false);
    // desactiva el estado cargando
  }

  Future<void> eliminarLibro(int id) async {
    final tieneRelacion = await repo.tieneRelacion(id);
    // verifica si el libro tiene relacion

    if (tieneRelacion) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("No se puede eliminar"),

          // titulo del mensaje
          content: Text(
            "Este libro tiene registros relacionados y no puede eliminarse",
          ),

          // mensaje de advertencia
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Aceptar"),
            ),
          ],
        ),
      );
      return;
      // no deja eliminar
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Eliminar Libro"),

        // titulo del dialogo
        content: Text("Esta seguro de eliminar el libro"),

        // pide confirmacion
        actions: [
          TextButton(
            onPressed: () async {
              await repo.delete(id);
              // elimina el libro en la base de datos

              Navigator.pop(context);
              // cierra el dialogo

              cargarLibros();
              // recarga la lista
            },
            child: Text("SI"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("NO"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // estructura principal
      appBar: AppBar(
        title: const Text("Listado de Libros"),
        backgroundColor: const Color.fromARGB(255, 107, 197, 180),
        foregroundColor: Colors.white,
        centerTitle: true,
        // barra superior
      ),

      body: cargando
          ? const Center(child: CircularProgressIndicator())
          // muestra cargando
          : libros.isEmpty
          ? const Center(child: Text("No hay libros registrados"))
          // mensaje si no hay datos
          : ListView.builder(
              itemCount: libros.length,

              // cantidad de libros
              itemBuilder: (context, i) {
                final libro = libros[i];
                // obtiene un libro

                return Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.book,
                      color: Color.fromARGB(255, 107, 197, 180),
                    ),

                    // icono del libro
                    title: Text(libro.titulo),

                    // muestra el titulo
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Autor: ${libro.autorNombre ?? 'Sin autor'}"),

                        // muestra el autor
                        Text("ISBN: ${libro.isbn}"),
                        // muestra el isbn
                      ],
                    ),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () async {
                            await Navigator.pushNamed(
                              context,
                              '/libro/form',
                              arguments: libro,
                            );
                            cargarLibros();
                            // va a editar y recarga
                          },
                          icon: const Icon(Icons.edit, color: Colors.orange),
                        ),
                        IconButton(
                          onPressed: () => eliminarLibro(libro.id!),

                          // elimina el libro
                          icon: const Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/libro/form');
          cargarLibros();
          // va a crear y recarga
        },
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 107, 197, 180),
        // boton para agregar libro
      ),
    );
  }
}
