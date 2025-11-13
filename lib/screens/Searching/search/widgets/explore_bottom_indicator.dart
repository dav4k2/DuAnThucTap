import 'package:flutter/material.dart';

class BottomIndicator extends StatelessWidget {
  const BottomIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      width: 140,
      height: 5,
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.7) : Colors.black,
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }
}