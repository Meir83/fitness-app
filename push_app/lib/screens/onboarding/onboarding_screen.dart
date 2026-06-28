import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/user_provider.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart' as t;
import '../../widgets/push_button.dart';

const _goals = [
  (label: 'Build real strength',  icon: Icons.crop_square_rounded),
  (label: 'My first pull-up',     icon: Icons.circle_outlined),
  (label: 'Get lean & athletic',  icon: Icons.diamond_outlined),
  (label: 'Build a daily habit',  icon: Icons.crop_square_outlined),
];

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});
  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  String _selected = 'Build real strength';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: PUSH wordmark + Skip
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('PUSH',
                      style: t.spaceGrotesk(
                          size: 18, weight: FontWeight.w700,
                          color: accentColor, letterSpacing: 18 * 0.16)),
                  GestureDetector(
                    onTap: () => context.go('/home'),
                    child: Text('Skip', style: t.metaStyle),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Step indicator
              Row(children: [
                Expanded(flex: 2, child: Container(height: 3, decoration: BoxDecoration(color: accentColor, borderRadius: BorderRadius.circular(3)))),
                const SizedBox(width: 4),
                Expanded(child: Container(height: 3, decoration: BoxDecoration(color: trackColor, borderRadius: BorderRadius.circular(3)))),
                const SizedBox(width: 4),
                Expanded(child: Container(height: 3, decoration: BoxDecoration(color: trackColor, borderRadius: BorderRadius.circular(3)))),
              ]),
              const SizedBox(height: 24),
              Text("What's your goal?", style: t.screenTitle),
              const SizedBox(height: 8),
              Text('We\'ll shape your first plan around it.', style: t.bodyStyle),
              const SizedBox(height: 20),
              // Goal cards
              ...List.generate(_goals.length, (i) {
                final goal = _goals[i];
                final selected = _selected == goal.label;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 11),
                  child: GestureDetector(
                    onTap: () => setState(() => _selected = goal.label),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: selected ? const Color(0x17C9F24A) : surfaceColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: selected ? accentColor : borderColor,
                          width: selected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 34, height: 34,
                            decoration: BoxDecoration(
                              color: trackColor,
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: Icon(goal.icon, color: textMuted, size: 16),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(goal.label,
                                style: t.hankenGrotesk(
                                    size: 14,
                                    weight: FontWeight.w600,
                                    color: selected ? textColor : text2Color)),
                          ),
                          if (selected)
                            Container(
                              width: 20, height: 20,
                              decoration: const BoxDecoration(
                                  color: accentColor, shape: BoxShape.circle),
                              child: const Icon(Icons.check, color: onAccent, size: 13),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const Spacer(),
              PushPrimaryButton(
                label: 'Continue',
                showArrow: true,
                onTap: () {
                  ref.read(userProvider.notifier).selectGoal(_selected);
                  context.go('/home');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
