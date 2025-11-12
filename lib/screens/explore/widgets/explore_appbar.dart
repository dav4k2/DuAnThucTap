import 'package:flutter/material.dart';

class ExploreAppBar extends StatelessWidget {
  final double width;

  const ExploreAppBar({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFFFFB901),
        boxShadow: [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),

      // Bên trong chứa tiêu đề + ô tìm kiếm
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Khám phá',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 10),

          // 🔍 Ô tìm kiếm có thể nhập được
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Colors.black.withValues(alpha: 0.4)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.black54),
                const SizedBox(width: 8),

                // 🧠 Thay Text bằng TextField
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Nhập tên món ăn hoặc nguyên liệu...',
                      hintStyle: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      border: InputBorder.none, // Xóa viền mặc định
                      isCollapsed: true, // Giúp text nằm đúng giữa chiều cao
                    ),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    textInputAction: TextInputAction.search, // Enter = tìm kiếm
                    onSubmitted: (value) {
                      debugPrint('Người dùng nhập: $value');
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
