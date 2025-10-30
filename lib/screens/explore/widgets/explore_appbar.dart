// Widget thanh tiêu đề + ô tìm kiếm trong trang "Khám phá"
import 'package:flutter/material.dart';

class ExploreAppBar extends StatelessWidget {
  // Nhận chiều rộng của màn hình (truyền từ bên ngoài)
  final double width;

  const ExploreAppBar({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width, // Đặt chiều rộng theo kích thước màn hình
      padding: const EdgeInsets.all(16), // Khoảng cách lề trong
      decoration: const BoxDecoration(
        color: Color(0xFFFFB901), // Màu nền vàng cam
        boxShadow: [
          BoxShadow(
            color: Color(0x3F000000), // Màu bóng mờ
            blurRadius: 4, // Độ mờ của bóng
            offset: Offset(0, 4), // Hướng đổ bóng xuống dưới
          )
        ],
      ),

      // Bên trong chứa tiêu đề + ô tìm kiếm
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Căn giữa ngang
        children: [
          // Tiêu đề "Khám phá"
          const Text(
            'Khám phá',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 10), // Khoảng cách giữa tiêu đề và ô tìm kiếm

          // Ô tìm kiếm
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white, // Màu nền trắng
              borderRadius: BorderRadius.circular(50), // Bo tròn góc
              border: Border.all(color: Colors.black.withValues(alpha: 0.4)), // Viền mờ
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16), // Lề hai bên
            child: Row(
              children: [
                // Icon tìm kiếm
                const Icon(Icons.search, color: Colors.black54),

                const SizedBox(width: 8), // Khoảng cách giữa icon và text

                // Text gợi ý tìm kiếm
                Expanded(
                  child: Text(
                    'Nhập tên món ăn hoặc nguyên liệu...',
                    style: TextStyle(
                      color: Colors.black.withValues(alpha: 0.5), // Màu chữ mờ
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
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
