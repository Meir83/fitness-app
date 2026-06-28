import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/workout.dart';
import '../../providers/session_provider.dart';
import '../../providers/user_provider.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart' as t;
import 'widgets/hero_card.dart';
import 'widgets/level_ring.dart';
import 'widgets/streak_chip.dart';
import 'widgets/week_strip.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final now = DateTime.now();
    final dayNames = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    final monthNames = ['JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC'];
    final dateLabel = '${dayNames[now.weekday - 1]} ${now.day} ${monthNames[now.month - 1]}';

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(dateLabel, style: t.overlineStyle),
                        const SizedBox(height: 4),
                        Text("Let's go, ${user.name.split(' ').first}.",
                            style: t.greeting),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.push('/profile'),
                    child: LevelRing(
                      level: user.levelNumber,
                      label: user.level.name.toUpperCase(),
                      progress: user.xp / user.xpToNext,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              StreakChip(streak: user.streak, best: user.bestStreak),
              const SizedBox(height: 14),
              HeroCard(
                workout: Workout.foundationsPush,
                onStart: () {
                  ref.read(sessionProvider.notifier)
                      .startWorkout(Workout.foundationsPush);
                  context.push('/workout/active');
                },
              ),
              const SizedBox(height: 14),
              WeekStrip(completedCount: 4, todayIndex: now.weekday - 1),
            ],
          ),
        ),
      ),
    );
  }
}
