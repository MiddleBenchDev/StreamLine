import 'package:flutter/material.dart';
import '../services/api_service.dart';

class VideoTile extends StatelessWidget {
  final String videoUrl;
  final dynamic progress;
  final VoidCallback onTap;
  final Function(String) onStatusChanged;

  VideoTile(
      {required this.videoUrl,
      required this.progress,
      required this.onTap,
      required this.onStatusChanged});

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();
    return FutureBuilder(
      future: apiService.getVideoThumbnail(videoUrl),
      builder: (context, snapshot) {
        final thumbnail = snapshot.data ?? '';
        return ListTile(
          leading: thumbnail.isNotEmpty
              ? Image.network(thumbnail,
                  width: 50, height: 50, fit: BoxFit.cover)
              : Icon(Icons.video_library),
          title: Text(videoUrl.split('v=')[1].split('&')[0]),
          trailing: DropdownButton<String>(
            value: progress.status,
            items: [
              DropdownMenuItem(value: 'incomplete', child: Text('Incomplete')),
              DropdownMenuItem(value: 'completed', child: Text('Completed')),
            ],
            onChanged: (value) {
              if (value != null) {
                onStatusChanged(value);
              }
            },
          ),
          onTap: onTap,
        );
      },
    );
  }
}
