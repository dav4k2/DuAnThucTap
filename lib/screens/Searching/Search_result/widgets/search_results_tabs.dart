// lib/screens/search/widgets/search_results_tabs.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fontend/screens/food_page/recipe_detail_page_screen.dart';
import '../../../Crete_recipe/logic/publish_recipe.dart';
import '../../../Crete_recipe/logic/publish_service.dart';
import '../../../user_profile/User_profile/recipe_detail_screen.dart';
import 'recipe_card.dart';
import 'chef_card.dart';

class SearchResultsTabs extends StatelessWidget {
  final TabController tabController;
  final String query; // Thêm biến query

  const SearchResultsTabs({
    super.key,
    required this.tabController,
    required this.query
  });

  @override
  Widget build(BuildContext context) {
    final service = PublishService();
    final lowercaseQuery = query.toLowerCase().trim();

    return TabBarView(
      controller: tabController,
      children: [
        // ================= TAB CÔNG THỨC =================
        StreamBuilder<List<PublishRecipe>>(
          stream: service.getAllRecipesRealtime(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // Lọc công thức theo tên hoặc nguyên liệu
            final recipes = snapshot.data?.where((r) =>
            r.title.toLowerCase().contains(lowercaseQuery) ||
                r.ingredients.any((i) => i.toLowerCase().contains(lowercaseQuery))
            ).toList() ?? [];

            if (recipes.isEmpty) return _buildEmptyState("Không tìm thấy công thức nào");

            return ListView.separated(
              padding: EdgeInsets.all(20.w),
              itemCount: recipes.length,
              separatorBuilder: (_, __) => SizedBox(height: 20.h),
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return FutureBuilder<Map<String, dynamic>?>(
                  future: service.getUserInfo(recipe.authorId ?? ''),
                  builder: (context, userSnap) {
                    final authorName = userSnap.data?['display_name'] ?? 'Đang tải...';
                    return RecipeCard(
                      title: recipe.title,
                      time: recipe.cookingTime ?? '30 phút',
                      level: recipe.difficulty ?? 'Dễ',
                      author: authorName,
                      rating: '4.5', // Có thể bổ sung field này vào model sau
                      imagePath: recipe.images.isNotEmpty ? recipe.images.first : '',
                      isNetworkImage: true, // Cần cập nhật RecipeCard để hỗ trợ NetworkImage
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RecipeDetailPage(recipe: recipe),
                            ),
                          );
                        },
                    );
                  },
                );
              },
            );
          },
        ),

        // ================= TAB ĐẦU BẾP =================
        // Logic tìm kiếm đầu bếp dựa trên những người đã từng đăng bài
        StreamBuilder<List<PublishRecipe>>(
          stream: service.getAllRecipesRealtime(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

            final authorIds = snapshot.data!
                .map((r) => r.authorId)
                .whereType<String>()
                .toSet()
                .toList();

            return ListView.builder(
              padding: EdgeInsets.all(20.w),
              itemCount: authorIds.length,
              itemBuilder: (context, index) {
                final authorId = authorIds[index];

                return FutureBuilder<Map<String, dynamic>?>(
                  future: service.getUserInfo(authorId),
                  builder: (context, userSnap) {
                    if (userSnap.connectionState == ConnectionState.waiting) return const SizedBox();
                    if (!userSnap.hasData) return const SizedBox();

                    final userData = userSnap.data!;
                    final String authorName = userData['display_name'] ?? 'Người dùng';

                    // FIX 1: Lấy đúng key 'avatar_url' từ Cloudinary/Firestore
                    final String avatarUrl = userData['avatar_url'] ?? userData['photo_url'] ?? '';

                    // Lọc theo query
                    if (!authorName.toLowerCase().contains(lowercaseQuery)) {
                      return const SizedBox.shrink();
                    }

                    return FutureBuilder<int>(
                      future: service.getRecipeCount(authorId),
                      builder: (context, countSnapshot) {
                        return ChefCard(
                          chefId: authorId,
                          name: authorName,
                          recipeCount: "${countSnapshot.data ?? 0} công thức",
                          // FIX 2: Sử dụng biến avatarUrl đã định nghĩa ở trên, bỏ 'chef.'
                          avatarPath: avatarUrl,
                          isNetworkImage: true,
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        )
      ],
    );
  }

  Widget _buildEmptyState(String msg) => Center(child: Text(msg));
}