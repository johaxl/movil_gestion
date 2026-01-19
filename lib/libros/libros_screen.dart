import 'package:flutter/material.dart';
import '../models/libros_models.dart';
import '../repositories/libros_repository.dart';

class LibroScreen extends StatefulWidget {
  const LibroScreen({super.key});

  @override
  State<LibroScreen> createState() => _LibroScreenState();
}

class _LibroScreenState extends State<LibroScreen> {
  // repositorio para acceder a la base de datos
  final LibrosRepository repo = LibrosRepository();

  // lista de libros
  List<LibrosModels> libros = [];

  // controla si se están cargando los datos
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    // carga los libros al iniciar la pantalla
    cargarLibros();
  }

  // obtiene todos los libros desde la base de datos
  Future<void> cargarLibros() async {
    setState(() => cargando = true);
    libros = await repo.getAll();
    setState(() => cargando = false);
  }

  // muestra un cuadro para confirmar la eliminación
  void eliminarLibro(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Eliminar Libro"),
        content: const Text("¿Desea eliminar el libro?"),
        actions: [
          TextButton(
            onPressed: () async {
              // elimina el libro
              await repo.delete(id);
              // cierra el diálogo
              Navigator.pop(context);
              // recarga la lista
              cargarLibros();
            },
            child: const Text("SI"),
          ),
          TextButton(
            // cierra el diálogo sin eliminar
            onPressed: () => Navigator.pop(context),
            child: const Text("NO"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // barra superior
      appBar: AppBar(
        title: const Text("Listado de Libros"),
        backgroundColor: const Color.fromARGB(255, 107, 197, 180),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      // cuerpo de la pantalla
      body: cargando
          // muestra cargando
          ? const Center(child: CircularProgressIndicator())
          // mensaje si no hay datos
          : libros.isEmpty
          ? const Center(child: Text("No hay libros registrados"))
          // lista de libros
          : ListView.builder(
              itemCount: libros.length,
              itemBuilder: (context, i) {
                final libro = libros[i];

                return Card(
                  child: ListTile(
                    // icono del libro
                    leading: const Icon(Icons.book, color: Colors.blue),

                    // muestra el título del libro
                    title: Text(libro.titulo),

                    // muestra el autor y el isbn
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Autor: ${libro.autorNombre ?? 'Sin autor'}"),
                        Text("ISBN: ${libro.isbn}"),
                      ],
                    ),

                    // botones de editar y eliminar
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          // abre el formulario para editar
                          onPressed: () async {
                            await Navigator.pushNamed(
                              context,
                              '/libro/form',
                              arguments: libro,
                            );
                            // recarga la lista
                            cargarLibros();
                          },
                          icon: const Icon(Icons.edit, color: Colors.orange),
                        ),
                        IconButton(
                          // elimina el libro
                          onPressed: () => eliminarLibro(libro.id!),
                          icon: const Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

      // botón para agregar libro
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/libro/form');
          cargarLibros();
        },
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
