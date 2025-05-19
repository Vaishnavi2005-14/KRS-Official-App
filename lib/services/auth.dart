import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = "https://krs-app-server.vercel.app/api/auth";

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("token", data["token"]);
      prefs.setString("name", data["user"]["name"]);
      prefs.setInt("roll", data["user"]["roll"]);
      prefs.setString("designation", data["user"]["designation"]);
      return true;
    }
    return false;
  }

  Future<bool> isAuthenticated() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token == null) return false;

    final response = await http.get(
      Uri.parse("$baseUrl/dashboard"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      await logout();
      return false;
    }
  }

  Future<bool> isAdmin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? designation = prefs.getString("designation");

    if (designation == null) return false;

    if (designation == 'Admin') {
      return true;
    } else {
      return false;
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}