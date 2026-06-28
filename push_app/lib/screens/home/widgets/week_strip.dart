import 'package:flutter/material.dart';
import '../../../theme/colors.dart';
import '../../../theme/typography.dart' as t;

class WeekStrip extends StatelessWidget {
  const WeekStrip({super.key, required this.completedCount, required this.todayIndex});
  final int completedCount;
  final int todayIndex; // 0=Mon … 6=Sun

  static const _days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('This week',
                style: t.hankenGrotesk(size: 13, weight: FontWeight.w600)),
            Text('$completedCount of 7', style: t.metaStyle),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (i) {
            final done = i < completedCount;
            final isToday = i == todayIndex;
            return Column(
              children: [
                Container(
                  width: 26, height: 26,
                  decoration: BoxDecoration(
                    color: done ? accentColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(9),
                    border: isToday && !done
                        ? Border.all(color: accentColor, width: 1.5)
                        : done
                            ? null
                            : Border.all(color: trackColor, width: 1.5),
                  ),
                ),
                const SizedBox(height: 4),
                Text(_days[i],
                    style: t.hankenGrotesk(
                        size: 10, weight: FontWeight.w700, color: textMuted)),
              ],
            );
          }),
        ),
      ],
    );
  }
}
