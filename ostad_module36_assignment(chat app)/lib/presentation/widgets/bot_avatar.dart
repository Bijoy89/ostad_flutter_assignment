import 'package:flutter/material.dart';

class BotAvatar extends StatelessWidget {
  final double size;

  const BotAvatar({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF4ECBA0),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4ECBA0).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: _RobotFaceIcon(size: size),
      ),
    );
  }
}

class _RobotFaceIcon extends StatelessWidget {
  final double size;
  const _RobotFaceIcon({required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size * 0.6, size * 0.6),
      painter: _RobotPainter(),
    );
  }
}

class _RobotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;

    // Head (rounded rect)
    final headRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.1, h * 0.15, w * 0.8, h * 0.65),
      Radius.circular(w * 0.15),
    );
    canvas.drawRRect(headRect, strokePaint);

    // Antenna
    canvas.drawLine(
      Offset(w * 0.5, h * 0.15),
      Offset(w * 0.5, h * 0.0),
      strokePaint,
    );
    canvas.drawCircle(Offset(w * 0.5, 0), w * 0.07, paint);

    // Eyes
    canvas.drawCircle(Offset(w * 0.32, h * 0.42), w * 0.09, paint);
    canvas.drawCircle(Offset(w * 0.68, h * 0.42), w * 0.09, paint);

    // Mouth (smile line)
    final smilePath = Path()
      ..moveTo(w * 0.30, h * 0.65)
      ..quadraticBezierTo(w * 0.5, h * 0.78, w * 0.70, h * 0.65);
    canvas.drawPath(smilePath, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}