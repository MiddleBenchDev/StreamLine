import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/playlist_provider.dart';
import '../widgets/playlist_card.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final playlistProvider = Provider.of<PlaylistProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('My Playlists')),
      body: RefreshIndicator(
        onRefresh: () => playlistProvider.fetchPlaylists(authProvider.token!),
        child: Consumer<PlaylistProvider>(
          builder: (context, provider, child) {
            if (provider.playlists.isEmpty) {
              return Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
              itemCount: provider.playlists.length,
              itemBuilder: (context, index) {
                return PlaylistCard(playlist: provider.playlists[index]);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPlaylistDialog(
            context, authProvider.token!, playlistProvider),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddPlaylistDialog(
      BuildContext context, String token, PlaylistProvider provider) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('New Playlist'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: 'Playlist Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.createPlaylist(token, controller.text);
              Navigator.pop(context);
            },
            child: Text('Create'),
          ),
        ],
      ),
    );
  }
}
