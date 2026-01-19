import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'autores/autores_forms_screen.dart';
import 'autores/autores_screen.dart';
import 'libros/libros_forms_screen.dart';
import 'libros/libros_screen.dart';
import 'prestamos/prestamos_forms_screen.dart';
import 'prestamos/prestamos_screen.dart';
import 'screens/homes_screen.dart';
import 'usuarios/usuarios_forms_screen.dart';
import 'usuarios/usuarios_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema de Biblioteca',
      debugShowCheckedModeBanner: false,
      // Esto es para configurar el idioma de la fecha salia en ingles por eso lo puse xd
      locale: const Locale('es', 'ES'),
      supportedLocales: const [Locale('es', 'ES'), Locale('en', 'US')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routes: {
        '/': (context) => HomeScreen(),
        '/autor': (context) => AutorScreen(),
        '/autor/form': (context) => AutorFormScreen(),
        '/libro': (context) => LibroScreen(),
        '/libro/form': (context) => LibroFormScreen(),
        '/usuario': (context) => UsuarioScreen(),
        '/usuario/form': (context) => UsuarioFormScreen(),
        '/prestamo': (context) => PrestamoScreen(),
        '/prestamo/form': (context) => PrestamoFormScreen(),
      },
    );
  }
}
