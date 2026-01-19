import 'package:flutter/material.dart';
import '../models/libros_models.dart';
import '../repositories/libros_repository.dart';

class LibroScreen extends StatefulWidget {
  const LibroScreen({super.key});

  @override
  State<LibroScreen> createState() => _LibroScreenState();
}

class _LibroScreenState extends State<LibroScreen> {
  final LibrosRepository repo = LibrosRepository();

  List<LibrosModels> libros = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarLibros();
  }

  Future<void> cargarLibros() async {
    setState(() => cargando = true);
    libros = await repo.getAll();
    setState(() => cargando = false);
  }

  void eliminarLibro(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Eliminar Libro"),
        content: Text("¿Desea eliminar el libro?"),
        actions: [
          TextButton(
            onPressed: () async {
              await repo.delete(id);
              Navigator.pop(context);
              cargarLibros();
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
      appBar: AppBar(
        title: Text("Listado de Libros"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: cargando
          ? Center(child: CircularProgressIndicator())
          : libros.isEmpty
          ? Center(child: Text("No hay libros registrados"))
          : ListView.builder(
              itemCount: libros.length,
              itemBuilder: (context, i) {
                final libro = libros[i];
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.book, color: Colors.blue),
                    title: Text(libro.titulo),
                    subtitle: Text("ISBN: ${libro.isbn}"),
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
                          icon: Icon(Icons.edit, color: Colors.orange),
                        ),
                        IconButton(
                          onPressed: () => eliminarLibro(libro.id!),
                          icon: Icon(Icons.delete, color: Colors.red),
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
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
