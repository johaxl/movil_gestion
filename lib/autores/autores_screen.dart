import 'package:flutter/material.dart';
import '../models/autores_models.dart';
import '../repositories/autores_repository.dart';

class AutorScreen extends StatefulWidget {
  const AutorScreen({super.key});

  @override
  State<AutorScreen> createState() => _AutorScreenState();
}

class _AutorScreenState extends State<AutorScreen> {
  final AutoresRepository repo = AutoresRepository();

  List<AutoresModels> autores = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarAutores();
  }

  Future<void> cargarAutores() async {
    setState(() => cargando = true);
    autores = await repo.getAll();
    setState(() => cargando = false);
  }

  void eliminarAutor(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Eliminar Autor"),
        content: Text("¿Está seguro de eliminar el autor?"),
        actions: [
          TextButton(
            onPressed: () async {
              await repo.delete(id);
              Navigator.pop(context);
              cargarAutores();
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
        title: Text("Listado de Autores"),
        backgroundColor: const Color.fromARGB(255, 74, 144, 226),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: cargando
          ? Center(child: CircularProgressIndicator())
          : autores.isEmpty
          ? Center(child: Text("No hay autores registrados"))
          : ListView.builder(
              itemCount: autores.length,
              itemBuilder: (context, i) {
                final autor = autores[i];
                return Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.person,
                      color: const Color.fromARGB(255, 74, 144, 226),
                    ),
                    title: Text("${autor.nombre} ${autor.apellido}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Nacionalidad: ${autor.nacionalidad}"),
                        Text(
                          autor.fechaNacimiento,
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () async {
                            await Navigator.pushNamed(
                              context,
                              '/autor/form',
                              arguments: autor,
                            );
                            cargarAutores();
                          },
                          icon: Icon(Icons.edit, color: Colors.orange),
                        ),
                        IconButton(
                          onPressed: () => eliminarAutor(autor.id!),
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
          await Navigator.pushNamed(context, '/autor/form');
          cargarAutores();
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 74, 144, 226),
      ),
    );
  }
}
