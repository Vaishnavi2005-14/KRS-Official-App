import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:krs_app/providers/loader.dart';
import 'package:krs_app/providers/textdecorator.dart';
import 'package:krs_app/services/auth.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController(),
      passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _obscurePassword = true;

  void _login() async {
    FocusScope.of(context).unfocus();
    Provider.of<LoaderProvider>(context, listen: false).showLoader(context);
    print("USer Name & Password : ${emailController.text}, ${passwordController.text}");
    bool success = await _authService.login(
      emailController.text,
      passwordController.text,
    );

    if (!mounted) return;
    Provider.of<LoaderProvider>(context, listen: false).hideLoader();

    if (!mounted) return;

    if (success) {
      await Fluttertoast.showToast(
        msg: "Login Successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      if (!mounted) return;

      String status = await _authService.getUserStatus();
      if (status == 'pending') {
        Navigator.pushReplacementNamed(context, '/wait');
      } else if (status == 'active') {
        bool isAdmin = await _authService.isAdmin();
        if (isAdmin) {
          Navigator.pushReplacementNamed(context, '/admin-main');
        } else {
          Navigator.pushReplacementNamed(context, '/main');
        }
      } else {
        await Fluttertoast.showToast(
          msg: "Your account has been deactivated. Contact admin.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } else {
      await Fluttertoast.showToast(
        msg: "Invalid Credentials",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void _googleSignIn() async {
    Provider.of<LoaderProvider>(context, listen: false).showLoader(context);

    bool success = await _authService.googleSign();

    if (!mounted) return;
    Provider.of<LoaderProvider>(context, listen: false).hideLoader();

    if (success) {
      await Fluttertoast.showToast(
        msg: "Google Sign-In Successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      if (!mounted) return;

      String status = await _authService.getUserStatus();
      print("User status: $status");
      FocusScope.of(context).unfocus();
      if (status == 'pending') {
        Navigator.pushReplacementNamed(context, '/wait');
      } else if (status == 'active') {
        bool isAdmin = await _authService.isAdmin();
        if (isAdmin) {
          Navigator.pushReplacementNamed(context, '/admin-main');
        } else {
          Navigator.pushReplacementNamed(context, '/main');
        }
      } else {
        // yeh likh raaha hu ku ki mujhe yaadh nehi rehta haaye so yeha inactive user k code haaye
        await Fluttertoast.showToast(
          msg: "Your account has been deactivated. Contact admin.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } else {
      await Fluttertoast.showToast(
        msg: "Google Sign-In Failed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  // void _googleSignIn() async {
  //   Provider.of<LoaderProvider>(context, listen: false).showLoader(context);

  //   bool success = await _authService.googleSign();

  //   if (!mounted) return;
  //   Provider.of<LoaderProvider>(context, listen: false).hideLoader();

  //   if (success) {
  //     bool isAdmin = await _authService.isAdmin();

  //     if (!mounted) return;

  //     if (isAdmin) {
  //       Navigator.pushReplacementNamed(context, '/main');
  //     } else {
  //       Navigator.pushReplacementNamed(context, '/main');
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0, backgroundColor: Color(0xff040E1E)),
        body: Stack(
          children: [
            Container(decoration: const BoxDecoration()),
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
                padding: EdgeInsets.only(
                  left: width * 0.05,
                  right: width * 0.05,
                  bottom: height * 0.05,
                ),
                child: Column(
                  children: [
                    SizedBox(height: height * 0.06),
                    Center(
                      child: Column(
                        children: [
                          Consumer<OutlinedTextProvider>(
                            builder: (context, provider, child) {
                              return outlinedText(
                                text: "KIIT ROBOTICS",
                                fontSize: width * 0.11,
                                textColor: Color(0xff353535),
                                outlineColor: Color(0xffE5A122),
                              );
                            },
                          ),
                          Consumer<OutlinedTextProvider>(
                            builder: (context, provider, child) {
                              return outlinedText(
                                text: "SOCIETY",
                                fontSize: width * 0.11,
                                textColor: Color(0xff353535),
                                outlineColor: Color(0xffE5A122),
                              );
                            },
                          ),
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
                          SizedBox(height: height * 0.025),
                          Container(
                            width: double.infinity,
                            height: height * 0.06,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: const LinearGradient(
                                colors: [Color(0xff194DA6), Color(0xffE5A122)],
                              ),
                            ),
                            child: TextButton(
                              onPressed: () {
                                // FocusScope.of(context).unfocus;
                                _login();
                              },
                              child: const Text(
                                "Log In",
                                style: TextStyle(
                                  fontSize: 20,
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
                                side: const BorderSide(
                                  color: Color(0xffE5A122),
                                  width: 2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              onPressed: _googleSignIn,
                              icon: SvgPicture.asset(
                                'assets/ggl.svg',
                                width: width * 0.06,
                                height: width * 0.06,
                              ),
                              label: const Text(
                                'Continue with Google',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "New to KRS Workspace?",
                                style: TextStyle(color: Colors.white),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/signup');
                                },
                                child: Text(
                                  "SignUp",
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
        prefixIcon: Icon(icon, color: Colors.white),
        suffixIcon:
            obscureText
                ? IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.white,
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
