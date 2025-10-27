// danh sách người dùng nổi bật
import 'package:flutter/material.dart';

class PopularUsersSection extends StatelessWidget {
  final double width;
  const PopularUsersSection({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Người dùng phổ biến',
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
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
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

  static Widget _userItem(String name, String imagePath) => Column(
    children: [
      CircleAvatar(
        radius: 40,
        backgroundImage: AssetImage(imagePath),
      ),
      const SizedBox(height: 8),
      Text(
        name,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ],
  );
}
