import 'package:flutter/material.dart';

class RecommendedList extends StatelessWidget {
  const RecommendedList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
        'image': 'image/Rectangle302.png',
        'title': 'Phở Tái',
        'author': 'Đăng bởi Minh Anh',
        'time': '30 Phút',
        'difficulty': 'Dễ',
        'rating': '4.7',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: recommended.map((item) {
        final difficulty = item['difficulty']!;

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
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  item['image']!,
                  width: 100,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item['title']!,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['author']!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.access_time,
                              size: 14, color: theme.colorScheme.primary),
                          const SizedBox(width: 6),
                          Text(item['time']!,
                              style: theme.textTheme.bodySmall),
                          const SizedBox(width: 8),
                          const Text("|"),
                          const SizedBox(width: 8),
                          Text(
                            "$emoji ${item['difficulty']!}",
                            style: TextStyle(
                              color: levelColor,
                              fontSize: 12,
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
      }).toList(),
    );
  }
}
