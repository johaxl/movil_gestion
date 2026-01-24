import 'package:flutter/material.dart';
// importa flutter para usar widgets

import 'package:flutter/services.dart';
// importa herramientas para validar entradas

import '../models/usuarios_models.dart';
// importa el modelo de usuario

import '../repositories/usuarios_repository.dart';
// importa el repositorio de usuarios

class UsuarioFormScreen extends StatefulWidget {
  const UsuarioFormScreen({super.key});
  // crea la pantalla del formulario

  @override
  State<UsuarioFormScreen> createState() => _UsuarioFormScreenState();
  // crea el estado de la pantalla
}

class _UsuarioFormScreenState extends State<UsuarioFormScreen> {
  // llave para validar el formulario
  final formUsuario = GlobalKey<FormState>();

  // controladores para leer los campos
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final cedulaController = TextEditingController();
  final telefonoController = TextEditingController();
  final correoController = TextEditingController();

  // guarda el usuario si se edita
  UsuariosModels? usuario;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // se ejecuta cuando recibe datos

    final args = ModalRoute.of(context)!.settings.arguments;
    // recibe datos de otra pantalla

    // si hay datos es edicion
    if (args != null) {
      usuario = args as UsuariosModels;
      // asigna el usuario

      nombreController.text = usuario!.nombre;
      // llena el campo nombre

      apellidoController.text = usuario!.apellido;
      // llena el campo apellido

      cedulaController.text = usuario!.cedula;
      // llena el campo cedula

      telefonoController.text = usuario!.telefono;
      // llena el campo telefono

      correoController.text = usuario!.correo;
      // llena el campo correo
    }
  }

  @override
  Widget build(BuildContext context) {
    final esEditar = usuario != null;
    // verifica si es edicion

    return Scaffold(
      appBar: AppBar(
        title: Text(esEditar ? "Editar Usuario" : "Insertar Usuario"),

        // muestra titulo segun accion
        backgroundColor: const Color.fromARGB(255, 145, 93, 17),

        // color de la barra
        foregroundColor: Colors.white,

        // color del texto
        centerTitle: true,
        // centra el titulo
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),

        // margen interno
        child: SingleChildScrollView(
          // permite hacer scroll
          child: Form(
            key: formUsuario,

            // asigna la llave al formulario
            child: Column(
              children: [
                TextFormField(
                  controller: nombreController,

                  // controla el campo nombre
                  validator: (value) =>
                      value == null || value.isEmpty ? "Campo requerido" : null,

                  // valida que no este vacio
                  decoration: InputDecoration(
                    labelText: "Nombre del Usuario",
                    hintText: "Ingrese el nombre",
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),

                SizedBox(height: 10),

                // espacio
                TextFormField(
                  controller: apellidoController,

                  // controla el campo apellido
                  validator: (value) =>
                      value == null || value.isEmpty ? "Campo requerido" : null,

                  // valida que no este vacio
                  decoration: InputDecoration(
                    labelText: "Apellido del Usuario",
                    hintText: "Ingrese el apellido",
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),

                SizedBox(height: 10),

                // espacio
                TextFormField(
                  controller: cedulaController,

                  // controla el campo cedula
                  keyboardType: TextInputType.number,

                  // solo numeros
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,

                    // solo digitos
                    LengthLimitingTextInputFormatter(10),
                    // maximo 10
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Campo requerido";
                    }
                    if (value.length != 10) {
                      return "La cedula debe tener 10 digitos";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Cedula del Usuario",
                    hintText: "Ingrese la cedula",
                    prefixIcon: const Icon(Icons.badge),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),

                SizedBox(height: 10),

                // espacio
                TextFormField(
                  controller: telefonoController,

                  // controla el campo telefono
                  keyboardType: TextInputType.number,

                  // solo numeros
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Campo requerido";
                    }
                    if (value.length != 10) {
                      return "El telefono debe tener 10 digitos";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Telefono del Usuario",
                    hintText: "Ingrese el telefono",
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),

                SizedBox(height: 10),

                // espacio
                TextFormField(
                  controller: correoController,

                  // controla el campo correo
                  keyboardType: TextInputType.emailAddress,

                  // tipo correo
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Campo requerido";
                    }

                    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    // valida formato correo

                    if (!regex.hasMatch(value)) {
                      return "Correo no valido";
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Correo Electronico",
                    hintText: "Ingrese el correo",
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),

                SizedBox(height: 15),

                // espacio
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          if (formUsuario.currentState!.validate()) {
                            final repo = UsuariosRepository();
                            // crea el repositorio

                            final nuevo = UsuariosModels(
                              nombre: nombreController.text,
                              apellido: apellidoController.text,
                              cedula: cedulaController.text,
                              telefono: telefonoController.text,
                              correo: correoController.text,
                            );
                            // crea el objeto usuario

                            if (esEditar) {
                              nuevo.id = usuario!.id;
                              await repo.edit(nuevo);
                              // actualiza usuario
                            } else {
                              await repo.create(nuevo);
                              // guarda usuario
                            }

                            Navigator.pop(context);
                            // regresa a la pantalla anterior
                          }
                        },
                        child: const Text("Aceptar"),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),

                    SizedBox(width: 5),

                    // espacio
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),

                        // cierra sin guardar
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
