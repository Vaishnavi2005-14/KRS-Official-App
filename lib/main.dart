import 'package:flutter/material.dart';
import 'package:krs_app/loginsc.dart' show LoginScreen;
import 'package:provider/provider.dart';
import 'profile.dart'; // Ensure this imports ProfileScreen and ProfileModel

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Poppins'),
      debugShowCheckedModeBanner: false,
       initialRoute: '/login',
       routes: {
         '/login': (context) => const LoginScreen(),    // Login Screen
         '/profile':(context)=> const ProfileScreen(),  // Profile Page
       },
    );
  }
}

