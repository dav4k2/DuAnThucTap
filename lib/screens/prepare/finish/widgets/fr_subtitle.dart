import 'package:flutter/material.dart';

class FRSubtitle extends StatelessWidget {
  const FRSubtitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 188,
      left: 0,
      right: 0,
      child: Text(
        "Hãy chia sẻ thành quả của \nbạn với mọi người nhé",
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
