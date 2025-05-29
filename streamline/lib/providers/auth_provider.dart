import 'package:flutter/material.dart';
import '../services/auth_service.dart';

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
    final user = await _authService.signInWithGoogle();
    _token = user['token'];
    _userId = user['user']['uid'];
    _displayName = user['user']['displayName'];
    _photoUrl = user['user']['photoUrl'];
    notifyListeners();
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
