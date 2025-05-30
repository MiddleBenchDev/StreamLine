class VideoProgress {
  final String id;
  final String videoUrl;
  final String status;
  final String playlistId;
  final String? thumbnail;
  final int duration;

  VideoProgress({
    required this.id,
    required this.videoUrl,
    required this.status,
    required this.playlistId,
    this.thumbnail,
    required this.duration,
  });

  factory VideoProgress.fromJson(Map<String, dynamic> json) {
    return VideoProgress(
      id: json['id'] as String,
      videoUrl: json['videoUrl'] as String,
      status: json['status'] as String,
      playlistId: json['playlistId'] as String,
      thumbnail: json['thumbnail'] as String?,
      duration: json['duration'] as int,
    );
  }
}
