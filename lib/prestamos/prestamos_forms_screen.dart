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
  int? diasPrestamo; // días seleccionados

  PrestamosModels? prestamo;
  bool esEditar = false;

  List<LibrosModels> librosDisponibles = [];
  List<UsuariosModels> usuarios = [];

  final librosRepo = LibrosRepository();
  final usuariosRepo = UsuariosRepository();
  final prestamosRepo = PrestamosRepository();

  final List<int> opcionesDias = [3, 7, 10, 15];

  @override
  void initState() {
    super.initState();
    fechaPrestamoController.text = DateFormat(
      'yyyy-MM-dd HH:mm',
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

      // Calcular días automáticamente si viene fecha de devolución
      final fechaPrestamo = DateFormat(
        'yyyy-MM-dd HH:mm',
      ).parse(fechaPrestamoController.text);
      final fechaDevolucion = DateFormat(
        'yyyy-MM-dd HH:mm',
      ).parse(fechaDevolucionController.text);
      final diferencia = fechaDevolucion.difference(fechaPrestamo).inDays;
      if (opcionesDias.contains(diferencia)) diasPrestamo = diferencia;
    }

    cargarDatos();
  }

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

  void calcularEstado() {
    if (estado == "DEVUELTO") return;

    final hoy = DateTime.now();
    if (fechaDevolucionController.text.isEmpty) return;

    final devolucion = DateFormat(
      'yyyy-MM-dd HH:mm',
    ).parse(fechaDevolucionController.text);
    estado = devolucion.isBefore(hoy) ? "ATRASADO" : "ACTIVO";
  }

  void actualizarFechaDevolucion(int dias) {
    final fechaPrestamo = DateFormat(
      'yyyy-MM-dd HH:mm',
    ).parse(fechaPrestamoController.text);

    final fechaDevolucion = DateTime(
      fechaPrestamo.year,
      fechaPrestamo.month,
      fechaPrestamo.day + dias,
      17, // hora fija 17:00
      0,
    );

    fechaDevolucionController.text = DateFormat(
      'yyyy-MM-dd HH:mm',
    ).format(fechaDevolucion);
    calcularEstado();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(esEditar ? "Editar Préstamo" : "Nuevo Préstamo"),
        backgroundColor: const Color.fromARGB(255, 242, 201, 76),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: formPrestamo,
          child: Column(
            children: [
              // Usuario
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

              // Libro
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

              // Fecha préstamo
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

              // Selección de días
              DropdownButtonFormField<int>(
                value: diasPrestamo,
                decoration: InputDecoration(
                  labelText: "Días de préstamo",
                  prefixIcon: const Icon(Icons.timer),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                items: opcionesDias.map((d) {
                  return DropdownMenuItem(
                    value: d,
                    child: Text("$d días (entrega 17:00)"),
                  );
                }).toList(),
                onChanged: esEditar
                    ? null
                    : (v) {
                        diasPrestamo = v;
                        actualizarFechaDevolucion(v!);
                      },
                validator: (v) =>
                    v == null ? "Seleccione días de préstamo" : null,
              ),

              const SizedBox(height: 10),

              // Fecha devolución
              TextFormField(
                controller: fechaDevolucionController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Fecha y Hora Devolución",
                  prefixIcon: const Icon(Icons.event),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Estado
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

              // Botones Guardar / Cancelar
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      // elevated button sirve para crear un boton con sombra
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
