import 'package:flutter/material.dart';
import '../models/autores_models.dart';
import '../repositories/autores_repository.dart';

class AutorFormScreen extends StatefulWidget {
  const AutorFormScreen({super.key});

  @override
  State<AutorFormScreen> createState() => _AutorFormScreenState();
}

class _AutorFormScreenState extends State<AutorFormScreen> {
  // key del formulario
  final formAutor = GlobalKey<FormState>();

  // controllers de los campos
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final nacionalidadController = TextEditingController();
  final fechaNacimientoController = TextEditingController();
  final generoLiterarioController = TextEditingController();

  // autor recibido para editar
  AutoresModels? autor;

  // evita que se carguen los datos varias veces
  bool cargado = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // se ejecuta una sola vez
    if (!cargado) {
      final args = ModalRoute.of(context)!.settings.arguments;

      // si viene un autor o es edición
      if (args != null) {
        autor = args as AutoresModels;

        // se cargan los datos en los campos
        nombreController.text = autor!.nombre;
        apellidoController.text = autor!.apellido;
        nacionalidadController.text = autor!.nacionalidad;
        fechaNacimientoController.text = autor!.fechaNacimiento;
        generoLiterarioController.text = autor!.generoliterario;
      }

      cargado = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    // verifica si es edición o inserción
    final esEditar = autor != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(esEditar ? "Editar Autor" : "Insertar Autor"),
        backgroundColor: const Color.fromARGB(255, 74, 144, 226),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            key: formAutor,
            child: Column(
              children: [
                // campo nombre
                TextFormField(
                  controller: nombreController,
                  validator: (value) =>
                      value == null || value.isEmpty ? "Campo requerido" : null,
                  decoration: InputDecoration(
                    labelText: "Nombre del Autor",
                    hintText: "Ingrese el nombre del autor",
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // campo apellido
                TextFormField(
                  controller: apellidoController,
                  validator: (value) =>
                      value == null || value.isEmpty ? "Campo requerido" : null,
                  decoration: InputDecoration(
                    labelText: "Apellido del Autor",
                    hintText: "Ingrese el apellido del autor",
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // campo nacionalidad
                TextFormField(
                  controller: nacionalidadController,
                  validator: (value) =>
                      value == null || value.isEmpty ? "Campo requerido" : null,
                  decoration: InputDecoration(
                    labelText: "Nacionalidad del Autor",
                    hintText: "Ingrese la nacionalidad del autor",
                    prefixIcon: Icon(Icons.flag),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // campo fecha de nacimiento
                TextFormField(
                  controller: fechaNacimientoController,
                  readOnly: true,
                  validator: (value) =>
                      value == null || value.isEmpty ? "Campo requerido" : null,
                  decoration: InputDecoration(
                    labelText: "Fecha de Nacimiento del Autor",
                    hintText: "Ingrese la fecha de nacimiento",
                    prefixIcon: Icon(Icons.calendar_month),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onTap: () async {
                    // fecha inicial por defecto
                    DateTime fechaInicial = DateTime(2000);

                    // si ya hay fecha se va a usar esa
                    if (fechaNacimientoController.text.isNotEmpty) {
                      final partes = fechaNacimientoController.text.split('/');
                      fechaInicial = DateTime(
                        int.parse(partes[2]),
                        int.parse(partes[1]),
                        int.parse(partes[0]),
                      );
                    }

                    // abre el selector de fecha
                    DateTime? fechaSeleccionada = await showDatePicker(
                      context: context,
                      initialDate: fechaInicial,
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2000),
                    );

                    // si selecciona una fecha se asigna
                    if (fechaSeleccionada != null) {
                      setState(() {
                        fechaNacimientoController.text =
                            "${fechaSeleccionada.day.toString().padLeft(2, '0')}/"
                            "${fechaSeleccionada.month.toString().padLeft(2, '0')}/"
                            "${fechaSeleccionada.year}";
                      });
                    }
                  },
                ),

                const SizedBox(height: 10),

                // menú desplegable del género literario
                DropdownButtonFormField<String>(
                  initialValue: generoLiterarioController.text.isEmpty
                      ? null
                      : generoLiterarioController.text,
                  validator: (value) =>
                      value == null || value.isEmpty ? "Campo requerido" : null,
                  decoration: InputDecoration(
                    labelText: "Género Literario que escribió el Autor",
                    hintText: "Ingrese el género literario",
                    prefixIcon: Icon(Icons.menu_book),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: "Novela", child: Text("Novela")),
                    DropdownMenuItem(value: "Poesía", child: Text("Poesía")),
                    DropdownMenuItem(
                      value: "Ciencia ficción",
                      child: Text("Ciencia ficción"),
                    ),
                    DropdownMenuItem(
                      value: "Historia",
                      child: Text("Historia"),
                    ),
                    DropdownMenuItem(
                      value: "Fantasía",
                      child: Text("Fantasía"),
                    ),
                    DropdownMenuItem(value: "Ensayo", child: Text("Ensayo")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      generoLiterarioController.text = value!;
                    });
                  },
                ),

                const SizedBox(height: 15),

                // botones
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          // valida el formulario
                          if (formAutor.currentState!.validate()) {
                            final repo = AutoresRepository();

                            // crea el objeto autor
                            final nuevo = AutoresModels(
                              nombre: nombreController.text,
                              apellido: apellidoController.text,
                              nacionalidad: nacionalidadController.text,
                              fechaNacimiento: fechaNacimientoController.text,
                              generoliterario: generoLiterarioController.text,
                            );

                            // decide si edita o inserta
                            if (esEditar) {
                              nuevo.id = autor!.id;
                              await repo.edit(nuevo);
                            } else {
                              await repo.create(nuevo);
                            }

                            // regresa a la pantalla anterior
                            Navigator.pop(context);
                          }
                        },
                        child: const Text("Aceptar"),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(width: 5),

                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancelar"),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
