import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/session_provider.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart' as t;
import '../../widgets/early_exit_sheet.dart';
import '../../widgets/striped_placeholder.dart';

class RestScreen extends ConsumerWidget {
  const RestScreen({super.key});

  String _fmt(int sec) =>
      '${sec ~/ 60}:${(sec % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    if (session.workout == null) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => context.go('/home'));
      return const SizedBox.shrink();
    }

    // Auto-advance when timer hits 0
    if (session.status == SessionStatus.active) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/workout/active');
      });
    }

    final workout = session.workout!;
    const totalRest = 60.0;
    final progress = session.restRemainingSeconds / totalRest;
    final nextExercise = session.moveIndex < workout.exercises.length
        ? workout.exercises[session.moveIndex]
        : null;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 32),
          child: Column(
            children: [
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
                  const SizedBox(width: 36),
                ],
              ),
              const SizedBox(height: 8),
              Text('REST',
                  style: t.overlineStyle.copyWith(
                      color: accentColor, letterSpacing: 10 * 0.2)),
              const SizedBox(height: 32),
              // Countdown ring
              SizedBox(
                width: 200, height: 200,
                child: CustomPaint(
                  painter:
                      _RestRingPainter(progress: progress.clamp(0.0, 1.0)),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_fmt(session.restRemainingSeconds),
                            style: t.timerStyle),
                        Text('until next set', style: t.metaStyle),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Row(children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => ref
                        .read(sessionProvider.notifier)
                        .addRestTime(15),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor),
                      ),
                      child: Center(
                        child: Text('+15s',
                            style: t.hankenGrotesk(
                                size: 14, weight: FontWeight.w700)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      ref.read(sessionProvider.notifier).skipRest();
                      context.go('/workout/active');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor),
                      ),
                      child: Center(
                        child: Text('Skip',
                            style: t.hankenGrotesk(
                                size: 14, weight: FontWeight.w700)),
                      ),
                    ),
                  ),
                ),
              ]),
              const Spacer(),
              if (nextExercise != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const StripedPlaceholder(height: 46, width: 46),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('UP NEXT',
                              style: t.overlineStyle
                                  .copyWith(color: accentColor)),
                          const SizedBox(height: 2),
                          Text(
                            '${nextExercise.name} · ${nextExercise.reps} reps',
                            style: t.hankenGrotesk(
                                size: 13, weight: FontWeight.w600),
                          ),
                        ],
                      ),
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

class _RestRingPainter extends CustomPainter {
  _RestRingPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const radius = 90.0;
    const stroke = 10.0;

    canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = trackColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      Paint()
        ..color = accentColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_RestRingPainter old) => old.progress != progress;
}
