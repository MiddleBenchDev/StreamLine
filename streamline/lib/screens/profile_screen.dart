import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamline/models/playlist.dart';
import 'package:streamline/providers/theme_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/playlist_provider.dart';
import '../screens/playlist_detail_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final playlistProvider = Provider.of<PlaylistProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: authProvider.photoUrl != null
                  ? NetworkImage(authProvider.photoUrl!)
                  : null,
            ),
            SizedBox(height: 16),
            Text(authProvider.displayName ?? 'User',
                style: Theme.of(context).textTheme.headline6),
            SizedBox(height: 16),
            Text('Total Playlists: ${playlistProvider.playlists.length}'),
            Text(
                'Completed Playlists: ${playlistProvider.playlists.where((p) => playlistProvider.progress.where((pr) => pr.playlistId == p.id && pr.status == 'completed').length == p.videos.length).length}'),
            SizedBox(height: 16),
            if (playlistProvider.progress.isNotEmpty)
              GestureDetector(
                onTap: () {
                  final lastPlaylist = playlistProvider.playlists.firstWhere(
                    (p) => p.id == playlistProvider.progress.last.playlistId,
                    orElse: () => playlistProvider.playlists.first,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PlaylistDetailScreen(playlist: lastPlaylist)),
                  );
                },
                child: Text(
                    'Last Watched Playlist: ${playlistProvider.playlists.firstWhere((p) => p.id == playlistProvider.progress.last.playlistId, orElse: () => Playlist(id: '', name: 'None', videos: [], createdAt: DateTime.now())).name}'),
              ),
            SizedBox(height: 16),
            DropdownButton<ThemeMode>(
              value: Provider.of<ThemeProvider>(context).themeMode,
              items: [
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
            Spacer(),
            ElevatedButton(
              onPressed: () {
                authProvider.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
