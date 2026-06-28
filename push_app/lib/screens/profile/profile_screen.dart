import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user.dart';
import '../../providers/theme_provider.dart';
import '../../providers/user_provider.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart' as t;
import '../../widgets/push_progress_bar.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 36, height: 36,
                      decoration: const BoxDecoration(
                          color: surfaceColor, shape: BoxShape.circle),
                      child: const Icon(Icons.arrow_back,
                          color: textColor, size: 18),
                    ),
                  ),
                  const Spacer(),
                  Text('Profile',
                      style: t.hankenGrotesk(
                          size: 15, weight: FontWeight.w700)),
                  const Spacer(),
                  Container(
                    width: 36, height: 36,
                    decoration: const BoxDecoration(
                        color: surfaceColor, shape: BoxShape.circle),
                    child: const Icon(Icons.settings_outlined,
                        color: textColor, size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Identity
              Row(
                children: [
                  Container(
                    width: 62, height: 62,
                    decoration: const BoxDecoration(
                      gradient: accentGradient,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        user.name[0],
                        style: t.spaceGrotesk(
                            size: 26,
                            weight: FontWeight.w700,
                            color: onAccent),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name,
                          style: t.spaceGrotesk(
                              size: 19, weight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      Text(
                        'Level ${user.levelNumber} · ${_capitalize(user.level.name)}',
                        style: t.hankenGrotesk(
                            size: 13,
                            weight: FontWeight.w600,
                            color: accentColor),
                      ),
                      Text('Joined Mar 2026', style: t.metaStyle),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // XP card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Level ${user.levelNumber + 1} · Mover',
                            style: t.hankenGrotesk(
                                size: 13, weight: FontWeight.w700)),
                        Text('${user.xp} / ${user.xpToNext} XP',
                            style: t.metaStyle.copyWith(color: accentColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    PushProgressBar(
                        value: user.xp / user.xpToNext, height: 5),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              // Stat triplet
              Row(
                children: [
                  _StatTile(label: 'Streak', value: '${user.streak}'),
                  const SizedBox(width: 8),
                  _StatTile(label: 'Workouts', value: '${user.totalWorkouts}'),
                  const SizedBox(width: 8),
                  _StatTile(
                      label: 'Badges',
                      value: '${user.earnedBadges.length}'),
                ],
              ),
              const SizedBox(height: 14),
              // Badges
              Text('Badges',
                  style: t.hankenGrotesk(size: 13, weight: FontWeight.w700)),
              const SizedBox(height: 10),
              _BadgesRow(earned: user.earnedBadges),
              const SizedBox(height: 14),
              // Settings list
              Container(
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _SettingsRow(label: 'My goal', value: user.selectedGoal),
                    _RowDivider(),
                    const _SettingsRow(label: 'Reminders', value: '9:00 AM'),
                    _RowDivider(),
                    // Appearance toggle
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 13),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text('Appearance',
                                style: t.hankenGrotesk(
                                    size: 13, weight: FontWeight.w600)),
                          ),
                          GestureDetector(
                            onTap: () =>
                                ref.read(themeProvider.notifier).toggle(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: trackColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                themeMode == ThemeMode.dark
                                    ? '🌙 Dark'
                                    : '☀️ Light',
                                style: t.hankenGrotesk(
                                    size: 12,
                                    weight: FontWeight.w700,
                                    color: text2Color),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _RowDivider(),
                    const _SettingsRow(
                        label: 'Account & settings', value: ''),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(13)),
          child: Column(
            children: [
              Text(value, style: t.statValue),
              const SizedBox(height: 2),
              Text(label, style: t.metaStyle),
            ],
          ),
        ),
      );
}

class _BadgesRow extends StatelessWidget {
  const _BadgesRow({required this.earned});
  final List<PushBadge> earned;

  static const _allBadges = [
    (badge: PushBadge.sevenDay,    label: '7-day'),
    (badge: PushBadge.hundredReps, label: '100 reps'),
    (badge: PushBadge.earlyBird,   label: 'Early bird'),
    (badge: PushBadge.pullUp,      label: 'Pull-up'),
    (badge: PushBadge.thirtyDay,   label: '30-day'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: _allBadges.map((b) {
        final isEarned = earned.contains(b.badge);
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Column(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  gradient: isEarned ? accentGradient : null,
                  shape: BoxShape.circle,
                  border: isEarned
                      ? null
                      : Border.all(
                          color: const Color(0xFF3A4034),
                          width: 1.5,
                        ),
                ),
              ),
              const SizedBox(height: 4),
              Text(b.label,
                  style: t.metaStyle.copyWith(fontSize: 9)),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        child: Row(
          children: [
            Expanded(
                child: Text(label,
                    style: t.hankenGrotesk(
                        size: 13, weight: FontWeight.w600))),
            if (value.isNotEmpty) Text(value, style: t.metaStyle),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right,
                color: Color(0xFF5A5F54), size: 16),
          ],
        ),
      );
}

class _RowDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        height: 1,
        color: borderColor,
        margin: const EdgeInsets.symmetric(horizontal: 14),
      );
}
