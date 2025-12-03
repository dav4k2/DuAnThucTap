import 'package:flutter/material.dart';

class StepHeader3 extends StatelessWidget {
  final double width;

  const StepHeader3({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      top: 0,
      child: SafeArea(
        child: Container(
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back, size: 28),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
