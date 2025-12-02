import 'package:flutter/material.dart';

class StepDescription extends StatelessWidget {
  const StepDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      top: 215,
      left: 20,
      right: 20,
      child: Text(
        "Hành mùi rửa sạch thái nhỏ, xương bò rửa sạch rồi cho vào nồi...",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, height: 1.3),
      ),
    );
  }
}
