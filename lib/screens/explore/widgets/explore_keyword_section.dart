import 'package:flutter/material.dart';

class KeywordsSection extends StatelessWidget {
  final double width;

  const KeywordsSection({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    final keywords = [
      'Healthy', 'Đồ cay', 'Ngọt',
      'Đồ ăn nhanh', 'Mỳ sốt', 'Ăn sáng',
      'Bánh', 'Súp', 'Đồ chay',
    ];

    return Container(
      width: width,
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tiêu đề
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

          // Danh sách chip
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: keywords.map((k) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F2), // Màu nền xám nhạt nhẹ
                  borderRadius: BorderRadius.circular(20), // Bo tròn mạnh như ảnh
                ),
                child: Text(
                  k,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
