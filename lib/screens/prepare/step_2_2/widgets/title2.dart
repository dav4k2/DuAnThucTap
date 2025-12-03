import 'package:flutter/material.dart';

class StepTitle2 extends StatelessWidget {
  final int step;

  const StepTitle2({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 134,
      left: 0,
      right: 0,
      child: Text(
        "Bước $step",
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          fontFamily: "SF Pro Rounded",
        ),
      ),
    );
  }
}