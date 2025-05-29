class Playlist {
  final String id;
  final String name;
  final List<String> videos;
  final DateTime createdAt;

  Playlist(
      {required this.id,
      required this.name,
      required this.videos,
      required this.createdAt});

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['id'],
      name: json['name'],
      videos: List<String>.from(json['videos']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
