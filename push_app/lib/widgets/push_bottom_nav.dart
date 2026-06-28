import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/colors.dart';
import '../theme/typography.dart' as t;

class PushBottomNav extends StatelessWidget {
  const PushBottomNav({super.key});

  static const _tabs = [
    (label: 'Home',     icon: Icons.grid_view_rounded,   path: '/home'),
    (label: 'Train',    icon: Icons.circle_outlined,     path: '/home'),
    (label: 'Library',  icon: Icons.crop_square_rounded, path: '/library'),
    (label: 'Progress', icon: Icons.bar_chart_rounded,   path: '/progress'),
  ];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0x12FFFFFF), width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 9, 14, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _tabs.map((tab) {
              final active = location == tab.path;
              final color = active ? accentColor : textDisabled;
              return GestureDetector(
                onTap: () => context.go(tab.path),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(tab.icon, color: color, size: 22),
                    const SizedBox(height: 3),
                    Text(tab.label, style: t.navLabel.copyWith(color: color)),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
