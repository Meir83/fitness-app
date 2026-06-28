import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/session_provider.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart' as t;
import '../../widgets/early_exit_sheet.dart';
import '../../widgets/push_button.dart';
import '../../widgets/push_progress_bar.dart';
import '../../widgets/striped_placeholder.dart';

class ActiveWorkoutScreen extends ConsumerWidget {
  const ActiveWorkoutScreen({super.key});

  String _fmt(int sec) {
    final m = sec ~/ 60;
    final s = sec % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    if (session.workout == null) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => context.go('/home'));
      return const SizedBox.shrink();
    }

    final workout = session.workout!;
    final exercise = workout.exercises[session.moveIndex];
    final totalMoves = workout.exercises.length;
    final progress = (session.moveIndex + 1) / totalMoves;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row
              Row(
                children: [
                  GestureDetector(
                    onTap: () => EarlyExitSheet.show(context),
                    child: Container(
                      width: 36, height: 36,
                      decoration: const BoxDecoration(
                          color: surfaceColor, shape: BoxShape.circle),
                      child: const Icon(Icons.close,
                          color: textColor, size: 18),
                    ),
                  ),
                  const Spacer(),
                  Text(workout.title.toUpperCase(), style: t.overlineStyle),
                  const Spacer(),
                  Text(_fmt(session.elapsedSeconds),
                      style: t.hankenGrotesk(
                          size: 13,
                          weight: FontWeight.w700,
                          color: accentColor)),
                ],
              ),
              const SizedBox(height: 14),
              PushProgressBar(value: progress),
              const SizedBox(height: 6),
              Text('Move ${session.moveIndex + 1} of $totalMoves',
                  style: t.metaStyle),
              const SizedBox(height: 14),
              StripedPlaceholder(
                height: 188,
                label: '${exercise.name.toUpperCase()} · DEMO',
              ),
              const SizedBox(height: 14),
              Text(exercise.name,
                  style: t.spaceGrotesk(size: 27, weight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(
                'Set ${session.setIndex + 1} of ${exercise.sets} · ${exercise.muscleGroup}',
                style: t.bodyStyle,
              ),
              const SizedBox(height: 16),
              // Big rep number
              Center(
                child: Column(children: [
                  Text('${exercise.reps}', style: t.heroNumber)
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .scale(
                          begin: const Offset(1, 1),
                          end: const Offset(1.045, 1.045),
                          duration: 2600.ms,
                          curve: Curves.easeInOut),
                  Text('reps', style: t.bodyStyle),
                ]),
              ),
              const SizedBox(height: 16),
              // Set tracker
              Row(
                children: List.generate(exercise.sets, (i) {
                  final done = i < session.setIndex;
                  final current = i == session.setIndex;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: i < exercise.sets - 1 ? 6 : 0),
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: current ? accentColor : surfaceColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: done
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('${exercise.reps}',
                                        style: t.hankenGrotesk(
                                            size: 13,
                                            weight: FontWeight.w700)),
                                    const SizedBox(width: 2),
                                    const Icon(Icons.check,
                                        size: 12,
                                        color: accentColor),
                                  ],
                                )
                              : Text(
                                  current ? 'now' : '—',
                                  style: t.hankenGrotesk(
                                      size: 13,
                                      weight: FontWeight.w700,
                                      color: current
                                          ? onAccent
                                          : textMuted),
                                ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const Spacer(),
              Row(children: [
                GestureDetector(
                  onTap: () => context.go('/workout/rest'),
                  child: Container(
                    width: 54, height: 54,
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('60s',
                            style: t.hankenGrotesk(
                                size: 11,
                                weight: FontWeight.w700,
                                color: accentColor)),
                        Text('rest',
                            style: t.metaStyle.copyWith(fontSize: 9)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: PushPrimaryButton(
                    label: 'Done — log set',
                    onTap: () {
                      ref
                          .read(sessionProvider.notifier)
                          .logSet(exercise.reps);
                      final status = ref.read(sessionProvider).status;
                      if (status == SessionStatus.complete) {
                        context.go('/workout/complete');
                      } else {
                        context.go('/workout/rest');
                      }
                    },
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
