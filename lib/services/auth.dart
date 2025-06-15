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
      prefs.setString("email", data["user"]["email"]);
      prefs.setString("designation", data["user"]["designation"]);
      prefs.setString("domain", data["user"]["domain"]);
      prefs.setString("image", data["user"]["image"]);
      return true;
    }
    return false;
  }

  Future<String> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String fullName = prefs.getString("name") ?? "Guest";
    return fullName.trim().split(' ').first;
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
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? designation = prefs.getString("designation");

      if (designation == null) return false;

      if (designation == 'Admin') {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
