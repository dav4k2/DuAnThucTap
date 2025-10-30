// Widget hiển thị mục "Người dùng phổ biến" trong trang khám phá
import 'package:flutter/material.dart';

class PopularUsersSection extends StatelessWidget {
  final double width; // Chiều rộng vùng hiển thị (truyền từ bên ngoài)

  const PopularUsersSection({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width, // Căn theo chiều rộng của màn hình
      color: Colors.white, // Màu nền trắng
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16), // Lề trong

      // Nội dung chính gồm tiêu đề + danh sách người dùng
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Căn trái nội dung
        children: [
          // Hàng tiêu đề: "Người dùng phổ biến" + "Xem thêm"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Căn đều 2 đầu
            children: const [
              Text(
                'Người dùng phổ biến',
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

          const SizedBox(height: 16), // Khoảng cách giữa tiêu đề và danh sách người dùng

          // Hàng hiển thị 3 người dùng nổi bật
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround, // Giãn đều 3 user
            children: [
              _userItem('Mr.Dean', 'image/bean.png'),
              _userItem('Donald D.', 'image/vit.png'),
              _userItem('Cristiano M.', 'image/a7.png'),
            ],
          ),
        ],
      ),
    );
  }

  // Hàm dựng từng "item" người dùng (ảnh đại diện + tên)
  static Widget _userItem(String name, String imagePath) => Column(
    children: [
      // Ảnh đại diện hình tròn
      CircleAvatar(
        radius: 40, // Kích thước avatar
        backgroundImage: AssetImage(imagePath), // Ảnh từ thư mục assets
      ),

      const SizedBox(height: 8), // Khoảng cách giữa avatar và tên

      // Tên người dùng
      Text(
        name,
        style: const TextStyle(
          fontWeight: FontWeight.w600, // In đậm nhẹ
        ),
      ),
    ],
  );
}
