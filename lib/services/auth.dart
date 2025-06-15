import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = "https://krs-app-server.vercel.app/api/auth";

  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      print("Login response status: ${response.statusCode}");
      print("Login response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        
        // Store token and user data
        await prefs.setString("token", data["token"]);
        await prefs.setString("name", data["user"]["name"]);
        await prefs.setString("email", data["user"]["email"]);
        await prefs.setString("designation", data["user"]["designation"]);
        await prefs.setString("domain", data["user"]["domain"]);
        await prefs.setString("image", data["user"]["image"]);

        // Verify storage
        final storedToken = prefs.getString("token");
        print("Token stored successfully: ${storedToken != null && storedToken.isNotEmpty}");
        print("User email stored: ${prefs.getString("email")}");

        return true;
      } else if (response.statusCode == 401) {
        print("Login failed: Invalid credentials");
      } else {
        print("Login failed: Server error");
      }
      return false;
    } catch (e) {
      print("Login error: $e");
      return false;
    }
  }

  Future<bool> isAuthenticated() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");
      print("Token exists: ${token != null}");

      if (token == null) return false;

      final response = await http.get(
        Uri.parse("$baseUrl/dashboard"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("Auth check status: ${response.statusCode}");
      
      if (response.statusCode == 200) {
        print("User is authenticated");
        return true;
      } else {
        print("Auth check failed, logging out");
        await logout();
        return false;
      }
    } catch (e) {
      print("Auth check error: $e");
      return false;
    }
  }

  Future<bool> isAdmin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final designation = prefs.getString("designation");
      print("User designation: $designation");

      return designation == 'Admin';
    } catch (e) {
      print("Admin check error: $e");
      return false;
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      print("User logged out successfully");
    } catch (e) {
      print("Logout error: $e");
    }
  }
}
