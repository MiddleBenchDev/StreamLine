import 'package:flutter/material.dart';
import 'package:streamline/models/playlist.dart';
import 'package:streamline/models/video_progress.dart';
import 'package:streamline/services/api_service.dart';

class PlaylistProvider with ChangeNotifier {
  List<Playlist> _playlists = [];
  List<VideoProgress> _progress = [];

  List<Playlist> get playlists => _playlists;
  List<VideoProgress> get progress => _progress;

  Future<void> fetchPlaylists(String token) async {
    final apiService = ApiService(token);
    _playlists = await apiService.getPlaylists();
    notifyListeners();
  }

  Future<void> createPlaylist(String token, String name) async {
    final apiService = ApiService(token);
    await apiService.createPlaylist(name);
    await fetchPlaylists(token);
  }

  Future<void> addVideoToPlaylist(
      String token, String playlistId, String videoUrl) async {
    final apiService = ApiService(token);
    await apiService.addVideoToPlaylist(playlistId, videoUrl);
    await fetchPlaylists(token);
  }

  Future<void> fetchVideoProgress(String token, String playlistId) async {
    final apiService = ApiService(token);
    _progress = await apiService.getVideoProgress(playlistId);
    notifyListeners();
  }

  Future<void> updateVideoStatus(
      String token, String progressId, String status) async {
    final apiService = ApiService(token);
    await apiService.updateVideoStatus(progressId, status);
    final playlistId =
        _progress.firstWhere((p) => p.id == progressId).playlistId;
    await fetchVideoProgress(token, playlistId);
  }

  Future<void> createVideoProgress(
      String token, String playlistId, String videoUrl) async {
    final apiService = ApiService(token);
    await apiService.createVideoProgress(playlistId, videoUrl);
    await fetchVideoProgress(token, playlistId);
  }

  Future<void> deletePlaylist(String token, String playlistId) async {
    final apiService = ApiService(token);
    await apiService.deletePlaylist(playlistId);
    await fetchPlaylists(token);
  }
}
