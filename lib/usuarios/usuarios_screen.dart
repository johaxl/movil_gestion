import 'package:flutter/material.dart';
// importa los componentes basicos de flutter

import '../models/usuarios_models.dart';
// importa el modelo de usuario

import '../repositories/usuarios_repository.dart';
// importa la clase que maneja la base de datos

class UsuarioScreen extends StatefulWidget {
  const UsuarioScreen({super.key});

  @override
  State<UsuarioScreen> createState() => _UsuarioScreenState();
}

class _UsuarioScreenState extends State<UsuarioScreen> {
  // repositorio para acceder a la base de datos
  final UsuariosRepository repo = UsuariosRepository();

  // lista donde se guardan los usuarios
  List<UsuariosModels> usuarios = [];

  // controla si esta cargando datos
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarUsuarios();
    // se ejecuta al iniciar la pantalla
  }

  // obtiene todos los usuarios de la base
  Future<void> cargarUsuarios() async {
    setState(() => cargando = true);
    usuarios = await repo.getAll();
    setState(() => cargando = false);
  }

  // elimina un usuario si no tiene relacion
  Future<void> eliminarUsuario(int id) async {
    // verifica si el usuario tiene relacion
    final tieneRelacion = await repo.tieneRelacion(id);

    // si tiene relacion muestra mensaje
    if (tieneRelacion) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("No se puede eliminar"),
          content: Text(
            "Este usuario tiene registros relacionados y no puede eliminarse",
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

    // si no tiene relacion pide confirmacion
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Eliminar Usuario"),
        content: Text("Esta seguro de eliminar el usuario"),
        actions: [
          TextButton(
            onPressed: () async {
              await repo.delete(id);
              Navigator.pop(context);
              cargarUsuarios();
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
        title: const Text("Listado de Usuarios"),
        backgroundColor: const Color.fromARGB(255, 145, 93, 17),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      // si esta cargando muestra loading
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          // si no hay usuarios muestra mensaje
          : usuarios.isEmpty
          ? const Center(child: Text("No hay usuarios registrados"))
          // si hay usuarios los muestra en lista
          : ListView.builder(
              itemCount: usuarios.length,
              itemBuilder: (context, i) {
                final user = usuarios[i];

                return Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.person,
                      color: Color.fromARGB(255, 145, 93, 17),
                    ),

                    // muestra nombre y apellido
                    title: Text("${user.nombre} ${user.apellido}"),

                    // muestra cedula y correo
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Cedula: ${user.cedula}"),
                        Text("Correo: ${user.correo}"),
                      ],
                    ),

                    // botones editar y eliminar
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () async {
                            await Navigator.pushNamed(
                              context,
                              '/usuario/form',
                              arguments: user,
                            );
                            cargarUsuarios();
                          },
                          icon: const Icon(Icons.edit, color: Colors.orange),
                        ),
                        IconButton(
                          onPressed: () => eliminarUsuario(user.id!),
                          icon: const Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

      // boton flotante para agregar usuario
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/usuario/form');
          cargarUsuarios();
        },
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 145, 93, 17),
      ),
    );
  }
}
