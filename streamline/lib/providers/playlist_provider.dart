import 'package:flutter/material.dart';
import '../models/playlist.dart';
import '../models/video_progress.dart';
import '../services/api_service.dart';

class PlaylistProvider with ChangeNotifier {
  List<Playlist> _playlists = [];
  List<VideoProgress> _progress = [];
  final ApiService _apiService = ApiService();

  List<Playlist> get playlists => _playlists;
  List<VideoProgress> get progress => _progress;

  Future<void> fetchPlaylists(String token) async {
    _playlists = await _apiService.getPlaylists(token);
    notifyListeners();
  }

  Future<void> createPlaylist(String token, String name) async {
    await _apiService.createPlaylist(token, name);
    await fetchPlaylists(token);
  }

  Future<void> addVideoToPlaylist(
      String token, String playlistId, String videoUrl) async {
    await _apiService.addVideoToPlaylist(token, playlistId, videoUrl);
    await fetchPlaylists(token);
  }

  Future<void> fetchVideoProgress(String token, String playlistId) async {
    _progress = await _apiService.getVideoProgress(token, playlistId);
    notifyListeners();
  }

  Future<void> updateVideoStatus(
      String token, String progressId, String status) async {
    await _apiService.updateVideoStatus(token, progressId, status);
    await fetchVideoProgress(
        token, _progress.firstWhere((p) => p.id == progressId).playlistId);
  }

  Future<void> createVideoProgress(
      String token, String playlistId, String videoUrl) async {
    await _apiService.createVideoProgress(token, playlistId, videoUrl);
    await fetchVideoProgress(token, playlistId);
  }
}
