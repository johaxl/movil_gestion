import 'package:flutter/material.dart';

import '../models/prestamos_models.dart';
import '../repositories/prestamos_repository.dart';

class PrestamoScreen extends StatefulWidget {
  const PrestamoScreen({super.key});

  @override
  State<PrestamoScreen> createState() => _PrestamoScreenState();
}

class _PrestamoScreenState extends State<PrestamoScreen> {
  final PrestamosRepository repo = PrestamosRepository();

  List<PrestamosModels> prestamos = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarPrestamos();
  }

  Future<void> cargarPrestamos() async {
    setState(() => cargando = true);
    prestamos = await repo.getAll();
    setState(() => cargando = false);
  }

  void eliminarPrestamo(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Eliminar Préstamo"),
        content: Text("¿Eliminar el préstamo?"),
        actions: [
          TextButton(
            onPressed: () async {
              await repo.delete(id);
              Navigator.pop(context);
              cargarPrestamos();
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
        title: Text("Listado de Préstamos"),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: cargando
          ? Center(child: CircularProgressIndicator())
          : prestamos.isEmpty
          ? Center(child: Text("No hay préstamos registrados"))
          : ListView.builder(
              itemCount: prestamos.length,
              itemBuilder: (context, i) {
                final p = prestamos[i];
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.assignment, color: Colors.red),
                    title: Text("Libro ID: ${p.idLibro}"),
                    subtitle: Text("Usuario ID: ${p.idUsuario}"),
                    trailing: IconButton(
                      onPressed: () => eliminarPrestamo(p.id!),
                      icon: Icon(Icons.delete, color: Colors.red),
                    ),
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/prestamo/form');
          cargarPrestamos();
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.red.shade700,
      ),
    );
  }
}
