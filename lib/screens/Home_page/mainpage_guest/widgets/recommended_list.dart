import 'package:flutter/material.dart';

class RecommendedList extends StatelessWidget {
  const RecommendedList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
        'title': 'Phở Tái (copy)',
        'author': 'Đăng bởi Minh Anh',
        'time': '30 Phút',
        'difficulty': 'Khó',
        'rating': '4.9',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: recommended.map((item) {
        // Xác định màu + emoji theo độ khó
        final difficulty = item['difficulty']!.toLowerCase();
        String emoji;
        Color levelColor;

        if (difficulty.contains('dễ')) {
          emoji = '😊';
          levelColor = Colors.green;
        } else if (difficulty.contains('trung')) {
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
            // Đây là chìa khóa: dùng surfaceContainerHighest → luôn có độ nâng rõ ràng
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(15)),
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
                      // Tiêu đề
                      Text(
                        item['title']!,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface, // luôn tương phản tốt
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // Tác giả
                      Text(
                        item['author']!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Dòng thời gian + độ khó
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 16, color: colorScheme.primary),
                          const SizedBox(width: 4),
                          Text(
                            item['time']!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text('•', style: TextStyle(color: colorScheme.outline)),
                          const SizedBox(width: 12),
                          Text(
                            '$emoji ${item['difficulty']!}',
                            style: TextStyle(
                              color: levelColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Optional: thêm rating nhỏ ở góc phải
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 18),
                    Text(
                      item['rating']!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}