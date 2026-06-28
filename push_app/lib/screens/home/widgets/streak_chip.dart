import 'package:flutter/material.dart';
import '../../../theme/colors.dart';
import '../../../theme/typography.dart' as t;
import '../../../widgets/streak_dot.dart';

class StreakChip extends StatelessWidget {
  const StreakChip({super.key, required this.streak, required this.best});
  final int streak;
  final int best;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          const StreakDot(),
          const SizedBox(width: 8),
          Text('$streak-day streak',
              style: t.hankenGrotesk(size: 13, weight: FontWeight.w600)),
          const Spacer(),
          Text('Best $best', style: t.metaStyle.copyWith(color: textMuted)),
        ],
      ),
    );
  }
}
