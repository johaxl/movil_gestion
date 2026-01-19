import 'package:flutter/material.dart';

import '../models/usuarios_models.dart';
import '../repositories/usuarios_repository.dart';

class UsuarioScreen extends StatefulWidget {
  const UsuarioScreen({super.key});

  @override
  State<UsuarioScreen> createState() => _UsuarioScreenState();
}

class _UsuarioScreenState extends State<UsuarioScreen> {
  // repositorio de usuarios
  final UsuariosRepository repo = UsuariosRepository();

  // lista de usuarios
  List<UsuariosModels> usuarios = [];

  // controla la carga
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarUsuarios();
  }

  // carga los usuarios
  Future<void> cargarUsuarios() async {
    setState(() => cargando = true);
    usuarios = await repo.getAll();
    setState(() => cargando = false);
  }

  // intenta eliminar un usuario
  void eliminarUsuario(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Eliminar Usuario"),
        content: const Text("¿Eliminar usuario?"),
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
                      "No se puede eliminar el usuario porque tiene préstamos",
                    ),
                  ),
                );
                return;
              }

              // recarga la lista si se eliminó
              cargarUsuarios();
            },
            child: const Text("SI"),
          ),
          TextButton(
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
      appBar: AppBar(
        title: const Text("Listado de Usuarios"),
        backgroundColor: const Color.fromARGB(255, 145, 93, 17),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : usuarios.isEmpty
          ? const Center(child: Text("No hay usuarios registrados"))
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

                    // nombre completo
                    title: Text("${user.nombre} ${user.apellido}"),

                    // cédula y correo
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Cédula: ${user.cedula}"),
                        Text("Correo: ${user.correo}"),
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
