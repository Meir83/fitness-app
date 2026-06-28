import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/colors.dart';
import '../theme/typography.dart' as t;

class PushPrimaryButton extends StatelessWidget {
  const PushPrimaryButton({
    super.key,
    required this.label,
    required this.onTap,
    this.showArrow = false,
  });
  final String label;
  final VoidCallback onTap;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: accentColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: t.buttonLabel),
            if (showArrow) ...[
              const SizedBox(width: 6),
              const Icon(Icons.arrow_forward, color: onAccent, size: 16)
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .moveX(begin: 0, end: 3, duration: 1600.ms, curve: Curves.easeInOut),
            ],
          ],
        ),
      ),
    );
  }
}

class PushGhostButton extends StatelessWidget {
  const PushGhostButton({super.key, required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0x20FFFFFF)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(label, style: t.buttonLabel.copyWith(color: textColor)),
        ),
      ),
    );
  }
}
