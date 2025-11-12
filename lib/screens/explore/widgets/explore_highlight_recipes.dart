import 'package:flutter/material.dart';

class HighlightRecipes extends StatelessWidget {
  final double width; // Chiều rộng màn hình, truyền từ bên ngoài

  const HighlightRecipes({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    // Danh sách các công thức nổi bật (tên món + đường dẫn ảnh + điểm + lượt đánh giá)
    final recipes = [
      {
        'name': 'Gà rán sốt Hàn Quốc',
        'image': 'image/Rectangle30.png',
        'rating': '4.8',
        'reviews': '1k+ Đánh giá',
      },
      {
        'name': 'Mỳ Ý sốt Bolognese',
        'image': 'image/Rectangle301.png',
        'rating': '4.8',
        'reviews': '1k+ Đánh giá',
      },
    ];

    return Container(
      width: width,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tiêu đề
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Công thức nổi bật',
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

          const SizedBox(height: 12),

          // Danh sách ngang
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: recipes.map((r) => _recipeCard(r)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // Hàm dựng từng card món
  Widget _recipeCard(Map<String, String> r) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 225,
      height: 133,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Ảnh nền
          Image.asset(
            r['image']!,
            fit: BoxFit.cover,
          ),

          // Góc trên trái: đánh giá ⭐ + số lượt đánh giá
          Positioned(
            top: 6,
            left: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.85),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.white,
                    size: 14,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    '${r['rating']} ',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '(${r['reviews']})',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Góc dưới: tên món
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 30,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.45),
              ),
              child: Center(
                child: Text(
                  r['name']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
