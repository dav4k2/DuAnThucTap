import 'package:flutter/material.dart';

class FeaturedRecipes extends StatelessWidget {
  const FeaturedRecipes({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // Danh sách công thức nổi bật
    final List<Map<String, String>> recipes = [
      {
        'image': 'image/Rectangle301.png',
        'title': 'Gà rán Công Phượng',
        'time': '45 Phút',
        'difficulty': 'Dễ',
      },
      {
        'image': 'image/Rectangle30.png',
        'title': 'Mỳ Ý sốt Bolognese',
        'time': '15 Phút',
        'difficulty': 'Dễ',
      },
      {
        'image': 'image/Rectangle302.png',
        'title': 'Phở Tái',
        'time': '60 Phút',
        'difficulty': 'Dễ',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔥 PHẦN “CÔNG THỨC NỔI BẬT”
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Công thức nổi bật',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              Text(
                'Xem thêm',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // 🧩 DANH SÁCH NGANG
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return Container(
                width: 140,
                margin: EdgeInsets.only(
                  left: index == 0 ? width * 0.05 : 10,
                  right: index == recipes.length - 1 ? width * 0.05 : 0,
                ),
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    // Ảnh món ăn
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        recipe['image']!,
                        width: 140,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Lớp phủ + thông tin món ăn
                    Container(
                      width: 140,
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(12)),
                        color: Colors.black.withOpacity(0.5),
                      ),
                      padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            recipe['title']!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.access_time,
                                      color: Colors.white, size: 12),
                                  const SizedBox(width: 3),
                                  Text(
                                    recipe['time']!,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 11),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.emoji_emotions,
                                      color: Colors.white, size: 12),
                                  const SizedBox(width: 3),
                                  Text(
                                    recipe['difficulty']!,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 11),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
