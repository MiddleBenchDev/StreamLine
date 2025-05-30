import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:streamline/config/api_config.dart';
import 'package:streamline/models/playlist.dart';
import 'package:streamline/models/video_progress.dart';

class ApiService {
  final String token;

  ApiService(this.token);

  Future<List<Playlist>> getPlaylists() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/playlists'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Playlist.fromJson(json)).toList();
    }
    throw Exception('Failed to fetch playlists');
  }

  Future<void> createPlaylist(String name) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/playlists'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'name': name}),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create playlist');
    }
  }

  Future<void> addVideoToPlaylist(String playlistId, String videoUrl) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/playlists/add-video'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'playlistId': playlistId, 'videoUrl': videoUrl}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to add video');
    }
  }

  Future<void> deletePlaylist(String playlistId) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/playlists/$playlistId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete playlist');
    }
  }

  Future<List<VideoProgress>> getVideoProgress(String playlistId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/videos/progress/$playlistId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => VideoProgress.fromJson(json)).toList();
    }
    throw Exception('Failed to fetch video progress');
  }

  Future<void> createVideoProgress(String playlistId, String videoUrl) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/videos/progress'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'playlistId': playlistId, 'videoUrl': videoUrl}),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create video progress');
    }
  }

  Future<void> updateVideoStatus(String progressId, String status) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/videos/progress'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'progressId': progressId, 'status': status}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update video status');
    }
  }
}
