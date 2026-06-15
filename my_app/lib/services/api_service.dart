import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // 10.0.2.2 points directly back to your computer's localhost from the Android emulator
  static const String baseUrl = 'http://10.0.2.2:5000/api';

  Future<List<String>> fetchSkills() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/skills'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => item['skill_name'].toString()).toList();
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to backend: $e');
    }
  }
}