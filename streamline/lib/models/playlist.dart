class Playlist {
  final String id;
  final String name;
  final List<String> videos;
  final String? thumbnail;
  final int totalDuration;

  Playlist({
    required this.id,
    required this.name,
    required this.videos,
    this.thumbnail,
    required this.totalDuration,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['id'],
      name: json['name'],
      videos: List<String>.from(json['videos']),
      thumbnail: json['thumbnail'],
      totalDuration: json['totalDuration'],
    );
  }
}
