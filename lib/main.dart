import 'package:flutter/material.dart';
import 'package:krs_app/providers/attendance_provider.dart';
import 'package:krs_app/screens/attendance_page.dart';
import 'package:provider/provider.dart';

// Your screens and providers
import 'package:krs_app/screens/loginsc.dart' show LoginScreen;
import 'profile.dart'; // Exports ProfileScreen and ProfileModel


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileModel()),
        ChangeNotifierProvider(create: (_) => AttendanceProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // You would normally get this after login
  final String authToken = 'your_auth_token_here';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color.fromARGB(255, 5, 13, 93),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 5, 13, 93),
          elevation: 0,
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/attendance': (context) => AttendancePage(authToken: authToken),
      },
    );
  }
}
