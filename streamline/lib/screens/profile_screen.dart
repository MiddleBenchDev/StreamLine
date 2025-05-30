import 'package:flutter/material.dart';
import 'package:streamline/models/playlist.dart';
import 'package:streamline/providers/auth_provider.dart';
import 'package:streamline/providers/playlist_provider.dart';
import 'package:streamline/providers/theme_provider.dart';
import 'package:streamline/screens/login_screen.dart';
import 'package:streamline/screens/playlist_detail_screen.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final playlistProvider = Provider.of<PlaylistProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: authProvider.photoUrl != null
                  ? NetworkImage(authProvider.photoUrl!)
                  : null,
            ),
            const SizedBox(height: 16),
            Text(authProvider.displayName ?? 'User',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Text('Total Playlists: ${playlistProvider.playlists.length}'),
            Text(
                'Completed Playlists: ${playlistProvider.playlists.where((p) => playlistProvider.progress.where((pr) => pr.playlistId == p.id && pr.status == 'completed').length == p.videos.length).length}'),
            const SizedBox(height: 16),
            if (playlistProvider.progress.isNotEmpty)
              GestureDetector(
                onTap: () {
                  final lastPlaylist = playlistProvider.playlists.firstWhere(
                    (p) => p.id == playlistProvider.progress.last.playlistId,
                    orElse: () => Playlist(
                      id: '',
                      name: 'None',
                      videos: [],
                      totalDuration: 0,
                    ),
                  );
                  if (lastPlaylist.id.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PlaylistDetailScreen(playlist: lastPlaylist)),
                    );
                  }
                },
                child: Text(
                    'Last Watched Playlist: ${playlistProvider.playlists.firstWhere((p) => p.id == playlistProvider.progress.last.playlistId, orElse: () => Playlist(id: '', name: 'None', videos: [], totalDuration: 0)).name}'),
              ),
            const SizedBox(height: 16),
            DropdownButton<ThemeMode>(
              value: Provider.of<ThemeProvider>(context).themeMode,
              items: const [
                DropdownMenuItem(
                    value: ThemeMode.system, child: Text('System Default')),
                DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
              ],
              onChanged: (value) {
                if (value != null) {
                  Provider.of<ThemeProvider>(context, listen: false)
                      .setTheme(value);
                }
              },
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                await authProvider.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
