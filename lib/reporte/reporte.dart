import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/prestamos_models.dart';
import '../repositories/prestamos_repository.dart';
import '../widgets/app.drawer.dart';

class ReportePrestamosScreen extends StatefulWidget {
  const ReportePrestamosScreen({super.key});

  @override
  State<ReportePrestamosScreen> createState() => _ReportePrestamosScreenState();
}

class _ReportePrestamosScreenState extends State<ReportePrestamosScreen> {
  final PrestamosRepository repo = PrestamosRepository();

  List<PrestamosModels> reporte = [];

  String estado = "ACTIVO";

  final desdeController = TextEditingController();
  final hastaController = TextEditingController();

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
      appBar: AppBar(
        title: const Text("Reporte de Préstamos"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: AppDrawer(),

      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
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

            TextField(
              controller: desdeController,
              readOnly: true,
              onTap: () => seleccionarFecha(desdeController),
              decoration: const InputDecoration(
                labelText: "Desde",
                prefixIcon: Icon(Icons.date_range),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: hastaController,
              readOnly: true,
              onTap: () => seleccionarFecha(hastaController),
              decoration: const InputDecoration(
                labelText: "Hasta",
                prefixIcon: Icon(Icons.date_range),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton.icon(
              onPressed: generarReporte,
              icon: const Icon(Icons.search, color: Colors.white),
              label: const Text(
                "Generar Reporte",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: reporte.isEmpty
                  ? const Center(child: Text("No hay datos para mostrar"))
                  : ListView.builder(
                      itemCount: reporte.length,
                      itemBuilder: (context, i) {
                        final p = reporte[i];
                        return Card(
                          child: ListTile(
                            leading: Icon(
                              Icons.book,
                              color: colorEstado(p.estado),
                            ),
                            title: Text(p.libroNombre ?? ""),
                            subtitle: Text(
                              "${p.usuarioNombre}\n"
                              "Préstamo: ${p.fechaPrestamo}\n"
                              "Devolución: ${p.fechaDevolucion}",
                            ),
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
