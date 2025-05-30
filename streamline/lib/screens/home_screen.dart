import 'package:flutter/material.dart';
import 'package:streamline/screens/login_screen.dart';
import 'package:streamline/screens/playlist_screen.dart';
import 'package:streamline/services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final user = authService.getCurrentUser();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome, ${user?.displayName ?? 'User'}!'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PlaylistScreen()),
                );
              },
              child: const Text('View Playlists'),
            ),
          ],
        ),
      ),
    );
  }
}
