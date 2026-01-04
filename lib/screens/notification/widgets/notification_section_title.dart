import 'package:flutter/material.dart';

class NotificationSectionTitle extends StatelessWidget {
  final String title;

  const NotificationSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Màu chữ chính (tiêu đề section)
    final titleColor = isDark ? Colors.white : Colors.black87;

    // Màu chữ phụ ("Đánh dấu là đã đọc")
    final secondaryColor = isDark ? Colors.grey[400]! : Colors.grey;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: titleColor,
            ),
          ),
          Text(
            'Đánh dấu là đã đọc',
            style: TextStyle(
              fontSize: 13,
              color: secondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}