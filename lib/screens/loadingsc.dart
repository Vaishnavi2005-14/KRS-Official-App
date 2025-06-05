import 'package:flutter/material.dart';
import 'dart:math' as math;

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({super.key});

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>
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
  }

  @override
  void dispose() {
    _yellowArcController.dispose();
    _blueArcController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.of(context).size.height;
    return SizedBox(
      width: 150,
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          RotationTransition(
            turns: Tween(
              begin: 0.0,
              end: -1.0,
            ).animate(_blueArcController),
            child: CustomPaint(
              size: const Size(130, 130),
              painter: FadedArcPainter(
                baseColor: const Color(0xff194DA6),
                isTop: true,
                strokeWidth: 6,
              ),
            ),
          ),
          RotationTransition(
            turns: Tween(
              begin: 0.0,
              end: 1.0,
            ).animate(_yellowArcController),
            child: CustomPaint(
              size: const Size(100, 100),
              painter: FadedArcPainter(
                baseColor: const Color(0xffE5A122),
                isTop: false,
                strokeWidth: 6,
              ),
            ),
          ),
          ClipOval(
            child: Image.asset(
              'assets/logo.png',
              width: h * 0.1,
              height: h * 0.1,
              fit: BoxFit.cover,
            ),
          ),
        ],
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
        baseColor.withAlpha(0),
        baseColor.withAlpha(255),
        baseColor.withAlpha(0),
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