import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/progress_provider.dart';
import '../../providers/user_provider.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart' as t;
import '../../widgets/push_progress_bar.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  static const _dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  static const _restDayIndices = {3};

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final progress = ref.watch(progressProvider);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Progress', style: t.screenTitle),
              const SizedBox(height: 13),
              // Streak hero
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: accentGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${user.streak}',
                            style: t.bigNumber.copyWith(color: onAccent)),
                        Text('DAY STREAK',
                            style: t.overlineStyle
                                .copyWith(color: onAccentDim)),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Best ${user.bestStreak}',
                            style: t.hankenGrotesk(
                                size: 12,
                                weight: FontWeight.w700,
                                color: onAccentDim)),
                        const SizedBox(height: 4),
                        Row(
                          children: List.generate(
                            4,
                            (i) => Padding(
                              padding: const EdgeInsets.only(left: 3),
                              child: Container(
                                width: 4, height: 16,
                                decoration: BoxDecoration(
                                  color: i < 3
                                      ? onAccent
                                      : const Color(0x60000000),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 13),
              // Weekly bar chart
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Reps this week',
                        style: t.hankenGrotesk(
                            size: 13, weight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 78,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(7, (i) {
                          final isRest = _restDayIndices.contains(i);
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 2),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.end,
                                      children: [
                                        FractionallySizedBox(
                                          heightFactor:
                                              progress.weeklyReps[i],
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: isRest
                                                  ? trackMuted
                                                  : accentColor,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      3),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: List.generate(
                        7,
                        (i) => Expanded(
                          child: Center(
                            child: Text(_dayLabels[i],
                                style: t.metaStyle
                                    .copyWith(fontSize: 9)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 13),
              // Stat triplet
              Row(children: [
                _StatTile(
                    label: 'Total reps',
                    value: '${progress.totalReps ~/ 1000}k'),
                const SizedBox(width: 8),
                _StatTile(
                    label: 'Workouts',
                    value: '${user.totalWorkouts}'),
                const SizedBox(width: 8),
                _StatTile(
                    label: 'Trained',
                    value: '${progress.trainedHours.round()}h'),
              ]),
              const SizedBox(height: 13),
              // Personal bests
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Personal bests',
                        style: t.hankenGrotesk(
                            size: 13, weight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    ...progress.personalBests.map((pb) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(pb.exercise,
                                      style: t.hankenGrotesk(
                                          size: 12,
                                          weight: FontWeight.w600)),
                                  Text(
                                    '${pb.value} ${pb.unit}'.trim(),
                                    style: t.hankenGrotesk(
                                        size: 12,
                                        weight: FontWeight.w700,
                                        color: accentColor),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              PushProgressBar(
                                  value: pb.percentage, height: 4),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(13)),
          child: Column(children: [
            Text(value, style: t.statValue),
            const SizedBox(height: 2),
            Text(label, style: t.metaStyle),
          ]),
        ),
      );
}
