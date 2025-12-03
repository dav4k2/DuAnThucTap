import 'package:flutter/material.dart';

class StepTitle3 extends StatelessWidget {
  final int step;

  const StepTitle3({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 140,
      left: 0,
      right: 0,
      child: Text(
        "Bước $step",
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}