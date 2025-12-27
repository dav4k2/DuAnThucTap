import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fontend/screens/food_page/recipe_detail_page_screen.dart';
import '../../../Crete_recipe/logic/publish_recipe.dart';

class FeaturedRecipes extends ConsumerWidget {
  const FeaturedRecipes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

    final List<Map<String, String>> recipes = [
      {
        'id': '1',
        'image': 'image/Rectangle301.png',
        'title': 'Gà rán Công Phượng',
        'time': '45 Phút',
        'difficulty': 'Dễ',
      },
      {
        'id': '2',
        'image': 'image/Rectangle30.png',
        'title': 'Mỳ Ý sốt Bolognese',
        'time': '15 Phút',
        'difficulty': 'Dễ',
      },
      {
        'id': '3',
        'image': 'image/Rectangle302.png',
        'title': 'Phở Tái',
        'time': '60 Phút',
        'difficulty': 'Dễ',
      },
      {
        'id': '4',
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
                'Công thức nổi bật'.tr(),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                'Xem thêm'.tr(),
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
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];

              return GestureDetector(
                onTap: () {
                  final publishRecipe = PublishRecipe(
                    id: recipe['id'] ?? '',
                    title: recipe['title'] ?? '',
                    images: [recipe['image'] ?? ''],
                    cookingTime: recipe['time'],
                    difficulty: recipe['difficulty'],
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipeDetailPage(recipe: publishRecipe),
                    ),
                  );
                },
                child: Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            recipe['image']!,
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
                              mainAxisSize: MainAxisSize.min,
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
                                
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.access_time,
                                          color: Colors.white, size: 12),
                                      const SizedBox(width: 3),
                                      Text(
                                        recipe['time']!,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 11),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 4),
                                        child: Text('|', style: TextStyle(color: Colors.white70)),
                                      ),
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
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}