import 'package:flutter/material.dart'; // en todas esta libreria

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});
  final List<Map<String, dynamic>> opciones = const [
    {
      "titulo": "Inicio",
      "icono": Icons.home_outlined,
      "ruta": "/",
      "color": const Color.fromARGB(255, 30, 58, 95),
    },
    {
      "titulo": "Autores",
      "icono": Icons.person_outline,
      "ruta": "/autor",
      "color": const Color.fromARGB(255, 74, 144, 226),
    },
    {
      "titulo": "Libros",
      "icono": Icons.menu_book_outlined,
      "ruta": "/libro",
      "color": const Color.fromARGB(255, 107, 197, 180),
    },
    {
      "titulo": "Usuarios",
      "icono": Icons.people_outline,
      "ruta": "/usuario",
      "color": const Color.fromARGB(255, 145, 93, 17),
    },
    {
      "titulo": "Préstamos",
      "icono": Icons.assignment_return_outlined,
      "ruta": "/prestamo",
      "color": const Color.fromARGB(255, 242, 201, 76),
    },
    {
      "titulo": "Reportes",
      "icono": Icons.report,
      "ruta": "/reporte",
      "color": Color.fromARGB(255, 156, 40, 10),
    },
    {
      "titulo": "Gracias por usar la app",
      "icono": Icons.info_outline,
      "ruta": "/",
      "color": Color.fromARGB(255, 156, 40, 10),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 67, 187, 196),
            ),
            child: Row(
              children: [
                Icon(Icons.dashboard, color: Colors.white, size: 40),
                SizedBox(width: 10),
                Text(
                  "Gestión de Biblioteca",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: opciones.length,
              itemBuilder: (context, index) {
                final opcion = opciones[index];
                return ListTile(
                  leading: Icon(
                    opcion["icono"],
                    color: opcion["color"],
                  ), // margen izquierdo
                  title: Text(opcion["titulo"]),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, opcion["ruta"]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
