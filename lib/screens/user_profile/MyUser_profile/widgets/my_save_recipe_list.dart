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
    return GestureDetector(
      onTap: () async {
        // Kiểm tra ID
        if (recipe.id == null || recipe.id!.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Lỗi dữ liệu: ID bài viết bị rỗng")),
          );
          return;
        }

        // Hiển thị loading
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => const Center(child: CircularProgressIndicator()),
        );

        try {
          DocumentSnapshot? docSnapshot;

          // --- CÁCH 1: Tìm trực tiếp (Ưu tiên) ---
          if (recipe.authorId != null && recipe.authorId!.isNotEmpty) {
            try {
              final directSnapshot = await FirebaseFirestore.instance
                  .collection('users')
                  .doc(recipe.authorId)
                  .collection('published_recipes')
                  .doc(recipe.id)
                  .get();

              if (directSnapshot.exists) {
                docSnapshot = directSnapshot;
              }
            } catch (e) {
              print("Tìm trực tiếp không thấy hoặc lỗi: $e");
            }
          }

          // --- CÁCH 2: Tìm dự phòng bằng collectionGroup (ĐÃ SỬA LỖI) ---
          if (docSnapshot == null || !docSnapshot.exists) {
            print("Đang tìm dự phòng cho ID: ${recipe.id}");

            final querySnapshot = await FirebaseFirestore.instance
                .collectionGroup('published_recipes')
                .where('id', isEqualTo: recipe.id) // <--- SỬA TẠI ĐÂY: Dùng field 'id' thay vì FieldPath.documentId
                .limit(1)
                .get();

            if (querySnapshot.docs.isNotEmpty) {
              docSnapshot = querySnapshot.docs.first;
            }
          }

          // --- XỬ LÝ KẾT QUẢ ---
          if (context.mounted) Navigator.pop(context); // Tắt loading

          if (docSnapshot != null && docSnapshot.exists) {
            // Convert và chuyển trang
            // Lưu ý: docSnapshot.data() trả về Object?, cần ép kiểu
            final data = docSnapshot.data() as Map<String, dynamic>;
            // Đảm bảo document có đủ dữ liệu để tránh crash
            if (data.isNotEmpty) {
              final fullRecipe = PublishRecipe.fromFirestore(docSnapshot as DocumentSnapshot<Map<String, dynamic>>);

              if (context.mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailPage(recipe: fullRecipe),
                  ),
                );
              }
            }
          } else {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Bài viết này không còn tồn tại.")),
              );
            }
          }

        } catch (e) {
          if (context.mounted) Navigator.pop(context); // Tắt loading nếu lỗi
          print("Lỗi chi tiết: $e");
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Đã xảy ra lỗi: $e")),
            );
          }
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