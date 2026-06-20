import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class ApiService {
  // 10.0.2.2 points to your computer's localhost from the Android Emulator
  static const String baseUrl = 'http://10.0.2.2:5000/api';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // --- FETCH SKILLS MATRIX ---
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

  // --- FIREBASE LOGIN ---
  Future<bool> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user != null;
    } catch (e) {
      print("Firebase Login Error: $e");
      return false;
    }
  }

  // --- LINKED SIGN UP (FIREBASE + POSTGRESQL) ---
  Future<bool> signUp(String name, String email, String password) async {
    try {
      // Step 1: Create user in Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (userCredential.user != null) {
        // Update their Firebase profile display name
        await userCredential.user!.updateDisplayName(name);
        String firebaseUid = userCredential.user!.uid;

        // Step 2: Sync profile data with your PostgreSQL backend
        final response = await http.post(
          Uri.parse('$baseUrl/auth/signup'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'uid': firebaseUid, // Pass the unique Firebase ID as a foreign key reference
            'name': name,
            'email': email,
          }),
        );

        // Returns true if your Express Node server successfully inserts rows into PostgreSQL (Status 201 or 200)
        return response.statusCode == 201 || response.statusCode == 200;
      }
      return false;
    } catch (e) {
      print("Linked Signup Error: $e");
      return false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}