import 'package:flutter/material.dart';

import '../models/usuarios_models.dart';
import '../repositories/usuarios_repository.dart';

class UsuarioScreen extends StatefulWidget {
  const UsuarioScreen({super.key});

  @override
  State<UsuarioScreen> createState() => _UsuarioScreenState();
}

class _UsuarioScreenState extends State<UsuarioScreen> {
  final UsuariosRepository repo = UsuariosRepository();

  List<UsuariosModels> usuarios = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarUsuarios();
  }

  Future<void> cargarUsuarios() async {
    setState(() => cargando = true);
    usuarios = await repo.getAll();
    setState(() => cargando = false);
  }

  void eliminarUsuario(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Eliminar Usuario"),
        content: Text("¿Eliminar usuario?"),
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
        title: Text("Listado de Usuarios"),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: cargando
          ? Center(child: CircularProgressIndicator())
          : usuarios.isEmpty
          ? Center(child: Text("No hay usuarios registrados"))
          : ListView.builder(
              itemCount: usuarios.length,
              itemBuilder: (context, i) {
                final user = usuarios[i];
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.people, color: Colors.purple),
                    title: Text("${user.nombre} ${user.apellido}"),
                    subtitle: Text(user.cedula),
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
                          icon: Icon(Icons.edit, color: Colors.orange),
                        ),
                        IconButton(
                          onPressed: () => eliminarUsuario(user.id!),
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
          await Navigator.pushNamed(context, '/usuario/form');
          cargarUsuarios();
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.purple,
      ),
    );
  }
}
