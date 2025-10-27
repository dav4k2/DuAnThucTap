// công thức nổi bật
import 'package:flutter/material.dart';

class HighlightRecipes extends StatelessWidget {
  final double width;
  const HighlightRecipes({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    // Danh sách công thức + ảnh
    final recipes = [
      {
        'name': 'Gà rán sốt Hàn Quốc',
        'image': 'image/my_y.png',
      },
      {
        'name': 'Mỳ Ý sốt Bolognese',
        'image': 'image/garan.png',
      },
    ];

    return Container(
      width: width,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      // bỏ margin hoặc spacing thừa để không bị khoảng vàng
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

          // Danh sách ngang các công thức
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: recipes
                  .map(
                    (r) => _recipeCard(r),
              )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _recipeCard(Map<String, String> r) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 225,
      height: 133,
      clipBehavior: Clip.hardEdge, // tránh tràn viền
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            r['image']!,
            fit: BoxFit.cover,
          ),
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
