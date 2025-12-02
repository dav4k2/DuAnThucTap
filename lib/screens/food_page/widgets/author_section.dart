import 'package:flutter/material.dart';

class AuthorSection extends StatelessWidget {
  final double width;
  const AuthorSection({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // BỎ màu xám FAFAFA → Dùng màu trắng
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar
          ClipOval(
            child: Image.asset(
              "image/goldel.png",
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 12),

          // Text bên trái
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Golden Ramday",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "Thành viên",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Đã đăng vào 3 tháng 8, 2025",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // BUTTON phóng to
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14), // to hơn
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: const [
                Text(
                  "Đã theo dõi",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,            // chữ to hơn
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.person_add_alt_1,
                  color: Colors.white,
                  size: 18,                  // icon to hơn
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
