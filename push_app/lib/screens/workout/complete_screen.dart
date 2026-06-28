import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/session_provider.dart';
import '../../providers/user_provider.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart' as t;
import '../../widgets/push_button.dart';

class CompleteScreen extends ConsumerStatefulWidget {
  const CompleteScreen({super.key});
  @override
  ConsumerState<CompleteScreen> createState() => _CompleteScreenState();
}

class _CompleteScreenState extends ConsumerState<CompleteScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ringCtrl;
  bool _awarded = false;

  @override
  void initState() {
    super.initState();
    _ringCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1100));
    _ringCtrl.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) => _award());
  }

  void _award() {
    if (_awarded) return;
    _awarded = true;
    final session = ref.read(sessionProvider);
    if (session.workout != null) {
      ref.read(userProvider.notifier).addXp(session.workout!.xpReward);
      ref.read(userProvider.notifier).incrementStreak();
      ref.read(userProvider.notifier).incrementWorkouts();
    }
  }

  @override
  void dispose() {
    _ringCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    final user = ref.watch(userProvider);
    final workout = session.workout;
    final elapsedSec = session.elapsedSeconds;
    final totalReps = session.completedSets.fold(0, (a, b) => a + b);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: Column(
            children: [
              // Animated badge ring
              AnimatedBuilder(
                animation: _ringCtrl,
                builder: (_, __) => SizedBox(
                  width: 104, height: 104,
                  child: CustomPaint(
                    painter: _BadgeRingPainter(progress: _ringCtrl.value),
                    child: Center(
                      child: Container(
                        width: 54, height: 54,
                        decoration: const BoxDecoration(
                          gradient: accentGradient,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(Icons.check,
                              color: onAccent, size: 28),
                        ),
                      )
                          .animate(delay: 500.ms)
                          .scale(
                              begin: const Offset(0.4, 0.4),
                              end: const Offset(1, 1),
                              duration: 500.ms,
                              curve: Curves.elasticOut)
                          .fadeIn(duration: 300.ms),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('Workout complete!',
                  style: t.screenTitle, textAlign: TextAlign.center),
              const SizedBox(height: 6),
              Text(
                'Nice work, ${user.name.split(' ').first}. ${workout?.title ?? ''} done.',
                style: t.bodyStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Summary triplet
              Row(children: [
                _SummaryTile(label: 'Duration', value: _fmtDur(elapsedSec)),
                const SizedBox(width: 8),
                _SummaryTile(label: 'Total reps', value: '$totalReps'),
                const SizedBox(width: 8),
                _SummaryTile(
                  label: 'XP',
                  value: '+${workout?.xpReward ?? 0}',
                  valueColor: accentColor,
                ),
              ]),
              const SizedBox(height: 14),
              // Streak banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: accentGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: onAccent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Streak extended!',
                              style: t.hankenGrotesk(
                                  size: 11,
                                  weight: FontWeight.w700,
                                  color: onAccentDim)),
                          const SizedBox(height: 2),
                          Text(
                            '${user.streak - 1} → ${user.streak} days',
                            style: t.hankenGrotesk(
                                size: 13,
                                weight: FontWeight.w700,
                                color: onAccent),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text('${user.streak}',
                        style: t.bigNumber.copyWith(color: onAccent)),
                  ],
                ),
              ),
              const Spacer(),
              PushPrimaryButton(
                label: 'Finish',
                onTap: () {
                  ref.read(sessionProvider.notifier).discard();
                  context.go('/home');
                },
              ),
              const SizedBox(height: 10),
              PushGhostButton(
                label: 'Share progress',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _fmtDur(int sec) {
    final m = sec ~/ 60;
    final s = sec % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile(
      {required this.label, required this.value, this.valueColor});
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(13)),
          child: Column(children: [
            Text(value, style: t.statValue.copyWith(color: valueColor)),
            const SizedBox(height: 2),
            Text(label, style: t.metaStyle),
          ]),
        ),
      );
}

class _BadgeRingPainter extends CustomPainter {
  _BadgeRingPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const radius = 48.0;
    const stroke = 6.0;

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
  bool shouldRepaint(_BadgeRingPainter old) => old.progress != progress;
}
