import 'package:flutter/material.dart';
import 'package:streamline/screens/home_screen.dart';
import 'package:streamline/services/auth_service.dart';
import 'package:streamline/services/firebase_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              final authService = AuthService();
              final userCredential = await authService.signInWithGoogle();
              if (userCredential != null) {
                final idToken = await FirebaseService.getIdToken();
                if (idToken != null) {
                  await FirebaseService.loginWithFirebase(idToken);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                }
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Login failed: $e')),
              );
            }
          },
          child: const Text('Sign in with Google'),
        ),
      ),
    );
  }
}
