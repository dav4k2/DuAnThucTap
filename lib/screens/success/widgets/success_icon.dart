import 'package:flutter/material.dart';

class ResetSuccessIcon extends StatelessWidget {
  const ResetSuccessIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final iconSize = MediaQuery.of(context).size.width * 0.5;
    return Icon(
      Icons.check_rounded,
      color: const Color(0xFFFFB800),
      size: iconSize,
    );
  }
}
