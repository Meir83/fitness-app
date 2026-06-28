import 'package:flutter/material.dart';
import '../theme/colors.dart';

class StripedPlaceholder extends StatelessWidget {
  const StripedPlaceholder({super.key, required this.height, this.label, this.width});
  final double height;
  final double? width;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(11),
      ),
      child: CustomPaint(
        painter: _StripePainter(),
        child: label != null
            ? Center(
                child: Text(label!,
                    style: const TextStyle(
                        color: Color(0xFF3A4326),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1)),
              )
            : null,
      ),
    );
  }
}

class _StripePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1C2018)
      ..strokeWidth = 8;
    for (double x = -size.height; x < size.width + size.height; x += 16) {
      canvas.drawLine(
        Offset(x, size.height),
        Offset(x + size.height, 0),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
