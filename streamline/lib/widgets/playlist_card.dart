import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamline/providers/playlist_provider.dart';
import '../models/playlist.dart';
import '../screens/playlist_detail_screen.dart';
import '../services/api_service.dart';

class PlaylistCard extends StatelessWidget {
  final Playlist playlist;

  PlaylistCard({required this.playlist});

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();
    return FutureBuilder(
      future: Future.wait([
        apiService.getVideoThumbnail(
            playlist.videos.isNotEmpty ? playlist.videos.first : ''),
        apiService.getVideoDuration(
            playlist.videos.isNotEmpty ? playlist.videos.first : ''),
      ]),
      builder: (context, snapshot) {
        String thumbnail = '';
        int totalDuration = 0;
        if (snapshot.hasData) {
          thumbnail = snapshot.data![0] as String;
          totalDuration = snapshot.data![1] as int;
        }
        final progress = Provider.of<PlaylistProvider>(context)
            .progress
            .where((p) => p.playlistId == playlist.id);
        final completedDuration = progress
            .where((p) => p.status == 'completed')
            .fold(0, (sum, p) => sum + totalDuration);
        final progressValue = playlist.videos.isEmpty
            ? 0.0
            : completedDuration / (playlist.videos.length * totalDuration);

        return Card(
          margin: EdgeInsets.all(8),
          child: ListTile(
            leading: thumbnail.isNotEmpty
                ? Image.network(thumbnail,
                    width: 50, height: 50, fit: BoxFit.cover)
                : Icon(Icons.video_library),
            title: Text(playlist.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'Total: ${(totalDuration * playlist.videos.length / 3600).toStringAsFixed(1)} hrs'),
                Text(
                    'Watched: ${(completedDuration / 3600).toStringAsFixed(1)} hrs'),
                LinearProgressIndicator(value: progressValue),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        PlaylistDetailScreen(playlist: playlist)),
              );
            },
          ),
        );
      },
    );
  }
}
