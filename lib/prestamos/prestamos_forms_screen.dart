import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// permite trabajar con fechas y formatos
import '../models/prestamos_models.dart';
import '../models/libros_models.dart';
import '../models/usuarios_models.dart';
import '../repositories/prestamos_repository.dart';
import '../repositories/libros_repository.dart';
import '../repositories/usuarios_repository.dart';

class PrestamoFormScreen extends StatefulWidget {
  const PrestamoFormScreen({super.key});
  // pantalla del formulario de prestamos

  @override
  State<PrestamoFormScreen> createState() => _PrestamoFormScreenState();
  // crea el estado de la pantalla
}

class _PrestamoFormScreenState extends State<PrestamoFormScreen> {
  final formPrestamo = GlobalKey<FormState>();
  // llave para validar el formulario

  int? idLibro;
  // guarda el id del libro

  int? idUsuario;
  // guarda el id del usuario

  final fechaPrestamoController = TextEditingController();
  // controla la fecha de prestamo

  final fechaDevolucionController = TextEditingController();
  // controla la fecha de devolucion

  String estado = "ACTIVO";
  // guarda el estado del prestamo

  PrestamosModels? prestamo;
  // guarda el prestamo si se edita

  bool esEditar = false;
  // indica si es edicion

  List<LibrosModels> librosDisponibles = [];
  // lista de libros disponibles

  List<UsuariosModels> usuarios = [];
  // lista de usuarios

  final librosRepo = LibrosRepository();
  // repositorio de libros

  final usuariosRepo = UsuariosRepository();
  // repositorio de usuarios

  final prestamosRepo = PrestamosRepository();
  // repositorio de prestamos

  @override
  void initState() {
    super.initState();
    // se ejecuta al iniciar la pantalla

    fechaPrestamoController.text = DateFormat(
      'yyyy-MM-dd HH:mm',
    ).format(DateTime.now());
    // pone la fecha actual al iniciar
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // se ejecuta cuando recibe datos

    final args = ModalRoute.of(context)!.settings.arguments;
    // recibe datos de la pantalla anterior

    if (args != null) {
      prestamo = args as PrestamosModels;
      // convierte datos en prestamo

      esEditar = true;
      // marca como edicion

      idLibro = prestamo!.idLibro;
      // carga id libro

      idUsuario = prestamo!.idUsuario;
      // carga id usuario

      fechaPrestamoController.text = prestamo!.fechaPrestamo;
      // carga fecha prestamo

      fechaDevolucionController.text = prestamo!.fechaDevolucion;
      // carga fecha devolucion

      estado = prestamo!.estado;
      // carga estado
    }

    cargarDatos();
    // carga usuarios y libros
  }

  Future<void> cargarDatos() async {
    usuarios = await usuariosRepo.getAll();
    // obtiene todos los usuarios

    final libros = await librosRepo.getAll();
    // obtiene todos los libros

    librosDisponibles.clear();
    // limpia la lista

    for (var libro in libros) {
      final ocupado = await prestamosRepo.libroOcupado(libro.id!);
      // verifica si el libro esta prestado

      if (!ocupado || (esEditar && libro.id == idLibro)) {
        librosDisponibles.add(libro);
        // agrega solo libros disponibles
      }
    }

    setState(() {});
    // actualiza pantalla
  }

  void calcularEstado() {
    if (estado == "DEVUELTO") return;
    // si ya esta devuelto no cambia

    final hoy = DateTime.now();
    // obtiene la fecha actual

    final devolucion = DateFormat(
      'yyyy-MM-dd HH:mm',
    ).parse(fechaDevolucionController.text);
    // convierte texto a fecha

    estado = devolucion.isBefore(hoy) ? "ATRASADO" : "ACTIVO";
    // compara fechas y define estado
  }

  Future<void> seleccionarFechaHora() async {
    final fecha = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: DateTime.now(),
    );
    // muestra calendario

    if (fecha == null) return;
    // si no selecciona sale

    final hora = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 8, minute: 0),
    );
    // muestra selector de hora

    if (hora == null) return;
    // si no selecciona sale

    if (hora.hour < 8 || (hora.hour == 18 && hora.minute > 0)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("La hora debe estar entre 8:00 AM y 6:00 PM"),
        ),
      );
      return;
      // valida el horario
    }

    final fechaHora = DateTime(
      fecha.year,
      fecha.month,
      fecha.day,
      hora.hour,
      hora.minute,
    );
    // une fecha y hora

    fechaDevolucionController.text = DateFormat(
      'yyyy-MM-dd HH:mm',
    ).format(fechaHora);
    // guarda fecha y hora

    calcularEstado();
    // recalcula el estado

    setState(() {});
    // actualiza pantalla
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(esEditar ? "Editar Prestamo" : "Nuevo Prestamo"),
        // titulo segun accion
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formPrestamo,

          // formulario
          child: Column(
            children: [
              DropdownButtonFormField<int>(
                value: idUsuario,

                // usuario seleccionado
                items: usuarios.map((u) {
                  return DropdownMenuItem(
                    value: u.id,
                    child: Text("${u.nombre} ${u.apellido}"),
                  );
                }).toList(),

                // lista de usuarios
                onChanged: esEditar ? null : (v) => idUsuario = v,

                // guarda el usuario
                validator: (v) => v == null ? "Seleccione un usuario" : null,
                // valida usuario
              ),

              DropdownButtonFormField<int>(
                value: idLibro,

                // libro seleccionado
                items: librosDisponibles.map((l) {
                  return DropdownMenuItem(value: l.id, child: Text(l.titulo));
                }).toList(),

                // lista de libros
                onChanged: esEditar ? null : (v) => idLibro = v,

                // guarda el libro
                validator: (v) => v == null ? "Seleccione un libro" : null,
                // valida libro
              ),

              TextFormField(
                controller: fechaPrestamoController,
                readOnly: true,
                // muestra fecha de prestamo
              ),

              TextFormField(
                controller: fechaDevolucionController,
                readOnly: true,
                onTap: seleccionarFechaHora,

                // abre selector de fecha
                validator: (v) =>
                    v == null || v.isEmpty ? "Seleccione fecha y hora" : null,
                // valida fecha
              ),

              TextFormField(
                readOnly: true,
                initialValue: estado,
                // muestra estado
              ),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (!formPrestamo.currentState!.validate()) return;
                        // valida formulario

                        if (!esEditar) {
                          final limite = await prestamosRepo
                              .usuarioConDosLibros(idUsuario!);
                          // valida limite de libros

                          if (limite) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "El usuario ya tiene 2 libros prestados",
                                ),
                              ),
                            );
                            return;
                            // no deja guardar
                          }
                        }

                        final data = PrestamosModels(
                          idLibro: idLibro!,
                          idUsuario: idUsuario!,
                          fechaPrestamo: fechaPrestamoController.text,
                          fechaDevolucion: fechaDevolucionController.text,
                          estado: estado,
                        );
                        // crea objeto prestamo

                        if (esEditar) {
                          data.id = prestamo!.id;
                          await prestamosRepo.edit(data);
                          // edita prestamo
                        } else {
                          await prestamosRepo.create(data);
                          // crea prestamo
                        }

                        Navigator.pop(context);
                        // regresa a la pantalla anterior
                      },
                      child: Text(esEditar ? "Actualizar" : "Guardar"),
                    ),
                  ),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),

                      // cancela y regresa
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
