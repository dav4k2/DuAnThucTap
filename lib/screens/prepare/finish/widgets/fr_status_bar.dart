import 'package:flutter/material.dart';

class FRStatusBar extends StatelessWidget {
  const FRStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      left: 16,
      child: Icon(Icons.arrow_back, size: 28),
    );
  }
}
