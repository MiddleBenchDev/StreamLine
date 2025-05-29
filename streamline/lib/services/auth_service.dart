import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  Future<Map<String, dynamic>> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) throw Exception('Sign in cancelled');
    final googleAuth = await googleUser.authentication;
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'idToken': googleAuth.idToken}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'token': data['token'],
        'user': {
          'uid': data['user']['uid'],
          'displayName': googleUser.displayName,
          'photoUrl': googleUser.photoUrl,
        }
      };
    }
    throw Exception('Failed to sign in');
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
