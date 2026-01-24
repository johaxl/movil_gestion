import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  // crea la pantalla principal

  @override
  Widget build(BuildContext context) {
    // construye la interfaz
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),

      // define el color de fondo
      appBar: AppBar(
        title: Text("BIBLIOTECA"),
        // titulo de la barra
        backgroundColor: const Color.fromARGB(255, 30, 58, 95),
        // color de la barra
        foregroundColor: Colors.white,
        // color del texto
        centerTitle: true,
        // centra el titulo
      ),

      body: Center(
        // centra todo el contenido
        child: Column(
          // organiza los elementos en columna
          children: [
            SizedBox(height: 10),

            // espacio vertical
            Text(
              "Menu Principal",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            // titulo del menu
            Divider(color: Colors.black, thickness: 2, height: 20),

            // linea separadora
            Padding(
              padding: const EdgeInsets.all(10),
              // margen interno
              child: SingleChildScrollView(
                // permite desplazamiento
                child: Row(
                  // fila de botones
                  children: [
                    Expanded(
                      // ocupa mitad de la fila
                      child: Column(
                        // columna de autores
                        children: [
                          Container(
                            height: 150,
                            width: 150,
                            // tamano del cuadro
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 74, 144, 226),
                              // color del cuadro
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.person,
                              size: 100,
                              color: Colors.white,
                            ),
                            // icono de autores
                          ),
                          SizedBox(height: 10),
                          // espacio
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 60,
                              // tamano del boton
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 74, 144, 226),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                // centra contenido
                                children: [
                                  Icon(Icons.person, color: Colors.white),
                                  // icono
                                  SizedBox(width: 10),
                                  // espacio
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/autor');
                                    },
                                    // navega a autores
                                    child: Text("Autores"),
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      // segunda columna
                      child: Column(
                        // columna de libros
                        children: [
                          Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 107, 197, 180),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.book,
                              size: 100,
                              color: Colors.white,
                            ),
                            // icono de libros
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 107, 197, 180),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.book, color: Colors.white),
                                  SizedBox(width: 10),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/libro');
                                    },
                                    // navega a libros
                                    child: Text("Libros"),
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                // segunda fila
                children: [
                  Expanded(
                    child: Column(
                      // columna de usuarios
                      children: [
                        Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 145, 93, 17),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.people,
                            size: 100,
                            color: Colors.white,
                          ),
                          // icono usuarios
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 145, 93, 17),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.people_alt, color: Colors.white),
                                SizedBox(width: 10),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/usuario');
                                  },
                                  // navega a usuarios
                                  child: Text("Usuarios"),
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Column(
                      // columna de prestamos
                      children: [
                        Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 242, 201, 76),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.auto_stories_rounded,
                            size: 100,
                            color: Colors.white,
                          ),
                          // icono prestamos
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 242, 201, 76),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.auto_stories_rounded,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 10),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/prestamo');
                                  },
                                  // navega a prestamos
                                  child: Text("Prestamos"),
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // centra la imagen
                children: [
                  Image.asset(
                    "assets/3.jpeg",
                    // carga imagen local
                    width: MediaQuery.of(context).size.width * 0.6,
                    // ajusta al ancho
                    fit: BoxFit.contain,
                    // adapta la imagen
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
