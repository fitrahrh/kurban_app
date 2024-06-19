import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../screens/home_screen.dart'; // Import halaman home
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuthException

class RegisterScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final email = _emailController.text;
                final password = _passwordController.text;
                final authService = context.read<AuthService>();

                try {
                  await authService.register(email, password);

                  // Navigasi ke halaman home setelah berhasil mendaftar
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                } catch (e) {
                  String errorMessage = 'Error registering user: $e';
                  if (e is FirebaseAuthException) {
                    if (e.code == 'weak-password') {
                      errorMessage = 'Password should be at least 6 characters';
                    } else if (e.code == 'email-already-in-use') {
                      errorMessage = 'The email address is already in use by another account.';
                    } else if (e.code == 'invalid-email') {
                      errorMessage = 'The email address is badly formatted.';
                    }
                  } else {
                    // Handle other exceptions
                    errorMessage = 'Error: $e';
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(errorMessage)),
                  );
                }
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}