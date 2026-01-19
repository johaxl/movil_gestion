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
              // intenta eliminar
              final result = await repo.delete(id);

              // cierra el diálogo
              Navigator.pop(context);

              // si está relacionado, no se elimina
              if (result == -1) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "No se puede eliminar el libro porque tiene préstamos",
                    ),
                  ),
                );
                return;
              }

              // recarga la lista si se eliminó
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
          ? const Center(child: CircularProgressIndicator())
          : libros.isEmpty
          ? const Center(child: Text("No hay libros registrados"))
          : ListView.builder(
              itemCount: libros.length,
              itemBuilder: (context, i) {
                final libro = libros[i];

                return Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.book,
                      color: Color.fromARGB(255, 107, 197, 180),
                    ),

                    // título del libro
                    title: Text(libro.titulo),

                    // autor e isbn
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Autor: ${libro.autorNombre ?? 'Sin autor'}"),
                        Text("ISBN: ${libro.isbn}"),
                      ],
                    ),

                    // botones
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
                          },
                          icon: const Icon(Icons.edit, color: Colors.orange),
                        ),
                        IconButton(
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
        backgroundColor: const Color.fromARGB(255, 107, 197, 180),
      ),
    );
  }
}
