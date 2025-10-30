// Widget hiển thị phần "Từ khóa nổi bật" trong trang khám phá
import 'package:flutter/material.dart';

class KeywordsSection extends StatelessWidget {
  final double width; // Chiều rộng toàn bộ vùng hiển thị (truyền từ ngoài vào)

  const KeywordsSection({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    // Danh sách các từ khóa nổi bật
    final keywords = [
      'Healthy', 'Đồ cay', 'Ngọt',
      'Đồ ăn nhanh', 'Mỳ sốt', 'Ăn sáng', 'Bánh', 'Súp', 'Đồ chay',
    ];

    return Container(
      width: width, // Căn theo chiều rộng của màn hình
      color: Colors.white, // Màu nền trắng
      padding: const EdgeInsets.all(16), // Lề trong xung quanh

      // Toàn bộ phần "Từ khóa nổi bật" được gói trong Column
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Căn trái
        children: [
          // Hàng tiêu đề: "Từ khóa nổi bật" + "Xem thêm"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Giãn đều 2 đầu
            children: const [
              Text(
                'Từ khóa nổi bật',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700, // In đậm
                ),
              ),
              Text(
                'Xem thêm',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54, // Màu chữ xám nhạt
                ),
              ),
            ],
          ),

          const SizedBox(height: 12), // Khoảng cách giữa tiêu đề và danh sách từ khóa

          // Dùng Wrap để hiển thị danh sách từ khóa dạng "chip"
          Wrap(
            spacing: 12, // Khoảng cách ngang giữa các chip
            runSpacing: 8, // Khoảng cách dọc khi xuống dòng
            children: keywords.map((k) {
              // Mỗi từ khóa được hiển thị bằng một Chip
              return Chip(
                label: Text(k), // Nội dung của chip
                backgroundColor: Colors.grey.shade200, // Màu nền chip nhạt
              );
            }).toList(), // Chuyển danh sách từ khóa thành danh sách widget
          ),
        ],
      ),
    );
  }
}
