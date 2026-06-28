import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/library_provider.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart' as t;
import '../../widgets/push_progress_bar.dart';
import '../../widgets/striped_placeholder.dart';

const _filters = ['Skills', 'Push', 'Pull', 'Core'];

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(libraryFilterProvider);
    final workouts = ref.watch(workoutsProvider);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Library', style: t.screenTitle),
              const SizedBox(height: 13),
              // Search field
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Row(children: [
                  const Icon(Icons.search, color: Color(0xFF7E837A), size: 18),
                  const SizedBox(width: 8),
                  Text('Search moves & workouts',
                      style: t.bodyStyle.copyWith(color: textMuted)),
                ]),
              ),
              const SizedBox(height: 13),
              // Filter chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _filters.map((f) {
                    final active = f == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () =>
                            ref.read(libraryFilterProvider.notifier).state = f,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: active ? accentColor : surfaceColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(f,
                              style: t.hankenGrotesk(
                                  size: 13,
                                  weight: FontWeight.w700,
                                  color: active ? onAccent : text2Color)),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              Text('Skill paths',
                  style: t.hankenGrotesk(size: 14, weight: FontWeight.w700)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                      child: _SkillPathCard(
                          title: 'First Pull-up', progress: 0.40)),
                  const SizedBox(width: 10),
                  Expanded(
                      child: _SkillPathCard(
                          title: 'Handstand', progress: 0.15)),
                ],
              ),
              const SizedBox(height: 20),
              Text('Workouts',
                  style: t.hankenGrotesk(size: 14, weight: FontWeight.w700)),
              const SizedBox(height: 10),
              ...workouts.map((w) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _WorkoutRow(
                      title: w.title,
                      meta: '${w.durationMinutes} min · Beginner',
                      difficulty: 1,
                    ),
                  )),
              const _WorkoutRow(
                title: 'Core Crusher',
                meta: '22 min · Beginner',
                difficulty: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkillPathCard extends StatelessWidget {
  const _SkillPathCard({required this.title, required this.progress});
  final String title;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StripedPlaceholder(height: 64),
          const SizedBox(height: 10),
          Text(title,
              style: t.hankenGrotesk(size: 13, weight: FontWeight.w700)),
          const SizedBox(height: 6),
          PushProgressBar(value: progress),
          const SizedBox(height: 4),
          Text('${(progress * 100).round()}% there', style: t.metaStyle),
        ],
      ),
    );
  }
}

class _WorkoutRow extends StatelessWidget {
  const _WorkoutRow(
      {required this.title, required this.meta, required this.difficulty});
  final String title;
  final String meta;
  final int difficulty; // 1–3

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const StripedPlaceholder(height: 46, width: 46),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                        t.hankenGrotesk(size: 13, weight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(meta, style: t.metaStyle),
              ],
            ),
          ),
          Row(
            children: List.generate(
              3,
              (i) => Padding(
                padding: const EdgeInsets.only(left: 3),
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: i < difficulty ? accentColor : trackColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
