import 'package:flutter/material.dart';
import 'package:krs_app/services/auth.dart';
import 'package:krs_app/providers/textdecorator.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _titleSlideAnimation;
  late Animation<Offset> _taglineSlideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _progressAnimation;
  String next = '';

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _titleSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutQuad),
      ),
    );

    _taglineSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.7, curve: Curves.easeOutQuad),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.7, curve: Curves.elasticOut),
      ),
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);

    _startSplashSequence();
  }

  Future<void> _startSplashSequence() async {
    try {
      AuthService auth = AuthService();

      bool isAuthenticated = await auth.isAuthenticated();

      if (isAuthenticated) {
        String status = await auth.getUserStatus();

        if (status == 'pending') {
          setState(() {
            next = '/wait';
          });
        } else if (status == 'active') {
          bool isAdmin = await auth.isAdmin();
          setState(() {
            next = isAdmin ? '/admin-main' : '/main';
          });
        } else if (status == 'inactive') {
          await auth.logout();
          setState(() {
            next = '/login';
          });
        } else {
          await auth.logout();
          setState(() {
            next = '/login';
          });
        }
      } else {
        setState(() {
          next = '/login';
        });
      }
    } catch (e) {
      print('Splash screen error: $e');
      setState(() {
        next = '/login';
      });
    }
    await _controller.forward();

    if (mounted) {
      Navigator.of(context).pushReplacementNamed(next);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.of(context).size.height,
        w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff06132A), Color(0xFF194DA6)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SlideTransition(
                position: _titleSlideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Consumer<OutlinedTextProvider>(
                    builder: (context, provider, child) {
                      return outlinedText(
                        text: "KIIT ROBOTICS",
                        fontSize: w * 0.11,
                        textColor: Color(0xFFEEBE65),
                        outlineColor: Color(0xffE5A122),
                      );
                    },
                  ),
                ),
              ),
              SlideTransition(
                position: _titleSlideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Consumer<OutlinedTextProvider>(
                    builder: (context, provider, child) {
                      return outlinedText(
                        text: "SOCIETY",
                        fontSize: w * 0.11,
                        textColor: Color(0xFFEEBE65),
                        outlineColor: Color(0xffE5A122),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: h * 0.04),
              ScaleTransition(
                scale: _scaleAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xFFFFD700), width: 3),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFFFFD700),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: h * 0.1,
                      backgroundColor: Colors.white,
                      child: const Image(image: AssetImage('assets/logo.png')),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 60),
              SlideTransition(
                position: _taglineSlideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Ideas ',
                        style: TextStyle(
                          color: Color(0xFFFFD700),
                          fontSize: 22,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Icon(Icons.lightbulb, color: Color(0xFFFFD700), size: 30),
                      Text(
                        ' that Enlighten',
                        style: TextStyle(
                          color: Color(0xFFFFD700),
                          fontSize: 22,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: h * 0.08),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.2),
                child: _buildAnimatedProgressIndicator(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedProgressIndicator() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Column(
          children: [
            LinearProgressIndicator(
              backgroundColor: Colors.black,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFFFFD700),
              ),
              value: _progressAnimation.value,
            ),
            const SizedBox(height: 10),
            const Text(
              'INITIALIZING...',
              style: TextStyle(
                color: Color(0xFFFFD700),
                fontSize: 18,
                letterSpacing: 1.5,
                fontFamily: "Poppins",
              ),
            ),
          ],
        );
      },
    );
  }
}
