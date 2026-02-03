import 'package:flutter/material.dart';

import '../models/usuarios_models.dart';
import '../repositories/usuarios_repository.dart';
import '../widgets/app.drawer.dart';

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

  // Valida si tiene relación antes de eliminar
  Future<void> eliminarUsuario(int id) async {
    // Verifica si el usuario está relacionado
    final tieneRelacion = await repo.tieneRelacion(id);

    // Si tiene relación, no permite eliminar
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

    // Si no tiene relación, pide confirmación
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Eliminar Usuario"),
        content: Text("¿Está seguro de eliminar el usuario?"),
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
      drawer: AppDrawer(),

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
