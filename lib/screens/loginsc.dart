import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:krs_app/admindash.dart';
import 'package:krs_app/dashboard.dart';
import 'package:krs_app/services/auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController(),
      passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _obscurePassword = true;

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    bool success = await _authService.login(
      emailController.text,
      passwordController.text,
    );
    bool isAdmin = await _authService.isAdmin();

    setState(() {
      _isLoading = false;
    });

    if (success) {
      if (isAdmin) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminDashboardScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Invalid credentials!"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget outlinedText(String text, double fontSize) {
    return Stack(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w300,
            letterSpacing: 2,
            height: 1.2,
            foreground:
                Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 2.5
                  ..color = const Color.fromARGB(255, 250, 216, 63),
            shadows: [
              Shadow(
                color: const Color.fromARGB(221, 190, 156, 6).withAlpha(230),
                blurRadius: 15,
              ),
              Shadow(
                color: Colors.yellow.shade600.withAlpha(180),
                blurRadius: 25,
              ),
            ],
          ),
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w300,
            letterSpacing: 2,
            height: 1.2,
            color: const Color.fromARGB(107, 224, 224, 224),
            shadows: [
              Shadow(
                color: Colors.black.withAlpha(155),
                blurRadius: 5,
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 0, 14, 38),
                    Color.fromARGB(255, 5, 39, 97),
                    Color.fromARGB(255, 1, 48, 122),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Positioned(
              left: -40,
              bottom: -30,
              child: _glowCircle(140, const Color(0xFFF1B500), 80, 30, 50),
            ),
            Positioned(
              right: -60,
              bottom: height * 0.4,
              child: _glowCircle(160, const Color(0xFFF1B500), 70, 25, 40),
            ),
            Positioned(
              right: 10,
              bottom: 20,
              child: _glowCircle(
                120,
                const Color(0xFFF1B500),
                30,
                30,
                20,
                narrow: true,
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: Column(
                  children: [
                    SizedBox(height: height * 0.12),
                    Center(
                      child: Column(
                        children: [
                          outlinedText("KIIT ROBOTICS", width * 0.08),
                          outlinedText("SOCIETY", width * 0.08),
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.08),
                    Container(
                      padding: EdgeInsets.all(width * 0.05),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(53),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Welcome ',
                                    style: TextStyle(
                                      color: Colors.amber,
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Back!',
                                    style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.03),
                          const Text(
                            'Email',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          SizedBox(height: height * 0.01),
                          _buildTextField(
                            Icons.person,
                            'Email',
                            emailController,
                          ),
                          SizedBox(height: height * 0.025),
                          const Text(
                            'Password',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          SizedBox(height: height * 0.01),
                          _buildTextField(
                            Icons.key,
                            'Password',
                            passwordController,
                            obscureText: true,
                          ),
                          // const SizedBox(height: 10),
                          // Align(
                          //   alignment: Alignment.centerRight,
                          //   child: TextButton(
                          //     onPressed: () {},
                          //     child: const Text(
                          //       "Forgot Password?",
                          //       style: TextStyle(
                          //         color: Colors.white54,
                          //         fontSize: 12,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          SizedBox(height: height * 0.015),
                          Container(
                            width: double.infinity,
                            height: height * 0.06,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: const LinearGradient(
                                colors: [Colors.blueAccent, Colors.amber],
                              ),
                            ),
                            child: TextButton(
                              onPressed: _login,
                              child: const Text(
                                "Log In",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.03),
                          Center(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.amber),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () {},
                              icon: SvgPicture.asset(
                                'assets/ggl.svg',
                                width: width * 0.06,
                                height: width * 0.06,
                              ),
                              label: const Text(
                                'Sign in with Google',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    IconData icon,
    String hintText,
    TextEditingController controller, {
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      cursorColor: Colors.white,
      obscureText: obscureText ? _obscurePassword : false,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.transparent,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white54),
        prefixIcon: Icon(icon, color: Colors.white70),
        suffixIcon:
            obscureText
                ? IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white70,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                )
                : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.amber),
        ),
      ),
    );
  }

  Widget _glowCircle(
    double size,
    Color color,
    double blur,
    double spread,
    double blurSigma, {
    bool narrow = false,
  }) {
    return Container(
      width: narrow ? 30 : size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withAlpha(78),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(103),
            blurRadius: blur,
            spreadRadius: spread,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(color: Colors.transparent),
      ),
    );
  }
}
