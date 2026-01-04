import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../Crete_recipe/logic/publish_recipe.dart';
import '../../../Crete_recipe/logic/publish_service.dart';
import '../../../food_page/recipe_detail_page_screen.dart';


class RecommendedList extends StatelessWidget {
  const RecommendedList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StreamBuilder<List<PublishRecipe>>(
      stream: PublishService().getAllRecipesRealtime(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Lỗi: ${snapshot.error}"));
        }

        final recipes = snapshot.data ?? [];

        if (recipes.isEmpty) {
          return const Center(child: Text("Chưa có công thức đề xuất nào"));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: recipes.map((recipe) {
            final difficulty = recipe.difficulty ?? 'Dễ'.tr();
            String emoji = '😊';
            Color levelColor = Colors.green;

            if (difficulty.contains('Trung'.tr())) {
              emoji = '😐';
              levelColor = Colors.orange;
            } else if (difficulty.contains('Khó'.tr())) {
              emoji = '😅';
              levelColor = Colors.red;
            }

            return GestureDetector( // ✅ 1. Bọc GestureDetector
              onTap: () {
                // ✅ 2. Thực hiện chuyển trang
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailPage(recipe: recipe),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                height: 100,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        recipe.images.isNotEmpty
                            ? recipe.images.first
                            : 'https://placehold.co/400x300?text=No+Image',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(width: 100, color: Colors.grey, child: const Icon(Icons.error)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              recipe.title,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            FutureBuilder<Map<String, dynamic>?>(
                              future: PublishService().getUserInfo(recipe.authorId ?? ''),
                              builder: (context, userSnapshot) {
                                // Trong khi chờ lấy tên, ta hiện '...' hoặc 'Đang tải'
                                final userName = userSnapshot.data?['display_name'] ?? 'Người dùng';

                                return Text(
                                  "Đăng bởi: $userName".tr(),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(Icons.access_time,
                                    size: 14, color: theme.colorScheme.primary),
                                const SizedBox(width: 6),
                                Text(recipe.cookingTime ?? '30 Phút',
                                    style: theme.textTheme.bodySmall),
                                const SizedBox(width: 8),
                                const Text("|"),
                                const SizedBox(width: 8),
                                Text(
                                  "$emoji $difficulty",
                                  style: TextStyle(
                                    color: levelColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}