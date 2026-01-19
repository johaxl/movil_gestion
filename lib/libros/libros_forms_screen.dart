import 'package:flutter/material.dart';

import '../models/libros_models.dart';
import '../repositories/libros_repository.dart';

class LibroFormScreen extends StatefulWidget {
  const LibroFormScreen({super.key});

  @override
  State<LibroFormScreen> createState() => _LibroFormScreenState();
}

class _LibroFormScreenState extends State<LibroFormScreen> {
  final formLibro = GlobalKey<FormState>();

  final tituloController = TextEditingController();
  final isbnController = TextEditingController();
  final idAutorController = TextEditingController();
  final anioController = TextEditingController();
  final editorialController = TextEditingController();

  LibrosModels? libro;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null) {
      libro = args as LibrosModels;
      tituloController.text = libro!.titulo;
      isbnController.text = libro!.isbn;
      idAutorController.text = libro!.idAutor.toString();
      anioController.text = libro!.anioPublicacion.toString();
      editorialController.text = libro!.editorial;
    }
  }

  @override
  Widget build(BuildContext context) {
    final esEditar = libro != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(esEditar ? "Editar Libro" : "Insertar Libro"),
        backgroundColor: const Color.fromARGB(255, 107, 197, 180),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formLibro,
          child: Column(
            children: [
              TextFormField(
                controller: tituloController,
                validator: (value) =>
                    value == null || value.isEmpty ? "Campo requerido" : null,
                decoration: InputDecoration(
                  labelText: "Título",
                  hintText: "Ingrese el título del libro",
                  prefixIcon: Icon(
                    Icons.qr_code,
                    color: const Color.fromARGB(255, 107, 197, 180),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 10),

              TextFormField(
                controller: isbnController,
                validator: (value) =>
                    value == null || value.isEmpty ? "Campo requerido" : null,
                decoration: InputDecoration(
                  labelText: "ISBN",
                  hintText: "Ingrese el ISBN del libro",
                  prefixIcon: Icon(
                    Icons.qr_code,
                    color: const Color.fromARGB(255, 107, 197, 180),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 10),

              TextFormField(
                controller: idAutorController,
                validator: (value) =>
                    value == null || value.isEmpty ? "Campo requerido" : null,
                decoration: InputDecoration(
                  labelText: "ID Autor",
                  hintText: "Seleccione el nombre del autor",
                  prefixIcon: Icon(
                    Icons.qr_code,
                    color: const Color.fromARGB(255, 107, 197, 180),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 10),

              TextFormField(
                controller: anioController,
                validator: (value) =>
                    value == null || value.isEmpty ? "Campo requerido" : null,
                decoration: InputDecoration(
                  labelText: "Año Publicación",
                  hintText: "Ingrese el año de publicación",
                  prefixIcon: Icon(
                    Icons.qr_code,
                    color: const Color.fromARGB(255, 107, 197, 180),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 10),

              TextFormField(
                controller: editorialController,
                validator: (value) =>
                    value == null || value.isEmpty ? "Campo requerido" : null,
                decoration: InputDecoration(
                  labelText: "Editorial",
                  hintText: "Ingrese el nombre de la editorial",
                  prefixIcon: Icon(
                    Icons.qr_code,
                    color: const Color.fromARGB(255, 107, 197, 180),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        if (formLibro.currentState!.validate()) {
                          final repo = LibrosRepository();

                          final nuevo = LibrosModels(
                            titulo: tituloController.text,
                            isbn: isbnController.text,
                            idAutor: int.parse(idAutorController.text),
                            anioPublicacion: int.parse(anioController.text),
                            editorial: editorialController.text,
                          );

                          if (esEditar) {
                            nuevo.id = libro!.id;
                            await repo.edit(nuevo);
                          } else {
                            await repo.create(nuevo);
                          }
                          Navigator.pop(context);
                        }
                      },
                      child: Text("Aceptar"),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Cancelar"),
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
    );
  }
}
