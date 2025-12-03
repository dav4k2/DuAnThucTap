import 'package:flutter/material.dart';

class StepDivider2 extends StatelessWidget {
  const StepDivider2({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      top: 833 - 597,
      left: 201,
      child: RotatedBox(
        quarterTurns: 1,
        child: SizedBox(
          width: 35,
          child: Divider(color: Colors.black, thickness: 1),
        ),
      ),
    );
  }
}