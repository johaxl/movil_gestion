import 'package:flutter/material.dart';
import '../models/prestamos_models.dart';
import '../repositories/prestamos_repository.dart';

// pantalla principal de prestamos
class PrestamoScreen extends StatefulWidget {
  const PrestamoScreen({super.key});

  @override
  State<PrestamoScreen> createState() => _PrestamoScreenState();
}

class _PrestamoScreenState extends State<PrestamoScreen> {
  // objeto para usar la base de datos
  final PrestamosRepository repo = PrestamosRepository();

  // lista donde se guardan los prestamos
  List<PrestamosModels> prestamos = [];

  // variable para saber si esta cargando
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    // se ejecuta al iniciar la pantalla
    cargarPrestamos();
  }

  // carga todos los prestamos
  Future<void> cargarPrestamos() async {
    setState(() => cargando = true);

    // actualiza los prestamos atrasados
    await repo.actualizarAtrasados();

    // obtiene los datos
    prestamos = await repo.getAll();
    setState(() => cargando = false);
  }

  // calcula dias de atraso
  int calcularDiasAtraso(PrestamosModels p) {
    if (p.estado != "ATRASADO") return 0;
    final hoy = DateTime.now();
    final fechaDev = DateTime.parse(p.fechaDevolucion);
    return hoy.difference(fechaDev).inDays;
  }

  // devuelve un color segun el estado
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

  // devuelve un icono segun el estado
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

  // elimina un prestamo
  void eliminarPrestamo(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Eliminar Prestamo"),
        content: const Text("Eliminar el prestamo"),
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

  // abre pantalla para editar
  void editarPrestamo(PrestamosModels p) async {
    await Navigator.pushNamed(context, '/prestamo/form', arguments: p);
    cargarPrestamos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // barra superior
      appBar: AppBar(
        title: const Text("Listado de Prestamos"),
        backgroundColor: const Color.fromARGB(255, 242, 201, 76),
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.report),
            tooltip: "Reporte",
            onPressed: () {
              Navigator.pushNamed(context, '/reporte');
            },
          ),
        ],
      ),

      // cuerpo de la pantalla
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : prestamos.isEmpty
          ? const Center(child: Text("No hay prestamos registrados"))
          : ListView.builder(
              itemCount: prestamos.length,
              itemBuilder: (context, i) {
                final p = prestamos[i];
                final diasAtraso = calcularDiasAtraso(p);

                return Card(
                  child: ListTile(
                    // icono segun estado
                    leading: Icon(
                      iconoEstado(p.estado),
                      color: colorEstado(p.estado),
                    ),

                    // muestra libro y usuario
                    title: Text(
                      "${p.libroNombre ?? "Libro"}  |  ${p.usuarioNombre ?? "Usuario"}",
                    ),

                    // informacion del prestamo
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Prestamo: ${p.fechaPrestamo}"),
                        Text("Devolucion: ${p.fechaDevolucion}"),
                        Text("Estado: ${p.estado}"),
                        if (p.estado == "ATRASADO")
                          Text("Dias de atraso: $diasAtraso"),
                      ],
                    ),

                    // botones de acciones
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (p.estado != "DEVUELTO")
                          IconButton(
                            icon: const Icon(Icons.assignment_turned_in),
                            onPressed: () async {
                              await repo.marcarDevuelto(p.id!);
                              cargarPrestamos();
                            },
                          ),
                        if (p.estado == "DEVUELTO")
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => eliminarPrestamo(p.id!),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),

      // boton para agregar prestamo
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/prestamo/form');
          cargarPrestamos();
        },
        backgroundColor: const Color.fromARGB(255, 242, 201, 76),
        child: const Icon(Icons.add),
      ),
    );
  }
}
