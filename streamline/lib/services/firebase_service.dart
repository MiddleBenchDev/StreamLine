import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:streamline/config/api_config.dart';
import 'dart:convert';

class FirebaseService {
  static Future<String?> getIdToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    return await user.getIdToken();
  }

  static Future<Map<String, dynamic>> loginWithFirebase(String idToken) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'idToken': idToken}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to login with backend');
  }
}
