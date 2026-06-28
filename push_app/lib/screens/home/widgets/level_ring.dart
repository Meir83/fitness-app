import 'package:flutter/material.dart';
import '../../../theme/colors.dart';
import '../../../theme/typography.dart' as t;

class LevelRing extends StatelessWidget {
  const LevelRing({super.key, required this.level, required this.label, required this.progress});
  final int level;
  final String label;
  final double progress; // 0.0–1.0

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56, height: 56,
      child: CustomPaint(
        painter: _RingPainter(progress: progress),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('L$level', style: t.spaceGrotesk(size: 16, weight: FontWeight.w700)),
              Text(label,
                  style: t.hankenGrotesk(
                      size: 7, weight: FontWeight.w800,
                      color: textMuted, letterSpacing: 7 * 0.12)),
            ],
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    const strokeW = 5.0;
    final radius = (size.width - strokeW) / 2;

    canvas.drawCircle(Offset(cx, cy), radius,
        Paint()..color = trackColor..style = PaintingStyle.stroke..strokeWidth = strokeW);

    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: radius),
      -1.5707963, // -90°
      2 * 3.14159 * progress,
      false,
      Paint()
        ..color = accentColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeW
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
}
