import 'package:flutter/material.dart';

class StepHeader extends StatelessWidget {
  final double width;

  const StepHeader({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      top: 0,
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "9:41",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Icon(Icons.battery_4_bar, size: 22),
          ],
        ),
      ),
    );
  }
}
