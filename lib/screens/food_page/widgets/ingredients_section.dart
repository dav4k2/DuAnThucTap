import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class IngredientsSection extends StatelessWidget {
  final double width;
  const IngredientsSection({super.key, required this.width});

  final ingredients = const [
    "2 quả ớt (không bắt buộc)",
    "1 gói gia vị phở",
    "200gr xương bò",
    "500gr bánh phở",
    "200gr thịt bò",
    "1 nắm hành lá",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text("Nguyên liệu:".tr(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 8),
        ...ingredients.map((item) => Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 8),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                    color: Color(0xFFFFB901), shape: BoxShape.circle),
              ),
              const SizedBox(width: 10),
              Text(item, style: const TextStyle(fontSize: 16)),
            ],
          ),
        )),
      ],
    );
  }
}
