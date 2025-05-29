import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamline/models/video_progress.dart';
import 'package:streamline/providers/auth_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/playlist.dart';
import '../providers/playlist_provider.dart';
import '../widgets/video_tile.dart';

class PlaylistDetailScreen extends StatelessWidget {
  final Playlist playlist;

  PlaylistDetailScreen({required this.playlist});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final playlistProvider = Provider.of<PlaylistProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(playlist.name)),
      body: RefreshIndicator(
        onRefresh: () => playlistProvider.fetchVideoProgress(
            authProvider.token!, playlist.id),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(labelText: 'Add YouTube Video URL'),
                onSubmitted: (value) {
                  playlistProvider.addVideoToPlaylist(
                      authProvider.token!, playlist.id, value);
                },
              ),
            ),
            Expanded(
              child: Consumer<PlaylistProvider>(
                builder: (context, provider, child) {
                  final progress = provider.progress
                      .where((p) => p.playlistId == playlist.id)
                      .toList();
                  return ListView.builder(
                    itemCount: playlist.videos.length,
                    itemBuilder: (context, index) {
                      final videoUrl = playlist.videos[index];
                      final videoProgress = progress.firstWhere(
                        (p) => p.videoUrl == videoUrl,
                        orElse: () => VideoProgress(
                          id: '',
                          playlistId: playlist.id,
                          videoUrl: videoUrl,
                          status: 'incomplete',
                          lastUpdated: DateTime.now(),
                        ),
                      );
                      return VideoTile(
                        videoUrl: videoUrl,
                        progress: videoProgress,
                        onTap: () => _launchYouTube(videoUrl),
                        onStatusChanged: (status) {
                          if (videoProgress.id.isEmpty) {
                            provider.createVideoProgress(
                                authProvider.token!, playlist.id, videoUrl);
                          } else {
                            provider.updateVideoStatus(
                                authProvider.token!, videoProgress.id, status);
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchYouTube(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
