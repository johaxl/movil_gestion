import 'package:flutter/material.dart';
import '../models/prestamos_models.dart';
import '../repositories/prestamos_repository.dart';

class PrestamoFormScreen extends StatefulWidget {
  const PrestamoFormScreen({super.key});

  @override
  State<PrestamoFormScreen> createState() => _PrestamoFormScreenState();
}

class _PrestamoFormScreenState extends State<PrestamoFormScreen> {
  final formPrestamo = GlobalKey<FormState>();

  final idLibroController = TextEditingController();
  final idUsuarioController = TextEditingController();
  final fechaPrestamoController = TextEditingController();
  final fechaDevolucionController = TextEditingController();
  final estadoController = TextEditingController();

  PrestamosModels? prestamo;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null) {
      prestamo = args as PrestamosModels;
      idLibroController.text = prestamo!.idLibro.toString();
      idUsuarioController.text = prestamo!.idUsuario.toString();
      fechaPrestamoController.text = prestamo!.fechaPrestamo;
      fechaDevolucionController.text = prestamo!.fechaDevolucion;
      estadoController.text = prestamo!.estado;
    }
  }

  @override
  Widget build(BuildContext context) {
    final esEditar = prestamo != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(esEditar ? "Editar Préstamo" : "Insertar Préstamo"),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formPrestamo,
          child: Column(
            children: [
              TextFormField(
                controller: idLibroController,
                validator: (value) =>
                    value == null || value.isEmpty ? "Campo requerido" : null,
                decoration: InputDecoration(
                  labelText: "ID Libro",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 10),

              TextFormField(
                controller: idUsuarioController,
                validator: (value) =>
                    value == null || value.isEmpty ? "Campo requerido" : null,
                decoration: InputDecoration(
                  labelText: "ID Usuario",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 10),

              TextFormField(
                controller: fechaPrestamoController,
                validator: (value) =>
                    value == null || value.isEmpty ? "Campo requerido" : null,
                decoration: InputDecoration(
                  labelText: "Fecha Préstamo",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 10),

              TextFormField(
                controller: fechaDevolucionController,
                validator: (value) =>
                    value == null || value.isEmpty ? "Campo requerido" : null,
                decoration: InputDecoration(
                  labelText: "Fecha Devolución",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 10),

              TextFormField(
                controller: estadoController,
                validator: (value) =>
                    value == null || value.isEmpty ? "Campo requerido" : null,
                decoration: InputDecoration(
                  labelText: "Estado",
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
                        if (formPrestamo.currentState!.validate()) {
                          final repo = PrestamosRepository();

                          final nuevo = PrestamosModels(
                            idLibro: int.parse(idLibroController.text),
                            idUsuario: int.parse(idUsuarioController.text),
                            fechaPrestamo: fechaPrestamoController.text,
                            fechaDevolucion: fechaDevolucionController.text,
                            estado: estadoController.text,
                          );

                          if (esEditar) {
                            nuevo.id = prestamo!.id;
                            await repo.edit(nuevo);
                          } else {
                            await repo.create(nuevo);
                          }
                          Navigator.pop(context);
                        }
                      },
                      child: Text("Aceptar"),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.orange,
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
