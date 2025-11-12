import 'package:flutter/material.dart';

class RecommendedList extends StatelessWidget {
  const RecommendedList({super.key});

  @override
  Widget build(BuildContext context) {
    // Danh sách món ăn đề xuất
    final List<Map<String, String>> recommended = [
      {
        'image': 'image/Rectangle301.png',
        'title': 'Gà rán Công Phượng',
        'author': 'Đăng bởi Kong Fuong',
        'time': '45 Phút',
        'difficulty': 'Dễ',
        'rating': '4.8',
      },
      {
        'image': 'image/Rectangle30.png',
        'title': 'Mỳ Ý bò bằm',
        'author': 'Đăng bởi Sơn',
        'time': '20 Phút',
        'difficulty': 'Trung bình',
        'rating': '4.8',
      },
      {
        'image': 'image/Rectangle302.png',
        'title': 'Phở Tái',
        'author': 'Đăng bởi Minh Anh',
        'time': '30 Phút',
        'difficulty': 'Dễ',
        'rating': '4.7',
      },
      {
        'image': 'image/Rectangle32.png',
        'title': 'Phở bò Huế',
        'author': 'Đăng bởi Thái Công',
        'time': '30 Phút',
        'difficulty': 'Khó',
        'rating': '4.6',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: recommended.map(
            (item) {
          final imagePath = item['image'] ?? '';
          final title = item['title'] ?? '';
          final author = item['author'] ?? '';
          final time = item['time'] ?? '';
          final difficulty = item['difficulty'] ?? '';
          final rating = item['rating'] ?? '0.0';

          // 🧠 Chọn emoji + màu dựa theo độ khó
          String emoji = '';
          Color levelColor = Colors.green;
          if (difficulty.toLowerCase().contains('dễ')) {
            emoji = '😊';
            levelColor = Colors.green;
          } else if (difficulty.toLowerCase().contains('trung')) {
            emoji = '😐';
            levelColor = Colors.orange;
          } else {
            emoji = '😅';
            levelColor = Colors.red;
          }

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            height: 90,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                // Ảnh món ăn + badge rating
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Stack(
                    children: [
                      Image.asset(
                        imagePath,
                        width: 100,
                        height: 90,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 100,
                            height: 90,
                            color: Colors.grey.shade200,
                            alignment: Alignment.center,
                            child: const Icon(Icons.image_not_supported),
                          );
                        },
                      ),
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star, size: 12, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text(
                                rating,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Nội dung thông tin món ăn
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          author,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Thời gian + độ khó (có emoji)
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 14, color: Colors.green),
                            const SizedBox(width: 6),
                            Text(
                              time,
                              style: const TextStyle(fontSize: 12, color: Colors.black87),
                            ),
                            const SizedBox(width: 8),
                            const Text("|", style: TextStyle(color: Colors.grey)),
                            const SizedBox(width: 8),
                            Text(
                              "$difficulty $emoji",
                              style: TextStyle(
                                fontSize: 12,
                                color: levelColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ).toList(),
    );
  }
}
