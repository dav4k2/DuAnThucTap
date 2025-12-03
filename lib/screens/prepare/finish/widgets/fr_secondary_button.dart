import 'package:flutter/material.dart';

class FRSecondaryButton extends StatelessWidget {
  final VoidCallback onTap;

  const FRSecondaryButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 745,
      left: 0,
      right: 0,
      child: GestureDetector(
        onTap: onTap,
        child: const Text(
          "Có lẽ để sau",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
