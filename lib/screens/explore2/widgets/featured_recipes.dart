import 'package:flutter/material.dart';

class FeaturedRecipes extends StatelessWidget {
  const FeaturedRecipes({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // Danh sách công thức nổi bật
    final List<Map<String, String>> recipes = [
      {
        'image': 'image/Rectangle30.png',
        'title': 'Mỳ Ý sốt Bolognese',
        'time': '15 Phút',
        'difficulty': 'Dễ',
      },
      {
        'image': 'image/Rectangle301.png',
        'title': 'Gà rán Công Phượng',
        'time': '45 Phút',
        'difficulty': 'Trung bình',
      },
      {
        'image': 'image/Rectangle302.png',
        'title': 'Phở tái',
        'time': '60 Phút',
        'difficulty': 'Dễ',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tiêu đề phần
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: 8),
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

        // Danh sách công thức
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return Container(
                width: 150,
                margin: EdgeInsets.only(
                  left: index == 0 ? width * 0.05 : 10,
                  right: index == recipes.length - 1 ? width * 0.05 : 0,
                ),
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    // Ảnh nền
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        recipe['image']!,
                        width: 150,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),

                    // Lớp mờ + thông tin
                    Container(
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(15)),
                        color: Colors.black.withOpacity(0.4),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            recipe['title']!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                recipe['time']!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                ),
                              ),
                              Text(
                                recipe['difficulty']!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                ),
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
