class VideoProgress {
  final String id;
  final String playlistId;
  final String videoUrl;
  final String status;
  final DateTime lastUpdated;

  VideoProgress({
    required this.id,
    required this.playlistId,
    required this.videoUrl,
    required this.status,
    required this.lastUpdated,
  });

  factory VideoProgress.fromJson(Map<String, dynamic> json) {
    return VideoProgress(
      id: json['id'],
      playlistId: json['playlistId'],
      videoUrl: json['videoUrl'],
      status: json['status'],
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }
}
