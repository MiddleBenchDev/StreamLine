import 'package:flutter/material.dart';
import 'package:streamline/models/playlist.dart';
import 'package:streamline/providers/auth_provider.dart';
import 'package:streamline/providers/playlist_provider.dart';
import 'package:streamline/screens/playlist_detail_screen.dart';
import 'package:streamline/widgets/playlist_card.dart';
import 'package:provider/provider.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  PlaylistScreenState createState() => PlaylistScreenState();
}

class PlaylistScreenState extends State<PlaylistScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPlaylists();
  }

  Future<void> _fetchPlaylists() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final playlistProvider =
          Provider.of<PlaylistProvider>(context, listen: false);
      final token = authProvider.token;
      if (token != null) {
        await playlistProvider.fetchPlaylists(token);
        setState(() {
          isLoading = false;
        });
      } else {
        throw Exception('Not authenticated');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load playlists: $e')),
      );
    }
  }

  Future<void> _createPlaylist(String name) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final playlistProvider =
          Provider.of<PlaylistProvider>(context, listen: false);
      final token = authProvider.token;
      if (token != null) {
        await playlistProvider.createPlaylist(token, name);
      } else {
        throw Exception('Not authenticated');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create playlist: $e')),
      );
    }
  }

  Future<void> _deletePlaylist(String playlistId) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final playlistProvider =
          Provider.of<PlaylistProvider>(context, listen: false);
      final token = authProvider.token;
      if (token != null) {
        await playlistProvider.deletePlaylist(token, playlistId);
      } else {
        throw Exception('Not authenticated');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete playlist: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final playlistProvider = Provider.of<PlaylistProvider>(context);
    final playlists = playlistProvider.playlists;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Playlists'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : playlists.isEmpty
              ? const Center(child: Text('No playlists found'))
              : ListView.builder(
                  itemCount: playlists.length,
                  itemBuilder: (context, index) {
                    final playlist = playlists[index];
                    return PlaylistCard(
                      playlist: playlist,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PlaylistDetailScreen(playlist: playlist),
                          ),
                        );
                      },
                      onDelete: () => _deletePlaylist(playlist.id),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final name = await showDialog<String>(
            context: context,
            builder: (context) {
              final controller = TextEditingController();
              return AlertDialog(
                title: const Text('New Playlist'),
                content: TextField(
                  controller: controller,
                  decoration: const InputDecoration(labelText: 'Playlist Name'),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, controller.text),
                    child: const Text('Create'),
                  ),
                ],
              );
            },
          );
          if (name != null && name.isNotEmpty) {
            await _createPlaylist(name);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
