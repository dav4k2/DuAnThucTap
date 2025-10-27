// từ khóa nổi bật
import 'package:flutter/material.dart';

class KeywordsSection extends StatelessWidget {
  final double width;
  const KeywordsSection({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    final keywords = [
      'Healthy', 'Đồ cay', 'Ngọt',
      'Đồ ăn nhanh', 'Mỳ sốt', 'Ăn sáng', 'Bánh', 'Súp', 'Đồ chay',
    ];

    return Container(
      width: width,
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Từ khóa nổi bật',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Xem thêm',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: keywords.map((k) {
              return Chip(
                label: Text(k),
                backgroundColor: Colors.grey.shade200,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
