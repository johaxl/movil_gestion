import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // para input formatters
import '../models/libros_models.dart';
import '../models/autores_models.dart';
import '../repositories/libros_repository.dart';
import '../repositories/autores_repository.dart';

class LibroFormScreen extends StatefulWidget {
  const LibroFormScreen({super.key});

  @override
  State<LibroFormScreen> createState() => _LibroFormScreenState();
}

class _LibroFormScreenState extends State<LibroFormScreen> {
  // key del formulario
  final formLibro = GlobalKey<FormState>();

  // controllers
  final tituloController = TextEditingController();
  final isbnController = TextEditingController();
  final idAutorController = TextEditingController();
  final anioController = TextEditingController();
  final editorialController = TextEditingController();

  // objeto libro para editar
  LibrosModels? libro;

  // evita recargar datos
  bool cargado = false;

  // lista de autores
  List<AutoresModels> autores = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!cargado) {
      final args = ModalRoute.of(context)!.settings.arguments;

      // es edción
      if (args != null) {
        libro = args as LibrosModels;
        tituloController.text = libro!.titulo;
        isbnController.text = libro!.isbn;
        idAutorController.text = libro!.idAutor.toString();
        anioController.text = libro!.anioPublicacion.toString();
        editorialController.text = libro!.editorial;
      }

      // carga autores
      cargarAutores();
      cargado = true;
    }
  }

  // obtiene la lista de autores
  Future<void> cargarAutores() async {
    final repo = AutoresRepository();
    autores = await repo.getAll();
    setState(() {});
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
        child: SingleChildScrollView(
          child: Form(
            key: formLibro,
            child: Column(
              children: [
                // título
                TextFormField(
                  controller: tituloController,
                  validator: (value) =>
                      value == null || value.isEmpty ? "Campo requerido" : null,
                  decoration: InputDecoration(
                    labelText: "Título",
                    hintText: "Ingrese el título del libro",
                    prefixIcon: const Icon(Icons.book),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),

                SizedBox(height: 10),

                // isbn
                TextFormField(
                  controller: isbnController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly, // solo números
                    LengthLimitingTextInputFormatter(13), // máximo 13
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Campo requerido";
                    }
                    if (value.length != 13) {
                      return "El ISBN debe tener exactamente 13 dígitos";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "ISBN",
                    hintText: "Ingrese el ISBN (13 dígitos)",
                    prefixIcon: const Icon(Icons.qr_code),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),

                SizedBox(height: 10),

                // autor relacionado
                DropdownButtonFormField<String>(
                  initialValue: autores.isEmpty
                      ? null
                      : idAutorController.text.isEmpty
                      ? null
                      : idAutorController.text,
                  validator: (value) =>
                      value == null || value.isEmpty ? "Campo requerido" : null,
                  decoration: InputDecoration(
                    labelText: "Autor",
                    hintText: "Seleccione el autor del libro",
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  items: autores.map((autor) {
                    return DropdownMenuItem(
                      value: autor.id.toString(),
                      child: Text("${autor.nombre} ${autor.apellido}"),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      idAutorController.text = value!;
                    });
                  },
                ),

                const SizedBox(height: 10),

                // año de publicación
                TextFormField(
                  controller: anioController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Campo requerido";
                    }

                    final anio = int.tryParse(value);
                    if (anio == null) {
                      return "Solo números";
                    }

                    final anioActual = DateTime.now().year;
                    if (anio > anioActual) {
                      return "No puede ser mayor al año actual";
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Año de Publicación",
                    hintText: "Ingrese el año de publicación",
                    prefixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // editorial
                TextFormField(
                  controller: editorialController,
                  validator: (value) =>
                      value == null || value.isEmpty ? "Campo requerido" : null,
                  decoration: InputDecoration(
                    labelText: "Editorial",
                    hintText: "Ingrese la editorial del libro",
                    prefixIcon: const Icon(Icons.business),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // botones
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
