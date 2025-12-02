import 'package:flutter/material.dart';

class StepDescription1 extends StatelessWidget {
  const StepDescription1({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      top: 212,
      left: 22,
      right: 22,
      child: Text(
        'Hành mùi rửa sạch thái nhỏ, xương bò rửa sạch rồi cho vào nồi...',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          height: 1.38,
          color: Colors.black87,
        ),
      ),
    );
  }
}
