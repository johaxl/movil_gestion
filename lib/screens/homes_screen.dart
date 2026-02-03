import 'package:flutter/material.dart';
import '../widgets/app.drawer.dart';

// Pantalla principal de la aplicación
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Color de fondo de toda la pantalla
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        centerTitle: true, // Centra el título
        elevation: 0, // Quita la sombra del AppBar
        title: const Text(
          "BIBLIOTECA",
          style: TextStyle(
            fontWeight: FontWeight.bold, // Texto en negrita
            letterSpacing:
                1.2, // Separa un poco las letras para que se vea bonito
          ),
        ),

        // Fondo con degradado para el AppBar
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 67, 187, 196),
                Color.fromARGB(255, 30, 120, 130),
              ],
              begin: Alignment.topLeft, // Inicio del degradado
              end: Alignment.bottomRight, // Fin del degradado
            ),
          ),
        ),
        foregroundColor: Colors.white, // Color del texto
      ),

      // Menú lateral
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        // Permite hacer scroll si el contenido es grande
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // =============================
            // CONTENEDOR DE BIENVENIDA
            // =============================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 20),

              // Diseño del contenedor (color, bordes y sombra)
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18), // Bordes redondeados
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12, // Sombra suave
                    blurRadius: 10, // Qué tan difusa es la sombra
                    offset: Offset(0, 6), // Posición de la sombra
                  ),
                ],
              ),

              // Texto que se muestra dentro del contenedor
              child: const Text(
                "Bienvenido a la Biblioteca Digital.\n\n"
                "Desde aquí podrás administrar libros, autores, usuarios "
                "y préstamos de manera sencilla y ordenada.",
                style: TextStyle(fontSize: 16),
              ),
            ),
            Container(
              width: double.infinity,
              height: 200,
              margin: const EdgeInsets.only(bottom: 20),

              // Diseño del contenedor de la imagen
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18), // Bordes redondeados
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12, // Sombra
                    blurRadius: 10,
                    offset: Offset(0, 6),
                  ),
                ],
              ),

              // Recorta la imagen para que respete los bordes redondeados
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  "assets/3.jpeg", // Imagen principal
                  fit: BoxFit.cover, // Ajusta la imagen al contenedor
                ),
              ),
            ),

            _infoContainer(
              titulo: "Autores", // Título del contenedor
              descripcion:
                  "Permite registrar y administrar los autores "
                  "de los libros disponibles en la biblioteca.",
              imagen: "assets/1.jpeg", // Imagen del contenedor
            ),

            _infoContainer(
              titulo: "Libros",
              descripcion:
                  "Aquí se gestiona el catálogo de libros y "
                  "su disponibilidad para préstamo.",
              imagen: "assets/2.jpeg",
            ),

            _infoContainer(
              titulo: "Usuarios",
              descripcion:
                  "Se controla la información de las personas "
                  "que pueden solicitar préstamos.",
              imagen: "assets/4.jpeg",
            ),
          ],
        ),
      ),
    );
  }

  // FUNCIÓN PARA CREAR CONTENEDORES CON IMAGEN Y TEXTO
  Widget _infoContainer({
    required String titulo, // Texto del título
    required String descripcion, // Texto descriptivo
    required String imagen, // Ruta de la imagen
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),

      // Diseño del contenedor
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18), // Bordes redondeados
        boxShadow: const [
          BoxShadow(
            color: Colors.black12, // Sombra suave
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),

      // Contenido interno del contenedor
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen superior
          ClipRRect(
            // Recorta la imagen solo arriba para que quede bonito
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Image.asset(
              imagen,
              height: 160, // Altura de la imagen
              width: double.infinity,
              fit: BoxFit.cover, // Ajusta la imagen al ancho
            ),
          ),

          // Área del texto
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8), // Espacio entre textos
                // Descripción
                Text(descripcion, style: const TextStyle(fontSize: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
