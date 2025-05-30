import 'package:flutter/material.dart';
import 'package:streamline/services/auth_service.dart';
import 'package:streamline/services/firebase_service.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _userId;
  String? _displayName;
  String? _photoUrl;

  String? get token => _token;
  String? get userId => _userId;
  String? get displayName => _displayName;
  String? get photoUrl => _photoUrl;

  final AuthService _authService = AuthService();

  Future<void> signInWithGoogle() async {
    try {
      final userCredential = await _authService.signInWithGoogle();
      if (userCredential == null) {
        throw Exception('Google Sign-In cancelled or failed');
      }
      final idToken = await FirebaseService.getIdToken();
      if (idToken == null) {
        throw Exception('Failed to get ID token');
      }
      final response = await FirebaseService.loginWithFirebase(idToken);
      _token = response['token'] as String?;
      _userId = response['user']['uid'] as String?;
      _displayName = response['user']['displayName'] as String?;
      _photoUrl = response['user']['photoUrl'] as String?;
      notifyListeners();
    } catch (e) {
      _token = null;
      _userId = null;
      _displayName = null;
      _photoUrl = null;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _token = null;
    _userId = null;
    _displayName = null;
    _photoUrl = null;
    notifyListeners();
  }
}
