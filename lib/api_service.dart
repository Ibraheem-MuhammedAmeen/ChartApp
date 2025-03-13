import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.0.2.2:3000";

  static Future<Map<String, String>?> getToken(String userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/generate-token'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"userId": userId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'token': data['token'], // ✅ This is the real Stream token
          'apiKey': data['apiKey'],
        };
      } else {
        print("⚠️ Error fetching token: ${response.body}");
        return null;
      }
    } catch (e) {
      print("❌ Error: $e");
      return null;
    }
  }
}
