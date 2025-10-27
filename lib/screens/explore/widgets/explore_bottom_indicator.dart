import 'package:flutter/material.dart';

class BottomIndicator extends StatelessWidget {
  const BottomIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      width: 140,
      height: 5,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }
}
