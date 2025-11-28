import 'package:flutter/material.dart';

class CommentsSection extends StatelessWidget {
  final double width;
  const CommentsSection({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Bình luận 4",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 6),

        Text(
          "Xem tất cả bình luận",
          style: TextStyle(
            fontSize: 14,
            color: Colors.black.withOpacity(0.6),
          ),
        ),

        const SizedBox(height: 20),

        _commentItem(
          name: "Jducky",
          text: "Rất ngon và dễ làm",
          avatar: "image/Ảnh1.png",   // <= ĐÃ SỬA
        ),

        const SizedBox(height: 20),

        _commentItem(
          name: "Sơn Tùng - MVP",
          text: "Hơn 10 năm rồi... món này vẫn rất ngon!",
          avatar: "image/Ảnh2.png",   // <= ĐÃ SỬA
        ),

        const SizedBox(height: 20),

        _commentItem(
          name: "J99",
          text: "Làm hơi khác trong tui nhưng rất ngon <3",
          avatar: "image/Ảnh3.png",   // <= ĐÃ SỬA
        ),

        const SizedBox(height: 30),
      ],
    );
  }

  Widget _commentItem({
    required String name,
    required String text,
    required String avatar,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child: Image.asset(
              avatar,
              width: 35,
              height: 35,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE1E1E1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
