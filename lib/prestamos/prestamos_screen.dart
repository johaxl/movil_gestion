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

    // actualizar automáticamente ATRASADO
    await repo.actualizarAtrasados();

    prestamos = await repo.getAll();
    setState(() => cargando = false);
  }

  int calcularDiasAtraso(PrestamosModels p) {
    if (p.estado != "ATRASADO") return 0;
    final hoy = DateTime.now();
    final fechaDev = DateTime.parse(p.fechaDevolucion);
    return hoy.difference(fechaDev).inDays;
  }

  Color colorEstado(String estado) {
    switch (estado) {
      case "ACTIVO":
        return Colors.green;
      case "DEVUELTO":
        return Colors.blue;
      case "ATRASADO":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData iconoEstado(String estado) {
    switch (estado) {
      case "ACTIVO":
        return Icons.schedule;
      case "DEVUELTO":
        return Icons.check_circle;
      case "ATRASADO":
        return Icons.warning;
      default:
        return Icons.info;
    }
  }

  void eliminarPrestamo(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Eliminar Préstamo"),
        content: const Text("¿Eliminar el préstamo?"),
        actions: [
          TextButton(
            onPressed: () async {
              await repo.delete(id);
              Navigator.pop(context);
              cargarPrestamos();
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

  void editarPrestamo(PrestamosModels p) async {
    await Navigator.pushNamed(context, '/prestamo/form', arguments: p);
    cargarPrestamos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Listado de Préstamos"),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : prestamos.isEmpty
          ? const Center(child: Text("No hay préstamos registrados"))
          : ListView.builder(
              itemCount: prestamos.length,
              itemBuilder: (context, i) {
                final p = prestamos[i];
                final diasAtraso = calcularDiasAtraso(p);

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: ListTile(
                    leading: Icon(
                      iconoEstado(p.estado),
                      color: colorEstado(p.estado),
                    ),
                    title: Text(
                      "${p.libroNombre ?? "Libro"}  |  ${p.usuarioNombre ?? "Usuario"}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Préstamo: ${p.fechaPrestamo}"),
                        Text("Devolución: ${p.fechaDevolucion}"),
                        Text(
                          "Estado: ${p.estado}",
                          style: TextStyle(
                            color: colorEstado(p.estado),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (p.estado == "ATRASADO")
                          Text(
                            "Días de atraso: $diasAtraso",
                            style: const TextStyle(
                              color: Color.fromARGB(255, 90, 84, 83),
                            ),
                          ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () => editarPrestamo(p),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => eliminarPrestamo(p.id!),
                        ),
                      ],
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
        backgroundColor: Colors.red.shade700,
        child: const Icon(Icons.add),
      ),
    );
  }
}
