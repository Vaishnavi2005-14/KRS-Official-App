import 'package:flutter/material.dart';
import 'dart:math' as math;

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _yellowArcController;
  late AnimationController _blueArcController;

  @override
  void initState() {
    super.initState();

    _yellowArcController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _blueArcController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    // Navigate to login screen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  void dispose() {
    _yellowArcController.dispose();
    _blueArcController.dispose();
    super.dispose();
  }

  // Glowing outlined text function
  Widget outlinedText(String text, double fontSize) {
    return Stack(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w300,
            letterSpacing: 2,
            height: 1.8,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2.5
              ..color = const Color.fromARGB(255, 250, 216, 63),
            shadows: [
              Shadow(
                color: const Color.fromARGB(221, 190, 156, 6).withOpacity(0.9),
                blurRadius: 15,
                offset: Offset(0, 0),
              ),
              Shadow(
                color: Colors.yellow.shade600.withOpacity(0.7),
                blurRadius: 25,
                offset: Offset(0, 0),
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
            height: 1.8,
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
      backgroundColor: const Color(0xFF0A0F2C),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                outlinedText("KIIT ROBOTICS", 42),
                outlinedText("SOCIETY", 42),
              ],
            ),
            const SizedBox(height: 30), // Reduced spacing here
            Center(
              child: SizedBox(
                width: 150,
                height: 150,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // 🔵 Top Arc (Anti-clockwise)
                    RotationTransition(
                      turns: Tween(begin: 0.0, end: -1.0)
                          .animate(_blueArcController),
                      child: CustomPaint(
                        size: const Size(130, 130),
                        painter: FadedArcPainter(
                          baseColor: Colors.blueAccent,
                          isTop: true,
                          strokeWidth: 6,
                        ),
                      ),
                    ),
                    // 🟡 Bottom Arc (Clockwise)
                    RotationTransition(
                      turns: Tween(begin: 0.0, end: 1.0)
                          .animate(_yellowArcController),
                      child: CustomPaint(
                        size: const Size(100, 100),
                        painter: FadedArcPainter(
                          baseColor: Colors.amber,
                          isTop: false,
                          strokeWidth: 6,
                        ),
                      ),
                    ),
                    // 🛑 Static Logo
                    ClipOval(
                      child: Image.asset(
                        'assets/logo.jpg',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
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
}

class FadedArcPainter extends CustomPainter {
  final Color baseColor;
  final bool isTop;
  final double strokeWidth;

  FadedArcPainter({
    required this.baseColor,
    required this.isTop,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final Shader gradientShader = SweepGradient(
      center: Alignment.center,
      startAngle: 0,
      endAngle: math.pi * 2,
      colors: [
        baseColor.withOpacity(0.0),
        baseColor.withOpacity(0.6),
        baseColor.withOpacity(0.0),
        Colors.transparent,
      ],
      stops: const [0.0, 0.25, 0.5, 1.0],
      transform: GradientRotation(isTop ? -math.pi : 0),
    ).createShader(rect);

    final paint = Paint()
      ..shader = gradientShader
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    final startAngle = isTop ? -math.pi : 0;
    final sweepAngle = math.pi;

    canvas.drawArc(rect, startAngle.toDouble(), sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
