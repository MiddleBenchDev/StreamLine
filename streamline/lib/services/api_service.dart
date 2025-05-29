import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/playlist.dart';
import '../models/video_progress.dart';

class ApiService {
  Future<List<Playlist>> getPlaylists(String token) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/playlists'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Playlist.fromJson(json)).toList();
    }
    throw Exception('Failed to load playlists');
  }

  Future<void> createPlaylist(String token, String name) async {
    await http.post(
      Uri.parse('${ApiConfig.baseUrl}/playlists'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({'name': name}),
    );
  }

  Future<void> addVideoToPlaylist(
      String token, String playlistId, String videoUrl) async {
    await http.post(
      Uri.parse('${ApiConfig.baseUrl}/playlists/add-video'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({'playlistId': playlistId, 'videoUrl': videoUrl}),
    );
  }

  Future<List<VideoProgress>> getVideoProgress(
      String token, String playlistId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/videos/progress/$playlistId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => VideoProgress.fromJson(json)).toList();
    }
    throw Exception('Failed to load video progress');
  }

  Future<void> updateVideoStatus(
      String token, String progressId, String status) async {
    await http.put(
      Uri.parse('${ApiConfig.baseUrl}/videos/progress'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({'progressId': progressId, 'status': status}),
    );
  }

  Future<void> createVideoProgress(
      String token, String playlistId, String videoUrl) async {
    await http.post(
      Uri.parse('${ApiConfig.baseUrl}/videos/progress'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({'playlistId': playlistId, 'videoUrl': videoUrl}),
    );
  }

  Future<String> getVideoThumbnail(String videoUrl) async {
    if (videoUrl.isEmpty) return '';
    final videoId = videoUrl.split('v=')[1].split('&')[0];
    final response = await http.get(
      Uri.parse(
          'https://www.googleapis.com/youtube/v3/videos?part=snippet&id=$videoId&key=${ApiConfig.youtubeApiKey}'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['items'][0]['snippet']['thumbnails']['medium']['url'];
    }
    return '';
  }

  Future<int> getVideoDuration(String videoUrl) async {
    if (videoUrl.isEmpty) return 0;
    final videoId = videoUrl.split('v=')[1].split('&')[0];
    final response = await http.get(
      Uri.parse(
          'https://www.googleapis.com/youtube/v3/videos?part=contentDetails&id=$videoId&key=${ApiConfig.youtubeApiKey}'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final duration = data['items'][0]['contentDetails']['duration'];
      return _parseDuration(duration);
    }
    return 0;
  }

  int _parseDuration(String duration) {
    final regex = RegExp(r'PT(\d+H)?(\d+M)?(\d+S)?');
    final match = regex.firstMatch(duration);
    int hours = int.parse(match?.group(1)?.replaceAll('H', '') ?? '0');
    int minutes = int.parse(match?.group(2)?.replaceAll('M', '') ?? '0');
    int seconds = int.parse(match?.group(3)?.replaceAll('S', '') ?? '0');
    return hours * 3600 + minutes * 60 + seconds;
  }
}
