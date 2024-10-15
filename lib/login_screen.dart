import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();  // Añadimos el campo de contraseña
  final _verificationCodeController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login(String email, String password) async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse('http://192.168.0.13:5000/login'),  // Reemplaza con tu IP local
      body: jsonEncode({'email': email, 'password': password}),
      headers: {"Content-Type": "application/json"},
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      // Si el login es exitoso, enviamos el código de verificación
      _sendVerificationCode(email);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Correo o contraseña incorrectos')),
      );
    }
  }

  Future<void> _sendVerificationCode(String email) async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse('http://192.168.0.13:5000/send-code'),  // Reemplaza con tu IP local
      body: jsonEncode({'email': email}),
      headers: {"Content-Type": "application/json"},
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Código de verificación enviado')),
      );
      // Ahora mostramos la pantalla para ingresar el código de verificación
      _showVerificationScreen();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al enviar el código de verificación')),
      );
    }
  }

  Future<void> _verifyCode(String email, String code) async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse('http://192.168.0.13:5000/verify-code'),  // Reemplaza con tu IP local
      body: jsonEncode({'email': email, 'code': code}),
      headers: {"Content-Type": "application/json"},
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Código incorrecto o expirado')),
      );
    }
  }

  // Función para mostrar la pantalla de verificación del código
  void _showVerificationScreen() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Verificar Código'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Se ha enviado un código de verificación a tu correo.'),
              TextField(
                controller: _verificationCodeController,
                decoration: const InputDecoration(labelText: 'Código de verificación'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _verifyCode(_emailController.text, _verificationCodeController.text);
              },
              child: const Text('Verificar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Por favor ingrese su correo y contraseña')),
                        );
                      } else {
                        _login(_emailController.text, _passwordController.text);
                      }
                    },
                    child: const Text('Iniciar Sesión'),
                  ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);  // Volver a la pantalla principal
              },
              child: const Text('Volver al Inicio'),
            ),
          ],
        ),
      ),
    );
  }
}
