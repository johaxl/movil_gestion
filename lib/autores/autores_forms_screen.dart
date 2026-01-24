import 'package:flutter/material.dart';
import '../models/autores_models.dart';
import '../repositories/autores_repository.dart';

class AutorFormScreen extends StatefulWidget {
  const AutorFormScreen({super.key});
  // constructor de la pantalla

  @override
  State<AutorFormScreen> createState() => _AutorFormScreenState();
  // crea el estado de la pantalla
}

class _AutorFormScreenState extends State<AutorFormScreen> {
  final formAutor = GlobalKey<FormState>();
  // llave para validar el formulario

  final nombreController = TextEditingController();
  // controla el campo nombre

  final apellidoController = TextEditingController();
  // controla el campo apellido

  final nacionalidadController = TextEditingController();
  // controla el campo nacionalidad

  final fechaNacimientoController = TextEditingController();
  // controla el campo fecha

  final generoLiterarioController = TextEditingController();
  // controla el campo genero

  AutoresModels? autor;
  // guarda el autor si se va a editar

  bool cargado = false;
  // evita cargar datos varias veces

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // se ejecuta cuando recibe datos

    if (!cargado) {
      final args = ModalRoute.of(context)!.settings.arguments;
      // recibe datos de la pantalla anterior

      if (args != null) {
        autor = args as AutoresModels;
        // convierte los datos en autor

        nombreController.text = autor!.nombre;
        // pone el nombre en el campo

        apellidoController.text = autor!.apellido;
        // pone el apellido en el campo

        nacionalidadController.text = autor!.nacionalidad;
        // pone la nacionalidad en el campo

        fechaNacimientoController.text = autor!.fechaNacimiento;
        // pone la fecha en el campo

        generoLiterarioController.text = autor!.generoliterario;
        // pone el genero en el campo
      }

      cargado = true;
      // marca que ya cargo los datos
    }
  }

  @override
  Widget build(BuildContext context) {
    final esEditar = autor != null;
    // verifica si es editar o crear

    return Scaffold(
      // estructura principal
      appBar: AppBar(
        title: Text(esEditar ? "Editar Autor" : "Insertar Autor"),
        // titulo segun accion
      ),

      body: Form(
        key: formAutor,

        // formulario
        child: Column(
          children: [
            TextFormField(
              controller: nombreController,

              // campo nombre
              validator: (value) =>
                  value == null || value.isEmpty ? "Campo requerido" : null,
              // valida que no este vacio
            ),

            TextFormField(
              controller: apellidoController,
              // campo apellido
            ),

            TextFormField(
              controller: nacionalidadController,
              // campo nacionalidad
            ),

            TextFormField(
              controller: fechaNacimientoController,
              readOnly: true,

              // solo permite seleccionar
              onTap: () async {
                // al tocar abre calendario

                DateTime? fechaSeleccionada = await showDatePicker(
                  context: context,
                  initialDate: DateTime(2000),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                // muestra selector de fecha

                if (fechaSeleccionada != null) {
                  fechaNacimientoController.text =
                      "${fechaSeleccionada.day}/${fechaSeleccionada.month}/${fechaSeleccionada.year}";
                  // guarda la fecha seleccionada
                }
              },
            ),

            DropdownButtonFormField<String>(
              value: generoLiterarioController.text.isEmpty
                  ? null
                  : generoLiterarioController.text,

              // valor del menu
              items: const [
                DropdownMenuItem(value: "Novela", child: Text("Novela")),
                DropdownMenuItem(value: "Poesia", child: Text("Poesia")),
                DropdownMenuItem(value: "Historia", child: Text("Historia")),
              ],

              // opciones del menu
              onChanged: (value) {
                generoLiterarioController.text = value!;
                // guarda el valor elegido
              },
            ),

            TextButton(
              onPressed: () async {
                if (formAutor.currentState!.validate()) {
                  // valida formulario

                  final repo = AutoresRepository();
                  // crea repositorio

                  final nuevo = AutoresModels(
                    nombre: nombreController.text,
                    apellido: apellidoController.text,
                    nacionalidad: nacionalidadController.text,
                    fechaNacimiento: fechaNacimientoController.text,
                    generoliterario: generoLiterarioController.text,
                  );
                  // crea objeto autor

                  if (esEditar) {
                    nuevo.id = autor!.id;
                    await repo.edit(nuevo);
                    // edita autor
                  } else {
                    await repo.create(nuevo);
                    // crea autor
                  }

                  Navigator.pop(context);
                  // regresa a la pantalla anterior
                }
              },
              child: Text("Aceptar"),
              // boton guardar
            ),

            TextButton(
              onPressed: () => Navigator.pop(context),

              // cierra sin guardar
              child: Text("Cancelar"),
            ),
          ],
        ),
      ),
    );
  }
}
