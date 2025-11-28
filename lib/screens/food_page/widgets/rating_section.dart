import 'package:flutter/material.dart';

class RatingSection extends StatelessWidget {
  final double width;
  const RatingSection({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Đánh giá",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        const Text("4.9", style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold)),
        const Text("(25 đánh giá)",
            style: TextStyle(color: Colors.grey, fontSize: 14)),
        const SizedBox(height: 20),
      ],
    );
  }
}
