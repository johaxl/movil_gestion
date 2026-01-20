import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/prestamos_models.dart';
import '../models/libros_models.dart';
import '../models/usuarios_models.dart';

import '../repositories/prestamos_repository.dart';
import '../repositories/libros_repository.dart';
import '../repositories/usuarios_repository.dart';

class PrestamoFormScreen extends StatefulWidget {
  const PrestamoFormScreen({super.key});

  @override
  State<PrestamoFormScreen> createState() => _PrestamoFormScreenState();
}

class _PrestamoFormScreenState extends State<PrestamoFormScreen> {
  final formPrestamo = GlobalKey<FormState>();

  int? idLibro;
  int? idUsuario;

  final fechaPrestamoController = TextEditingController();
  final fechaDevolucionController = TextEditingController();

  String estado = "ACTIVO";

  PrestamosModels? prestamo;
  bool esEditar = false;

  List<LibrosModels> librosDisponibles = [];
  List<UsuariosModels> usuarios = [];

  final librosRepo = LibrosRepository();
  final usuariosRepo = UsuariosRepository();
  final prestamosRepo = PrestamosRepository();

  @override
  void initState() {
    super.initState();
    fechaPrestamoController.text = DateFormat(
      'yyyy-MM-dd',
    ).format(DateTime.now());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;

    if (args != null) {
      prestamo = args as PrestamosModels;
      esEditar = true;

      idLibro = prestamo!.idLibro;
      idUsuario = prestamo!.idUsuario;

      fechaPrestamoController.text = prestamo!.fechaPrestamo;
      fechaDevolucionController.text = prestamo!.fechaDevolucion;
      estado = prestamo!.estado;
    }

    cargarDatos();
  }

  // carga usuarios y libros disponibles
  Future<void> cargarDatos() async {
    usuarios = await usuariosRepo.getAll();
    final libros = await librosRepo.getAll();

    librosDisponibles.clear();

    for (var libro in libros) {
      final ocupado = await prestamosRepo.libroOcupado(libro.id!);
      if (!ocupado || (esEditar && libro.id == idLibro)) {
        librosDisponibles.add(libro);
      }
    }

    setState(() {});
  }

  // calcula el estado del préstamo
  void calcularEstado() {
    if (estado == "DEVUELTO") return;

    final hoy = DateTime.now();
    final devolucion = DateTime.parse(fechaDevolucionController.text);

    estado = devolucion.isBefore(hoy) ? "ATRASADO" : "ACTIVO";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(esEditar ? "Editar Préstamo" : "Nuevo Préstamo"),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: formPrestamo,
          child: Column(
            children: [
              DropdownButtonFormField<int>(
                value: idUsuario,
                decoration: InputDecoration(
                  labelText: "Usuario",
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                items: usuarios.map((u) {
                  return DropdownMenuItem(
                    value: u.id,
                    child: Text("${u.nombre} ${u.apellido}"),
                  );
                }).toList(),
                onChanged: esEditar ? null : (v) => idUsuario = v,
                validator: (v) => v == null ? "Seleccione un usuario" : null,
              ),

              const SizedBox(height: 10),

              DropdownButtonFormField<int>(
                value: idLibro,
                decoration: InputDecoration(
                  labelText: "Libro",
                  prefixIcon: const Icon(Icons.book),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                items: librosDisponibles.map((l) {
                  return DropdownMenuItem(value: l.id, child: Text(l.titulo));
                }).toList(),
                onChanged: esEditar ? null : (v) => idLibro = v,
                validator: (v) => v == null ? "Seleccione un libro" : null,
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: fechaPrestamoController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Fecha Préstamo",
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: fechaDevolucionController,
                readOnly: true,
                onTap: () async {
                  final fecha = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    initialDate: DateTime.now(),
                  );

                  if (fecha != null) {
                    fechaDevolucionController.text = DateFormat(
                      'yyyy-MM-dd',
                    ).format(fecha);
                    calcularEstado();
                    setState(() {});
                  }
                },
                validator: (v) =>
                    v == null || v.isEmpty ? "Seleccione fecha" : null,
                decoration: InputDecoration(
                  labelText: "Fecha Devolución",
                  prefixIcon: const Icon(Icons.event),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              TextFormField(
                readOnly: true,
                initialValue: estado,
                decoration: InputDecoration(
                  labelText: "Estado",
                  prefixIcon: const Icon(Icons.info),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 45),
                      ),
                      onPressed: () async {
                        if (!formPrestamo.currentState!.validate()) return;

                        if (!esEditar) {
                          final limite = await prestamosRepo
                              .usuarioConDosLibros(idUsuario!);
                          if (limite) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "El usuario ya tiene 2 libros prestados",
                                ),
                              ),
                            );
                            return;
                          }
                        }

                        final data = PrestamosModels(
                          idLibro: idLibro!,
                          idUsuario: idUsuario!,
                          fechaPrestamo: fechaPrestamoController.text,
                          fechaDevolucion: fechaDevolucionController.text,
                          estado: estado,
                        );

                        if (esEditar) {
                          data.id = prestamo!.id;
                          await prestamosRepo.edit(data);
                        } else {
                          await prestamosRepo.create(data);
                        }

                        Navigator.pop(context);
                      },
                      child: Text(esEditar ? "Actualizar" : "Guardar"),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 45),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancelar"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
