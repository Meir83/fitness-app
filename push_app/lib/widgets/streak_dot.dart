import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/colors.dart';

class StreakDot extends StatelessWidget {
  const StreakDot({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8, height: 8,
      decoration: const BoxDecoration(
        color: accentColor,
        shape: BoxShape.circle,
      ),
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .boxShadow(
          begin: const BoxShadow(color: Color(0x80C9F24A), blurRadius: 7),
          end:   const BoxShadow(color: Color(0x80C9F24A), blurRadius: 16),
          duration: 2000.ms,
          curve: Curves.easeInOut,
        );
  }
}
