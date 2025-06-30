import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:krs_app/providers/textdecorator.dart';
import 'package:krs_app/screens/signupdetails.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailController = TextEditingController(),
      passwordController = TextEditingController(),
      confpasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String? _validatePassword(String password) {
    if (password.isEmpty) {
      return "Password is required";
    }

    if (password.length < 8) {
      return "Password must be at least 8 characters long";
    }

    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return "Password must contain at least one uppercase letter";
    }

    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return "Password must contain at least one lowercase letter";
    }

    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return "Password must contain at least one digit";
    }

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return "Password must contain at least one special character (!@#\$%^&*(),.?\":{}|<>)";
    }

    return null;
  }

  void _signup() async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confpasswordController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "All Fields are required!",
        backgroundColor: Colors.red,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG,
      );
      return;
    }
    if (!emailController.text.trim().endsWith('@kiit.ac.in')) {
      Fluttertoast.showToast(
        msg: "Error : Email must belong to university email",
        backgroundColor: Colors.red,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG,
      );
      return;
    }

    String? passwordError = _validatePassword(passwordController.text);
    if (passwordError != null) {
      Fluttertoast.showToast(
        msg: passwordError,
        backgroundColor: Colors.red,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG,
      );
      return;
    }
    if (passwordController.text != confpasswordController.text) {
      Fluttertoast.showToast(
        msg: "Error : Password and Confirm Passwords didn't match",
        backgroundColor: Colors.red,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG,
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => Details(
              email: emailController.text.toString(),
              pass: passwordController.text.toString(),
            ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    confpasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = MediaQuery.sizeOf(context);

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0, backgroundColor: Color(0xff040E1E)),
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                left: -40,
                bottom: -30,
                child: _glowCircle(140, const Color(0xFFF1B500), 80, 30, 50),
              ),
              Positioned(
                right: -60,
                bottom: s.height * 0.4,
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
                  padding: EdgeInsets.only(
                    left: s.width * 0.05,
                    right: s.width * 0.05,
                    bottom: s.height * 0.05,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: s.height * 0.05),
                      Center(
                        child: Column(
                          children: [
                            Consumer<OutlinedTextProvider>(
                              builder: (context, provider, child) {
                                return outlinedText(
                                  text: "KIIT ROBOTICS",
                                  fontSize: s.width * 0.10,
                                  textColor: Color(0xff353535),
                                  outlineColor: Color(0xffE5A122),
                                );
                              },
                            ),
                            Consumer<OutlinedTextProvider>(
                              builder: (context, provider, child) {
                                return outlinedText(
                                  text: "SOCIETY",
                                  fontSize: s.width * 0.10,
                                  textColor: Color(0xff353535),
                                  outlineColor: Color(0xffE5A122),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: s.height * 0.08),
                      Container(
                        padding: EdgeInsets.all(s.width * 0.05),
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
                                      text: 'Welcome!',
                                      style: TextStyle(
                                        color: Color(0xffE5A122),
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: s.height * 0.03),
                            const Text(
                              'Email',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: s.height * 0.01),
                            _buildTextField(
                              Icons.mail_outline_rounded,
                              'example@kiit.ac.in',
                              emailController,
                            ),
                            SizedBox(height: s.height * 0.025),
                            const Text(
                              'Password',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: s.height * 0.01),
                            _buildTextField(
                              Icons.key_rounded,
                              '●●●●●●●●',
                              passwordController,
                              obscureText: true,
                              isPassword: true,
                            ),
                            SizedBox(height: s.height * 0.025),
                            const Text(
                              'Confirm Password',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: s.height * 0.01),
                            _buildTextField(
                              Icons.key_rounded,
                              '●●●●●●●●',
                              confpasswordController,
                              obscureText: true,
                              isConfirmPassword: true,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'Password must contain:\n• At least 8 characters\n• One uppercase letter (A-Z)\n• One lowercase letter (a-z)\n• One digit (0-9)\n• One special character (!@#\$%^&*)',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            SizedBox(height: s.height * 0.035),
                            Container(
                              width: double.infinity,
                              height: s.height * 0.06,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xff194DA6),
                                    Color(0xffE5A122),
                                  ],
                                ),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  _signup();
                                },
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: s.height * 0.02),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Existing User?",
                                  style: TextStyle(color: Colors.white),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "LogIn",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
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
      ),
    );
  }

  Widget _buildTextField(
    IconData icon,
    String hintText,
    TextEditingController controller, {
    bool obscureText = false,
    bool isPassword = false,
    bool isConfirmPassword = false,
  }) {
    return TextField(
      controller: controller,
      cursorColor: Colors.white,
      obscureText:
          obscureText
              ? (isPassword
                  ? _obscurePassword
                  : (isConfirmPassword ? _obscureConfirmPassword : false))
              : false,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.transparent,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white54),
        prefixIcon: Icon(icon, color: Colors.white),
        suffixIcon:
            obscureText
                ? IconButton(
                  icon: Icon(
                    (isPassword ? _obscurePassword : _obscureConfirmPassword)
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      if (isPassword) {
                        _obscurePassword = !_obscurePassword;
                      } else if (isConfirmPassword) {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      }
                    });
                  },
                )
                : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xffE5A122), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red),
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
