import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Thêm Riverpod
import 'package:fontend/screens/food_page/logic/recipe_provider.dart'; // Import provider của bạn
import 'package:fontend/screens/food_page/recipe_detail_page_screen.dart';

import '../../../Crete_recipe/logic/publish_recipe.dart';
import '../../../food_page2/recipe_detail_page_screen2.dart';
import '../logic/mainpage_user_provider.dart'; // Import trang chi tiết

// 1. Chuyển thành ConsumerWidget để dùng được ref.read
class FeaturedRecipes extends ConsumerWidget {
  const FeaturedRecipes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Theo dõi dữ liệu từ provider
    final recipesAsync = ref.watch(featuredRecipesProvider);
    final width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: Text(
            'Công thức nổi bật'.tr(),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 180,
          child: recipesAsync.when(
            data: (recipes) {
              if (recipes.isEmpty) {
                return const Center(child: Text("Chưa có công thức phù hợp"));
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  final recipe = recipes[index];

                  return GestureDetector(
                    onTap: () {
                      navigateBasedOnAuthor(context, recipe);
                    },
                    child: Container(
                      width: 150,
                      margin: const EdgeInsets.only(right: 12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.network(
                                recipe.images.isNotEmpty ? recipe.images.first : 'assets/images/placeholder_recipe.jpg',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Image.asset('assets/images/placeholder_recipe.jpg', fit: BoxFit.cover),
                              ),
                            ),
                            Positioned(
                              top: 8, left: 8, right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      recipe.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.access_time, color: Colors.white, size: 12),
                                        const SizedBox(width: 3),
                                        // Sử dụng Expanded để bao bọc phần Text có độ dài biến động
                                        Expanded(
                                          child: Text(
                                            recipe.cookingTime ?? '--',
                                            style: const TextStyle(color: Colors.white, fontSize: 11),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis, // Thêm dấu ... nếu chữ quá dài
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 4),
                                          child: Text('|', style: TextStyle(color: Colors.white70)),
                                        ),
                                        const Icon(Icons.star, color: Colors.amber, size: 12),
                                        const SizedBox(width: 3),
                                        Text(
                                          recipe.averageRating.toStringAsFixed(1),
                                          style: const TextStyle(color: Colors.white, fontSize: 10),
                                        ),
                                      ],
                                    )
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
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text("Lỗi: $err")),
          ),
        ),
      ],
    );
  }
}