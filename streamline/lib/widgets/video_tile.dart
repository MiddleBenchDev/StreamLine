import 'package:flutter/material.dart';
import 'package:streamline/models/video_progress.dart';

class VideoTile extends StatelessWidget {
  final VideoProgress progress;
  final Function(String) onStatusChanged;
  final VoidCallback onTap;

  const VideoTile({
    super.key,
    required this.progress,
    required this.onStatusChanged,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: progress.thumbnail != null
          ? Image.network(progress.thumbnail!, width: 50, height: 50)
          : const Icon(Icons.video_library, size: 50),
      title: Text(progress.videoUrl.split('v=')[1]),
      subtitle: Text('Duration: ${progress.duration ~/ 60} min'),
      trailing: DropdownButton<String>(
        value: progress.status,
        items: const [
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
  }
}
