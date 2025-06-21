import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:krs_app/providers/notice_provider.dart';
import 'package:krs_app/screens/attendance/attendance_record.dart';
import 'package:krs_app/screens/dashboard.dart';
import 'package:krs_app/navbar.dart';
import 'package:krs_app/providers/attendance_view_provider.dart';
import 'package:krs_app/providers/mom_provider.dart';
import 'package:krs_app/screens/notice/notices.dart';
import 'package:krs_app/screens/profile.dart';
import 'package:krs_app/providers/attendance_provider.dart';
import 'package:krs_app/providers/loader.dart';
import 'package:krs_app/providers/navprovider.dart';
import 'package:krs_app/providers/textdecorator.dart';
import 'package:krs_app/screens/signup.dart';
import 'package:krs_app/screens/attendance/attendance_home.dart';
import 'package:krs_app/screens/attendance/attendance_marking.dart';
import 'package:krs_app/screens/splash.dart';
import 'package:krs_app/screens/waiting.dart';
import 'package:provider/provider.dart';
import 'package:krs_app/screens/loginsc.dart';
import 'package:krs_app/providers/attendance_gateway_provider.dart';
import 'package:krs_app/providers/user_selection_provider.dart';
import 'package:krs_app/providers/user_attendance_provider.dart';
import 'package:krs_app/screens/attendance/attendance_gateway.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AttendanceProvider()),
        ChangeNotifierProvider(create: (_) => OutlinedTextProvider()),
        ChangeNotifierProvider(create: (_) => LoaderProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => AttendanceViewProvider()),
        ChangeNotifierProvider(create: (_) => AttendanceGatewayProvider()),
        ChangeNotifierProvider(create: (_) => UserSelectionProvider()),
        ChangeNotifierProvider(create: (_) => UserAttendanceProvider()),
        ChangeNotifierProvider(create: (_) => MoMProvider()),
        ChangeNotifierProvider(create: (_) => NoticeProvider()),
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Poppins',
        textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.black),
        scaffoldBackgroundColor: const Color(0xff040E1E),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFE5A122),
          elevation: 0,
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/main': (context) => Navbar(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUp(),
        '/profile': (context) => const ProfileScreen(),
        '/notices': (context) =>  NoticeBoardPage(),
        '/attendance-home': (context) => AttendanceHomePage(),
        '/attendance-marking': (context) => AttendanceMarkingPage(),
        '/attendance-record': (context) => AttendanceRecordsPage(),
        '/attendance-gateway': (context) => AttendanceGatewayPage(),
        '/dashboard': (context) => const DashboardScreen(),
        '/wait': (context) => Waiting(),
      },
    );
  }
}
