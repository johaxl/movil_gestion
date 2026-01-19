import 'package:flutter/material.dart';

import '../models/usuarios_models.dart';
import '../repositories/usuarios_repository.dart';

class UsuarioFormScreen extends StatefulWidget {
  const UsuarioFormScreen({super.key});

  @override
  State<UsuarioFormScreen> createState() => _UsuarioFormScreenState();
}

class _UsuarioFormScreenState extends State<UsuarioFormScreen> {
  final formUsuario = GlobalKey<FormState>();

  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final cedulaController = TextEditingController();
  final telefonoController = TextEditingController();
  final estadoController = TextEditingController();

  UsuariosModels? usuario;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null) {
      usuario = args as UsuariosModels;
      nombreController.text = usuario!.nombre;
      apellidoController.text = usuario!.apellido;
      cedulaController.text = usuario!.cedula;
      telefonoController.text = usuario!.telefono;
      estadoController.text = usuario!.estado;
    }
  }

  @override
  Widget build(BuildContext context) {
    final esEditar = usuario != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(esEditar ? "Editar Usuario" : "Insertar Usuario"),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formUsuario,
          child: Column(
            children: [
              TextFormField(
                controller: nombreController,
                validator: (value) =>
                    value == null || value.isEmpty ? "Campo requerido" : null,
                decoration: InputDecoration(
                  labelText: "Nombre",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 10),

              TextFormField(
                controller: apellidoController,
                validator: (value) =>
                    value == null || value.isEmpty ? "Campo requerido" : null,
                decoration: InputDecoration(
                  labelText: "Apellido",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 10),

              TextFormField(
                controller: cedulaController,
                validator: (value) =>
                    value == null || value.isEmpty ? "Campo requerido" : null,
                decoration: InputDecoration(
                  labelText: "Cédula",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 10),

              TextFormField(
                controller: telefonoController,
                validator: (value) =>
                    value == null || value.isEmpty ? "Campo requerido" : null,
                decoration: InputDecoration(
                  labelText: "Teléfono",
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
                        if (formUsuario.currentState!.validate()) {
                          final repo = UsuariosRepository();

                          final nuevo = UsuariosModels(
                            nombre: nombreController.text,
                            apellido: apellidoController.text,
                            cedula: cedulaController.text,
                            telefono: telefonoController.text,
                            estado: estadoController.text,
                          );

                          if (esEditar) {
                            nuevo.id = usuario!.id;
                            await repo.edit(nuevo);
                          } else {
                            await repo.create(nuevo);
                          }
                          Navigator.pop(context);
                        }
                      },
                      child: Text("Aceptar"),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.purple,
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
