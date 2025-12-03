import 'package:flutter/material.dart';

class FRTitle extends StatelessWidget {
  const FRTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 93,
      left: 0,
      right: 0,
      child: Text(
        "Bạn đã hoàn thành \ncông thức",
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
