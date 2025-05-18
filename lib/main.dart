import 'package:flutter/material.dart';
import 'loadingsc.dart'; // The splash screen
import 'loginsc.dart'; // The login screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
  theme: ThemeData(
    fontFamily: 'Poppins',
  ),

      debugShowCheckedModeBanner: false,
      // Set initial route to Splash
      initialRoute: '/',
      routes: {
        '/': (context) => const LoadingScreen(),       // Splash Screen
        '/login': (context) => const LoginScreen(),    // Login Screen
      },
    );
  }
}
