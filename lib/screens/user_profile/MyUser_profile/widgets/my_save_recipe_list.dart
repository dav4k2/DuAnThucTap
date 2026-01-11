import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Crete_recipe/logic/publish_recipe.dart';
import '../../../food_page/recipe_detail_page_screen.dart';
import '../logic/my_profile_provider.dart';

// Widget hiển thị danh sách món đã lưu
class MySavedRecipesList extends ConsumerWidget {
  const MySavedRecipesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Lấy danh sách từ Provider
    final savedRecipes = ref.watch(savedRecipesProvider);

    if (savedRecipes.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: 50.h),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.favorite_border, size: 50.sp, color: Colors.grey),
              SizedBox(height: 10.h),
              Text("Chưa có món ăn nào được lưu",
                  style: TextStyle(color: Colors.grey, fontSize: 16.sp)),
            ],
          ),
        ),
      );
    }

    // Hiển thị dạng lưới
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GridView.builder(
        shrinkWrap: true, // Quan trọng để nằm trong SliverToBoxAdapter
        physics: const NeverScrollableScrollPhysics(),
        itemCount: savedRecipes.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
        ),
        itemBuilder: (context, index) {
          final recipe = savedRecipes[index];
          return _buildSavedRecipeCard(recipe, context);
        },
      ),
    );
  }

  Widget _buildSavedRecipeCard(Recipe recipe, BuildContext context) {
    return GestureDetector( // Bọc Container bằng GestureDetector
      onTap: () async {
        // Kiểm tra nếu ID bị null hoặc rỗng
        if (recipe.id == null || recipe.id!.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Không tìm thấy ID bài viết")),
          );
          return;
        }

        // 1. Hiển thị Loading trong lúc tải dữ liệu
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => const Center(child: CircularProgressIndicator()),
        );

        try {
          // 2. Lấy dữ liệu đầy đủ từ collection 'recipes' (hoặc tên collection bạn dùng để chứa bài đăng)
          final docSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(recipe.authorId)
              .collection('published_recipes') // Đảm bảo tên collection này đúng với Database của bạn
              .doc(recipe.id)
              .get();

          // Tắt loading
          if (context.mounted) Navigator.pop(context);

          if (docSnapshot.exists) {
            // 3. Convert sang PublishRecipe
            final fullRecipe = PublishRecipe.fromFirestore(docSnapshot);

            // 4. Chuyển trang
            if (context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeDetailPage(recipe: fullRecipe),
                ),
              );
            }
          } else {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Bài viết này không còn tồn tại")),
              );
              // Tùy chọn: Xóa khỏi danh sách đã lưu nếu bài gốc đã mất
              // ref.read(savedRecipesProvider.notifier).toggleSave(recipe);
            }
          }
        } catch (e) {
          // Tắt loading nếu lỗi
          if (context.mounted) Navigator.pop(context);
          print("Lỗi mở chi tiết: $e");
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: recipe.imageAsset.startsWith('http')
                ? NetworkImage(recipe.imageAsset)
                : AssetImage(recipe.imageAsset) as ImageProvider,
            fit: BoxFit.cover,
          ),
        ),
        // ... (Phần UI bên trong Container giữ nguyên như cũ)
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                recipe.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    "${recipe.rating}",
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}