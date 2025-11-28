import 'package:flutter/material.dart';

class DescriptionSection extends StatelessWidget {
  final double width;
  const DescriptionSection({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text:
              "Phở là một món ăn truyền thống của Việt Nam, được xem là một trong những món ăn...",
              style: TextStyle(
                  color: Colors.black.withOpacity(0.6),
                  fontSize: 14,
                  height: 1.6),
            ),
            const TextSpan(
              text: " Xem thêm",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
