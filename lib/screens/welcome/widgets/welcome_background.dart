import 'package:flutter/material.dart';

class WelcomeBackground extends StatelessWidget {
  const WelcomeBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 402,
      height: 874,
      decoration: BoxDecoration(
        color: const Color(0xFFFFB901),
        borderRadius: BorderRadius.circular(0),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            top: 464,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFEBEBEB),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
