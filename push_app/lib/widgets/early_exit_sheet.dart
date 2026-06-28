import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/session_provider.dart';
import '../providers/user_provider.dart';
import '../theme/typography.dart' as t;
import 'push_button.dart';

class EarlyExitSheet extends ConsumerWidget {
  const EarlyExitSheet({super.key});

  static Future<void> show(BuildContext context) => showModalBottomSheet(
        context: context,
        backgroundColor: const Color(0xFF181B16),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (_) => const EarlyExitSheet(),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final setsCount = session.completedSets.length;
    final partialXp = (setsCount * 10).clamp(0, 100);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('End workout early?', style: t.screenTitle.copyWith(fontSize: 20)),
          const SizedBox(height: 8),
          Text(
            'You\'ve completed $setsCount sets so far.',
            style: t.bodyStyle,
          ),
          const SizedBox(height: 24),
          PushPrimaryButton(
            label: 'Save progress (+$partialXp XP)',
            onTap: () {
              ref.read(userProvider.notifier).addXp(partialXp);
              ref.read(sessionProvider.notifier).savePartial();
              context.go('/home');
            },
          ),
          const SizedBox(height: 10),
          PushGhostButton(
            label: 'Discard',
            onTap: () {
              ref.read(sessionProvider.notifier).discard();
              context.go('/home');
            },
          ),
        ],
      ),
    );
  }
}
