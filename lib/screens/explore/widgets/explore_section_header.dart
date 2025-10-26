import 'package:flutter/material.dart';

class ExploreSectionHeader extends StatelessWidget {
  final String title;
  const ExploreSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const Text(
          'Xem thêm',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
