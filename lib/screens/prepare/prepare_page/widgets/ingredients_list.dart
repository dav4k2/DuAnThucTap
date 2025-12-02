import 'package:flutter/material.dart';

class IngredientsList extends StatelessWidget {
  const IngredientsList({super.key});

  List<Map<String, dynamic>> get items => [
    {"text": "2 quả ớt (không bắt buộc)", "top": 206.0},
    {"text": "1 gói gia vị phở", "top": 270.0},
    {"text": "200gr thịt bò", "top": 334.0},
    {"text": "200gr xương bò", "top": 398.0},
    {"text": "500gr bánh phở", "top": 462.0},
    {"text": "1 nắm hành lá", "top": 526.0},
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        for (var item in items)
          Positioned(
            left: 41,
            top: item["top"],
            child: SizedBox(
              width: 330,
              child: Text(
                item["text"],
                style: const TextStyle(
                  fontSize: 18,
                  height: 1.22,
                ),
              ),
            ),
          ),

        for (var item in items)
          Positioned(
            left: 16,
            top: item["top"] + 11,
            child: Container(
              width: 13,
              height: 13,
              decoration: const BoxDecoration(
                color: Color(0xFFFFB901),
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}
