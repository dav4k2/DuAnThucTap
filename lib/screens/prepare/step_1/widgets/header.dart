import 'package:flutter/material.dart';

class StepHeader1 extends StatelessWidget {
  const StepHeader1({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      left: 16,
      right: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            "9:41",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          Icon(Icons.battery_4_bar, size: 22),
        ],
      ),
    );
  }
}
