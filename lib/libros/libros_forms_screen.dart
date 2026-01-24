import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// permite validar y limitar lo que se escribe

import '../models/libros_models.dart';
// importa el modelo libro

import '../models/autores_models.dart';
// importa el modelo autor

import '../repositories/libros_repository.dart';
// importa repositorio de libros

import '../repositories/autores_repository.dart';
// importa repositorio de autores

class LibroFormScreen extends StatefulWidget {
  const LibroFormScreen({super.key});
  // pantalla del formulario de libros

  @override
  State<LibroFormScreen> createState() => _LibroFormScreenState();
  // crea el estado de la pantalla
}

class _LibroFormScreenState extends State<LibroFormScreen> {
  final formLibro = GlobalKey<FormState>();
  // llave para validar el formulario

  final tituloController = TextEditingController();
  // controla el campo titulo

  final isbnController = TextEditingController();
  // controla el campo isbn

  final idAutorController = TextEditingController();
  // guarda el id del autor

  final anioController = TextEditingController();
  // controla el campo anio

  final editorialController = TextEditingController();
  // controla el campo editorial

  LibrosModels? libro;
  // guarda el libro si se edita

  bool cargado = false;
  // evita cargar datos varias veces

  List<AutoresModels> autores = [];
  // lista de autores

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // se ejecuta cuando recibe datos

    if (!cargado) {
      final args = ModalRoute.of(context)!.settings.arguments;
      // recibe datos de la pantalla anterior

      if (args != null) {
        libro = args as LibrosModels;
        // convierte datos en libro

        tituloController.text = libro!.titulo;
        // carga titulo

        isbnController.text = libro!.isbn;
        // carga isbn

        idAutorController.text = libro!.idAutor.toString();
        // carga id autor

        anioController.text = libro!.anioPublicacion.toString();
        // carga anio

        editorialController.text = libro!.editorial;
        // carga editorial
      }

      cargarAutores();
      // carga lista de autores

      cargado = true;
      // marca que ya se cargo
    }
  }

  Future<void> cargarAutores() async {
    final repo = AutoresRepository();
    // crea repositorio de autores

    autores = await repo.getAll();
    // obtiene todos los autores

    setState(() {});
    // actualiza pantalla
  }

  @override
  Widget build(BuildContext context) {
    final esEditar = libro != null;
    // verifica si es edicion o insercion

    return Scaffold(
      appBar: AppBar(
        title: Text(esEditar ? "Editar Libro" : "Insertar Libro"),
        // titulo segun accion
      ),
      body: Form(
        key: formLibro,

        // formulario
        child: Column(
          children: [
            TextFormField(
              controller: tituloController,

              // campo titulo
              validator: (value) =>
                  value == null || value.isEmpty ? "Campo requerido" : null,
              // valida que no este vacio
            ),

            TextFormField(
              controller: isbnController,
              keyboardType: TextInputType.number,

              // solo permite numeros
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,

                // solo numeros
                LengthLimitingTextInputFormatter(13),
                // maximo 13 digitos
              ],
            ),

            DropdownButtonFormField<String>(
              initialValue: autores.isEmpty
                  ? null
                  : idAutorController.text.isEmpty
                  ? null
                  : idAutorController.text,

              // valor inicial del menu
              items: autores.map((autor) {
                return DropdownMenuItem(
                  value: autor.id.toString(),
                  child: Text("${autor.nombre} ${autor.apellido}"),
                );
              }).toList(),

              // lista de autores
              onChanged: (value) {
                idAutorController.text = value!;
                // guarda el id del autor
              },
            ),

            TextFormField(
              controller: anioController,
              keyboardType: TextInputType.number,
              // campo anio
            ),

            TextFormField(
              controller: editorialController,
              // campo editorial
            ),

            TextButton(
              onPressed: () async {
                if (formLibro.currentState!.validate()) {
                  final repo = LibrosRepository();
                  // crea repositorio libros

                  final nuevo = LibrosModels(
                    titulo: tituloController.text,
                    isbn: isbnController.text,
                    idAutor: int.parse(idAutorController.text),
                    anioPublicacion: int.parse(anioController.text),
                    editorial: editorialController.text,
                  );
                  // crea objeto libro

                  if (esEditar) {
                    nuevo.id = libro!.id;
                    await repo.edit(nuevo);
                    // edita libro
                  } else {
                    await repo.create(nuevo);
                    // crea libro
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
