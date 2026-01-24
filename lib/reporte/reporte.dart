import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // permite trabajar con fechas y formatos
import '../models/prestamos_models.dart';
import '../repositories/prestamos_repository.dart';

// pantalla de reporte de prestamos
class ReportePrestamosScreen extends StatefulWidget {
  const ReportePrestamosScreen({super.key});

  @override
  State<ReportePrestamosScreen> createState() => _ReportePrestamosScreenState();
}

class _ReportePrestamosScreenState extends State<ReportePrestamosScreen> {
  // objeto para usar la base de datos
  final PrestamosRepository repo = PrestamosRepository();

  // lista donde se guardan los resultados del reporte
  List<PrestamosModels> reporte = [];

  // estado seleccionado
  String estado = "ACTIVO";

  // controladores para fechas
  final desdeController = TextEditingController();
  final hastaController = TextEditingController();

  // abre calendario y guarda la fecha
  Future<void> seleccionarFecha(TextEditingController controller) async {
    final fecha = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    );

    if (fecha != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(fecha);
    }
  }

  // genera el reporte segun filtros
  Future<void> generarReporte() async {
    if (desdeController.text.isEmpty || hastaController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Seleccione las fechas")));
      return;
    }

    reporte = await repo.reportePrestamos(
      estado,
      desdeController.text,
      hastaController.text,
    );

    setState(() {});
  }

  // devuelve un color segun el estado
  Color colorEstado(String estado) {
    switch (estado) {
      case "ACTIVO":
        return Colors.green;
      case "DEVUELTO":
        return Colors.blue;
      case "ATRASADO":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // barra superior
      appBar: AppBar(
        title: const Text("Reporte de Prestamos"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),

      // cuerpo de la pantalla
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // selector de estado
            DropdownButtonFormField<String>(
              initialValue: estado,
              items: [
                "ACTIVO",
                "DEVUELTO",
                "ATRASADO",
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => estado = v!,
              decoration: const InputDecoration(
                labelText: "Estado",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            // campo fecha desde
            TextField(
              controller: desdeController,
              readOnly: true,
              onTap: () => seleccionarFecha(desdeController),
              decoration: const InputDecoration(
                labelText: "Desde",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            // campo fecha hasta
            TextField(
              controller: hastaController,
              readOnly: true,
              onTap: () => seleccionarFecha(hastaController),
              decoration: const InputDecoration(
                labelText: "Hasta",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            // boton para generar reporte
            ElevatedButton(
              onPressed: generarReporte,
              child: const Text("Generar Reporte"),
            ),

            const SizedBox(height: 10),

            // lista de resultados
            Expanded(
              child: reporte.isEmpty
                  ? const Center(child: Text("No hay datos para mostrar"))
                  : ListView.builder(
                      itemCount: reporte.length,
                      itemBuilder: (context, i) {
                        final p = reporte[i];
                        return Card(
                          child: ListTile(
                            // icono del libro
                            leading: Icon(
                              Icons.book,
                              color: colorEstado(p.estado),
                            ),

                            // nombre del libro
                            title: Text(p.libroNombre ?? ""),

                            // datos del prestamo
                            subtitle: Text(
                              "${p.usuarioNombre}\n"
                              "Prestamo: ${p.fechaPrestamo}\n"
                              "Devolucion: ${p.fechaDevolucion}",
                            ),

                            // estado del prestamo
                            trailing: Text(
                              p.estado,
                              style: TextStyle(
                                color: colorEstado(p.estado),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
