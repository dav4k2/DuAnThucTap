// lib/screens/search/widgets/search_results_tabs.dart
import 'package:cloud_firestore/cloud_firestore.dart'; // [CẦN THÊM]
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
  final String query;

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
        // ================= TAB CÔNG THỨC (GIỮ NGUYÊN) =================
        StreamBuilder<List<PublishRecipe>>(
          stream: service.getAllRecipesRealtime(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

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
                      rating: '4.5',
                      imagePath: recipe.images.isNotEmpty ? recipe.images.first : '',
                      isNetworkImage: true,
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

        // ================= TAB ĐẦU BẾP (ĐÃ SỬA LẠI) =================
        // FIX: Truy vấn trực tiếp vào collection 'users' thay vì lấy từ 'recipes'
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return _buildEmptyState("Không tìm thấy đầu bếp nào");
            }

            // Lọc danh sách user theo tên
            final users = snapshot.data!.docs.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              // Kiểm tra tất cả các trường có thể chứa tên
              final String name = data['display_name'] ?? data['name'] ?? data['fullname'] ?? '';
              return name.toLowerCase().contains(lowercaseQuery);
            }).toList();

            if (users.isEmpty) return _buildEmptyState("Không tìm thấy người dùng '$query'");

            return ListView.separated(
              padding: EdgeInsets.all(20.w),
              itemCount: users.length,
              separatorBuilder: (_, __) => SizedBox(height: 15.h), // Khoảng cách giữa các item
              itemBuilder: (context, index) {
                final userDoc = users[index];
                final userData = userDoc.data() as Map<String, dynamic>;
                final String userId = userDoc.id;

                // Lấy thông tin hiển thị
                final String authorName = userData['display_name'] ?? userData['name'] ?? userData['fullname'] ?? 'Người dùng';
                final String avatarUrl = userData['avatar_url'] ?? userData['photo_url'] ?? userData['image'] ?? '';

                return FutureBuilder<int>(
                  // Vẫn dùng hàm này để lấy số lượng công thức nếu cần
                  future: service.getRecipeCount(userId),
                  builder: (context, countSnapshot) {
                    return ChefCard(
                      chefId: userId,
                      name: authorName,
                      avatarPath: avatarUrl,
                      isNetworkImage: true,
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

  Widget _buildEmptyState(String msg) => Center(
      child: Text(
        msg,
        style: TextStyle(fontSize: 16.sp, color: Colors.grey),
      )
  );
}