import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/usuarios_models.dart';
import '../repositories/usuarios_repository.dart';

class UsuarioFormScreen extends StatefulWidget {
  const UsuarioFormScreen({super.key});

  @override
  State<UsuarioFormScreen> createState() => _UsuarioFormScreenState();
}

class _UsuarioFormScreenState extends State<UsuarioFormScreen> {
  // key del formulario
  final formUsuario = GlobalKey<FormState>();

  // controllers
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final cedulaController = TextEditingController();
  final telefonoController = TextEditingController();
  final correoController = TextEditingController();

  // usuario para editar
  UsuariosModels? usuario;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;

    // si viene usuario, es edición
    if (args != null) {
      usuario = args as UsuariosModels;
      nombreController.text = usuario!.nombre;
      apellidoController.text = usuario!.apellido;
      cedulaController.text = usuario!.cedula;
      telefonoController.text = usuario!.telefono;
      correoController.text = usuario!.correo;
    }
  }

  @override
  Widget build(BuildContext context) {
    final esEditar = usuario != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(esEditar ? "Editar Usuario" : "Insertar Usuario"),
        backgroundColor: const Color.fromARGB(255, 145, 93, 17),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),

        // scroll para evitar overflow
        child: SingleChildScrollView(
          child: Form(
            key: formUsuario,
            child: Column(
              children: [
                // nombre
                TextFormField(
                  controller: nombreController,
                  validator: (value) =>
                      value == null || value.isEmpty ? "Campo requerido" : null,
                  decoration: InputDecoration(
                    labelText: "Nombre del Usuario",
                    hintText: "Ingrese el nombre",
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // apellido
                TextFormField(
                  controller: apellidoController,
                  validator: (value) =>
                      value == null || value.isEmpty ? "Campo requerido" : null,
                  decoration: InputDecoration(
                    labelText: "Apellido del Usuario",
                    hintText: "Ingrese el apellido",
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // cédula
                TextFormField(
                  controller: cedulaController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10), // 👈 máximo 10
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Campo requerido";
                    }
                    if (value.length != 10) {
                      return "La cédula debe tener 10 dígitos";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Cédula del Usuario",
                    hintText: "Ingrese la cédula (10 dígitos)",
                    prefixIcon: const Icon(Icons.badge),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                // teléfono
                TextFormField(
                  controller: telefonoController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Campo requerido";
                    }
                    if (value.length != 10) {
                      return "El teléfono debe tener 10 dígitos";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Teléfono del Usuario",
                    hintText: "Ingrese el teléfono (10 dígitos)",
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),

                SizedBox(height: 10),

                // correo electrónico validado
                TextFormField(
                  controller: correoController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Campo requerido";
                    }

                    // validación básica de correo
                    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!regex.hasMatch(value)) {
                      return "Correo no válido";
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Correo Electrónico",
                    hintText: "Ingrese el correo",
                    prefixIcon: const Icon(Icons.email),
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
                          if (formUsuario.currentState!.validate()) {
                            final repo = UsuariosRepository();

                            final nuevo = UsuariosModels(
                              nombre: nombreController.text,
                              apellido: apellidoController.text,
                              cedula: cedulaController.text,
                              telefono: telefonoController.text,
                              correo: correoController.text,
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
