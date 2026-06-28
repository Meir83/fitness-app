import 'package:flutter/material.dart';
import '../theme/colors.dart';

class PushProgressBar extends StatelessWidget {
  const PushProgressBar({super.key, required this.value, this.height = 3});
  final double value; // 0.0–1.0
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: LinearProgressIndicator(
        value: value,
        minHeight: height,
        backgroundColor: trackColor,
        valueColor: const AlwaysStoppedAnimation<Color>(accentColor),
      ),
    );
  }
}
