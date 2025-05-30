import 'package:flutter/material.dart';
import 'package:streamline/models/playlist.dart';

class PlaylistCard extends StatelessWidget {
  final Playlist playlist;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const PlaylistCard({
    super.key,
    required this.playlist,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: playlist.thumbnail != null
            ? Image.network(playlist.thumbnail!, width: 50, height: 50)
            : const Icon(Icons.video_library, size: 50),
        title: Text(playlist.name),
        subtitle: Text('${playlist.videos.length} videos'),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: onDelete,
        ),
        onTap: onTap,
      ),
    );
  }
}
