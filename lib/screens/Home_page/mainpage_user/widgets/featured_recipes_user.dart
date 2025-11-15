import 'package:flutter/material.dart';

class FeaturedRecipes extends StatelessWidget {
  const FeaturedRecipes({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Công thức nổi bật',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onBackground,
                ),
              ),
              Text(
                'Xem thêm',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.hintColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
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
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        recipe['image']!,
                        width: 140,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                            const SizedBox(height: 4),
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
                                const Padding(
                                  padding:
                                  EdgeInsets.symmetric(horizontal: 6),
                                  child: Text('|',
                                      style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 11)),
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
