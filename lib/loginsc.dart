import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  // Glowing outlined text function
  Widget outlinedText(String text, double fontSize) {
    return Stack(
      children: [
        // Glowing border
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w300,
            letterSpacing: 2,
            height: 1.2,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2.5
              ..color = const Color.fromARGB(255, 250, 216, 63),
            shadows: [
              Shadow(
                color: const Color.fromARGB(221, 190, 156, 6).withOpacity(0.9),
                blurRadius: 15,
              ),
              Shadow(
                color: Colors.yellow.shade600.withOpacity(0.7),
                blurRadius: 25,
              ),
            ],
          ),
        ),
        // Filled text
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
                color: Colors.black.withOpacity(0.6),
                blurRadius: 5,
                offset: Offset(0, 1),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
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

          // Glows
          Positioned(
            left: -40,
            bottom: -30,
            child: _glowCircle(140, const Color(0xFFF1B500), 80, 30, 50),
          ),
          Positioned(
            right: -60,
            bottom: 250,
            child: _glowCircle(160, const Color(0xFFF1B500), 70, 25, 40),
          ),
          Positioned(
            right: 10,
            bottom: 20,
            child: _glowCircle(120, const Color(0xFFF1B500), 30, 30, 20, narrow: true),
          ),

          // Main UI
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  Center(
                    child: Column(
                      children: [
                        outlinedText("KIIT ROBOTICS", 40),
                        outlinedText("SOCIETY", 40),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
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
                        const SizedBox(height: 30),
                        const Text('Username',
                            style: TextStyle(color: Colors.white, fontSize: 14)),
                        const SizedBox(height: 8),
                        _buildTextField(Icons.person, 'Username'),
                        const SizedBox(height: 20),
                        const Text('Password',
                            style: TextStyle(color: Colors.white, fontSize: 14)),
                        const SizedBox(height: 8),
                        _buildTextField(Icons.key, 'Password',
                            obscureText: true),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                              colors: [Colors.blueAccent, Colors.amber],
                            ),
                          ),
                          child: TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Log In",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
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
                              width: 40,
                              height: 40,
                            
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
    );
  }

  Widget _buildTextField(IconData icon, String hintText,
      {bool obscureText = false}) {
    return TextField(
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.transparent,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white54),
        prefixIcon: Icon(icon, color: Colors.white70),
        suffixIcon: obscureText
            ? const Icon(Icons.visibility_off, color: Colors.white70)
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

  Widget _glowCircle(double size, Color color, double blur, double spread,
      double blurSigma,
      {bool narrow = false}) {
    return Container(
      width: narrow ? 30 : size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.3),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
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
