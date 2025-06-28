import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import './notification_service.dart';

class AuthService {
  final String? webId = dotenv.env['GOOGLE_CLIENT_ID'];

  final String baseUrl = "https://krs-app-server.vercel.app/api/auth";

  GoogleSignIn? _googleSignIn;

  GoogleSignIn get googleSignIn {
    print("Web Client ID: $webId");
    _googleSignIn ??= GoogleSignIn(
      scopes: <String>['email', 'profile', 'openid'],
      serverClientId: webId,
    );
    return _googleSignIn!;
  }

  Future<void> initializeNotifications() async {
    try {
      await NotificationService().initialize();
      print('Notification service initialized');
    } catch (e) {
      print('Error initializing notification service: $e');
    }
  }

  Future<void> initializeFCM() async {
    try {
      if (Firebase.apps.isEmpty) {
        return;
      }

      FirebaseMessaging messaging = FirebaseMessaging.instance;

      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted notification permission');

        String? fcmToken = await messaging.getToken();
        if (fcmToken != null) {
          print('FCM Token: $fcmToken');
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('fcm_token', fcmToken);
        }
      } else {
        print('User denied notification permission');
      }
    } catch (e) {
      print('FCM initialization error: $e');
    }
  }

  Future<String?> getFCMToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('fcm_token', token);
      }
      return token;
    } catch (e) {
      print('Error getting FCM token: $e');
      return null;
    }
  }

  Future<bool> login(String email, String password) async {
    String? fcmToken;

    try {
      fcmToken = await getFCMToken();
    } catch (e) {
      print('Warning: FCM failed: $e');
    }

    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
        if (fcmToken != null) "fcmToken": fcmToken,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("token", data["token"]);
      prefs.setString("userId", data["user"]["id"]);
      prefs.setString("name", data["user"]["name"]);
      prefs.setString("email", data["user"]["email"]);
      prefs.setString("designation", data["user"]["designation"]);
      prefs.setString("domain", data["user"]["domain"] ?? "");
      prefs.setString("image", data["user"]["image"] ?? "");
      prefs.setString("status", data["user"]["status"] ?? "pending");
      prefs.setString("roll", data["user"]["roll"]?.toString() ?? "");
      prefs.setString("phone", data["user"]["phone"]?.toString() ?? "");
      prefs.setString("branch", data["user"]["branch"] ?? "");
      prefs.setString("year", data["user"]["year"] ?? "");

      await initializeNotifications();
      return true;
    }
    return false;
  }

  Future<bool> signup(
    String name,
    String email,
    String domain,
    String roll,
    String phone,
    String branch,
    String year,
    String pass,
  ) async {
    try {
      String? fcmToken;

      try {
        fcmToken = await getFCMToken();
      } catch (e) {
        print('Warning: FCM failed: $e');
      }

      final res = await http.post(
        Uri.parse("$baseUrl/signup"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "domain": domain,
          "roll": roll,
          "phone": phone,
          "branch": branch,
          "year": year,
          "password": pass,
          "designation": "Member",
          if (fcmToken != null) "fcmToken": fcmToken,
        }),
      );

      if (res.statusCode == 201) {
        final data = jsonDecode(res.body);

        if (data['token'] != null && data['user'] != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("token", data["token"]);
          prefs.setString("userId", data["user"]["id"]);
          prefs.setString("name", data["user"]["name"]);
          prefs.setString("email", data["user"]["email"]);
          prefs.setString(
            "designation",
            data["user"]["designation"] ?? "Member",
          );
          prefs.setString("domain", data["user"]["domain"] ?? "");
          prefs.setString("image", data["user"]["image"] ?? "");
          prefs.setString("status", data["user"]["status"] ?? "pending");
          prefs.setString("roll", data["user"]["roll"]?.toString() ?? "");
          prefs.setString("phone", data["user"]["phone"]?.toString() ?? "");
          prefs.setString("branch", data["user"]["branch"] ?? "");
          prefs.setString("year", data["user"]["year"] ?? "");
        }

        await initializeNotifications();

        Fluttertoast.showToast(
          msg:
              "Your Account has been successfully created. Please Proceed to login.",
          backgroundColor: Colors.green,
          toastLength: Toast.LENGTH_LONG,
        );

        return true;
      }

      Fluttertoast.showToast(
        msg: jsonDecode(res.body)['message'] ?? 'Signup failed',
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_LONG,
      );
      return false;
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error : $e",
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_LONG,
      );
      return false;
    }
  }

  Future<bool> googleSign() async {
    try {
      await googleSignIn.signOut();

      Fluttertoast.showToast(
        msg: "Initiating Google Sign-In...",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        Fluttertoast.showToast(
          msg: "Google Sign-In cancelled",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
        );
        return false;
      }

      Fluttertoast.showToast(
        msg: "Authenticating with server...",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
      );

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      String? idToken = googleAuth.idToken;

      if (idToken == null) {
        Fluttertoast.showToast(
          msg: "Failed to get Google ID token",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return false;
      }

      String? fcmToken;
      try {
        fcmToken = await getFCMToken();
      } catch (e) {
        print('Warning: FCM failed: $e');
      }

      final response = await http.post(
        Uri.parse("$baseUrl/google/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "idToken": idToken,
          if (fcmToken != null) "fcmToken": fcmToken,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("token", data["token"]);
        prefs.setString("userId", data["user"]["id"]);
        prefs.setString("name", data["user"]["name"]);
        prefs.setString("email", data["user"]["email"]);
        prefs.setString("designation", data["user"]["designation"]);
        prefs.setString("domain", data["user"]["domain"] ?? "");
        prefs.setString("image", data["user"]["image"] ?? "");
        prefs.setString("status", data["user"]["status"] ?? "pending");
        prefs.setString("roll", data["user"]["roll"]?.toString() ?? "");
        prefs.setString("phone", data["user"]["phone"]?.toString() ?? "");
        prefs.setString("branch", data["user"]["branch"] ?? "");
        prefs.setString("year", data["user"]["year"] ?? "");

        await initializeNotifications();

        Fluttertoast.showToast(
          msg: "Google Sign-In successful!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        String errorMessage = errorData['message'] ?? 'Google Sign-In failed';

        Fluttertoast.showToast(
          msg: errorMessage,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );

        await googleSignIn.signOut();
        return false;
      }
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Google Sign-In failed: ${error.toString().split(':')[0]}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );

      await googleSignIn.signOut();
      return false;
    }
  }

  Future<String> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String fullName = prefs.getString("name") ?? "Guest";
    return fullName.trim().split(' ').first;
  }

  Future<String> getUserStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("status") ?? "pending";
  }

  Future<String> getUserDesignation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("designation") ?? "Member";
  }

  Future<bool> isAuthenticated() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token == null) return false;

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/dashboard"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['user'] != null) {
          prefs.setString("status", data['user']['status'] ?? "pending");
          prefs.setString(
            "designation",
            data['user']['designation'] ?? "Member",
          );
          prefs.setString("name", data['user']['name'] ?? "");
          prefs.setString("email", data['user']['email'] ?? "");
          prefs.setString("domain", data['user']['domain'] ?? "");
          prefs.setString("image", data['user']['image'] ?? "");
          prefs.setString("roll", data['user']['roll']?.toString() ?? "");
          prefs.setString("phone", data['user']['phone']?.toString() ?? "");
          prefs.setString("branch", data['user']['branch'] ?? "");
          prefs.setString("year", data['user']['year'] ?? "");
        }
        return true;
      } else {
        await logout();
        return false;
      }
    } catch (e) {
      print('Auth check error: $e');
      return false;
    }
  }

  Future<bool> isAdmin() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? designation = prefs.getString("designation");

      if (designation == null) return false;

      return ['Admin', 'Lead', 'Coordinator', 'ASCO'].contains(designation);
    } catch (e) {
      return false;
    }
  }

  Future<bool> isSuperUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? designation = prefs.getString("designation");

      if (designation == null) return false;

      return ['Coordinator', 'ASCO'].contains(designation);
    } catch (e) {
      return false;
    }
  }

  Future<bool> isPrivilegedAdminOperationsUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? designation = prefs.getString("designation");
      String? domain = prefs.getString("domain");

      if (designation == null || domain == null) return false;

      if (["ASCO", "Coordinator", "Lead"].contains(designation)) {
        return true;
      }

      if (designation == "Admin" && domain == "Operations") {
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    try {
      await googleSignIn.signOut();
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error signing out from google",
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
}
