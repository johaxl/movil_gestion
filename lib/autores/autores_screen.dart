import 'package:flutter/material.dart';
import '../models/autores_models.dart';
import '../repositories/autores_repository.dart';

class AutorScreen extends StatefulWidget {
  const AutorScreen({super.key});

  @override
  State<AutorScreen> createState() => _AutorScreenState();
}

class _AutorScreenState extends State<AutorScreen> {
  // Instancia del repositorio de autores
  final AutoresRepository repo = AutoresRepository();

  // Lista donde se guardan los autores
  List<AutoresModels> autores = [];

  // Controla el estado de carga
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarAutores();
  }

  // Obtiene todos los autores desde la base de datos
  Future<void> cargarAutores() async {
    setState(() => cargando = true);
    autores = await repo.getAll();
    setState(() => cargando = false);
  }

  // Valida si el autor tiene relación antes de eliminar
  Future<void> eliminarAutor(int id) async {
    // Verifica si el autor está relacionado
    final tieneRelacion = await repo.tieneRelacion(id);

    // Si tiene relación, no permite eliminar
    if (tieneRelacion) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("No se puede eliminar"),
          content: Text(
            "Este autor tiene registros relacionados y no puede eliminarse",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Aceptar"),
            ),
          ],
        ),
      );
      return;
    }

    // Si no tiene relación, pide confirmación
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

      // Muestra un cargador mientras se obtienen los datos
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

                    // Nombre completo del autor
                    title: Text("${autor.nombre} ${autor.apellido}"),

                    // Información adicional del autor
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

                    // Botones de editar y eliminar
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

      // Botón para agregar un nuevo autor
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
