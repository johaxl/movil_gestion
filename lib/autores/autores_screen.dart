import 'package:flutter/material.dart';
import '../models/autores_models.dart';
import '../repositories/autores_repository.dart';

class AutorScreen extends StatefulWidget {
  const AutorScreen({super.key});
  // pantalla principal de autores

  @override
  State<AutorScreen> createState() => _AutorScreenState();
  // crea el estado de la pantalla
}

class _AutorScreenState extends State<AutorScreen> {
  final AutoresRepository repo = AutoresRepository();
  // objeto para acceder a la base de datos

  List<AutoresModels> autores = [];
  // lista donde se guardan los autores

  bool cargando = true;
  // controla si esta cargando

  @override
  void initState() {
    super.initState();
    cargarAutores();
    // se ejecuta al iniciar la pantalla
  }

  Future<void> cargarAutores() async {
    setState(() => cargando = true);
    // activa el estado cargando

    autores = await repo.getAll();
    // obtiene todos los autores

    setState(() => cargando = false);
    // desactiva el estado cargando
  }

  Future<void> eliminarAutor(int id) async {
    final tieneRelacion = await repo.tieneRelacion(id);
    // verifica si el autor tiene relacion

    if (tieneRelacion) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("No se puede eliminar"),

          // titulo del mensaje
          content: Text(
            "Este autor tiene registros relacionados y no puede eliminarse",
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
        title: Text("Eliminar Autor"),

        // titulo del dialogo
        content: Text("¿Está seguro de eliminar el autor?"),

        // pide confirmacion
        actions: [
          TextButton(
            onPressed: () async {
              await repo.delete(id);
              // elimina en la base de datos

              Navigator.pop(context);
              // cierra el dialogo

              cargarAutores();
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
        title: Text("Listado de Autores"),
        backgroundColor: const Color.fromARGB(255, 74, 144, 226),
        foregroundColor: Colors.white,
        centerTitle: true,
        // barra superior
      ),

      body: cargando
          ? SingleChildScrollView(
              child: Center(child: CircularProgressIndicator()),
            )
          // muestra cargando
          : autores.isEmpty
          ? Center(child: Text("No hay autores registrados"))
          // muestra mensaje si no hay datos
          : ListView.builder(
              itemCount: autores.length,

              // cantidad de autores
              itemBuilder: (context, i) {
                final autor = autores[i];
                // obtiene un autor

                return Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.person,
                      color: const Color.fromARGB(255, 74, 144, 226),
                    ),

                    // icono del autor
                    title: Text("${autor.nombre} ${autor.apellido}"),

                    // muestra nombre completo
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Nacionalidad: ${autor.nacionalidad}"),

                        // muestra nacionalidad
                        Text(
                          autor.fechaNacimiento,
                          style: TextStyle(fontSize: 12),
                        ),
                        // muestra fecha
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
                            // va a editar y recarga
                          },
                          icon: Icon(Icons.edit, color: Colors.orange),
                        ),
                        IconButton(
                          onPressed: () => eliminarAutor(autor.id!),

                          // elimina el autor
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
          // va a crear y recarga
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 74, 144, 226),
        // boton para agregar
      ),
    );
  }
}
