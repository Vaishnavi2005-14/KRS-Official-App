import 'package:flutter/material.dart';
import 'package:krs_app/home.dart';
import 'package:krs_app/navbar.dart';
import 'package:krs_app/screens/profile.dart';
import 'package:krs_app/providers/attendance_provider.dart';
import 'package:krs_app/providers/loader.dart';
import 'package:krs_app/providers/navprovider.dart';
import 'package:krs_app/providers/textdecorator.dart';
import 'package:krs_app/screens/attendance_page.dart';
import 'package:krs_app/screens/splash.dart';
import 'package:provider/provider.dart';
import 'package:krs_app/screens/loginsc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AttendanceProvider()),
        ChangeNotifierProvider(create: (_) => OutlinedTextProvider()),
        ChangeNotifierProvider(create: (_) => LoaderProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? authToken = '';
  Future<void> getAuthtoken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      authToken = prefs.getString('token');
    });
  }

  void intiState() {
    super.initState();
    getAuthtoken();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color(0xff040E1E),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF040E1E),
          elevation: 0,
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => Home(),
        '/login': (context) => LoginScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/attendance': (context) => AttendancePage(authToken: authToken ?? ''),
        '/main': (context) => Navbar(),
      },
    );
  }
}
