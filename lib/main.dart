import 'package:flutter/material.dart';
import 'register_screen.dart';  // Asegúrate de agregar estas importaciones
import 'login_screen.dart';
import 'home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multifactor Authentication Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainScreen(),  // La pantalla principal
      routes: {
        '/register': (context) => const RegisterScreen(),  // Pantalla de registro
        '/login': (context) => const LoginScreen(),  // Pantalla de login
        '/home': (context) => const HomeScreen(),  // Pantalla principal del usuario
      },
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Autenticación Multifactor'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Bienvenido a nuestra prueba de Autenticación Multifactor'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text('Registrarse'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
