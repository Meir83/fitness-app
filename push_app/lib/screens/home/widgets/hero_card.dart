import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../models/workout.dart';
import '../../../theme/colors.dart';
import '../../../theme/typography.dart' as t;

class HeroCard extends StatelessWidget {
  const HeroCard({super.key, required this.workout, required this.onStart});
  final Workout workout;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: accentColor,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('TODAY · PUSH DAY',
              style: t.overlineStyle.copyWith(color: onAccentDim)),
          const SizedBox(height: 6),
          Text(workout.title,
              style: t.spaceGrotesk(size: 23, weight: FontWeight.w700, color: onAccent)),
          const SizedBox(height: 4),
          Text(
            '${workout.exercises.length} moves · ${workout.durationMinutes} min · Beginner',
            style: t.hankenGrotesk(size: 12, weight: FontWeight.w600, color: onAccentDim),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: onStart,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
              decoration: BoxDecoration(
                color: onAccent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Start workout',
                      style: t.buttonLabel.copyWith(color: accentColor)),
                  const SizedBox(width: 6),
                  const Icon(Icons.arrow_forward, color: accentColor, size: 15)
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .moveX(begin: 0, end: 3, duration: 1600.ms, curve: Curves.easeInOut),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
