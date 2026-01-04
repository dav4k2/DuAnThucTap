// lib/widgets/highlight_recipes.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Crete_recipe/logic/publish_recipe.dart';
import '../../../Crete_recipe/logic/publish_service.dart';
import '../../../food_page/recipe_detail_page_screen.dart';

class HighlightRecipes extends StatelessWidget {
  final double width;
  final PublishService _publishService = PublishService();

  HighlightRecipes({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Màu "Xem thêm" – ĐỒNG BỘ 100% với KeywordsSection & PopularUsersSection
    final seeMoreColor = isDark ? Colors.white : const Color(0xFF00695C);

    final recipes = [
      {
        'name': 'Gà rán sốt Hàn Quốc',
        'image': 'image/Rectangle30.png',
        'rating': '4.8',
        'reviews': '1k+ Đánh giá',
      },
      {
        'name': 'Mỳ Ý sốt Bolognese',
        'image': 'image/Rectangle301.png',
        'rating': '4.8',
        'reviews': '1k+ Đánh giá',
      },
    ];

    return Container(
      width: width,
      color: isDark ? const Color(0xFF121212) : Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TIÊU ĐỀ + XEM THÊM – ĐÃ ĐỒNG BỘ HOÀN TOÀN
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Công thức nổi bật'.tr(),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              Text(
                'Xem thêm'.tr(),
                style: TextStyle(
                  fontSize: 14.5.sp,
                  fontWeight: FontWeight.w600,
                  color: seeMoreColor, // giống hệt mọi nơi trong app
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // DANH SÁCH NGANG
          StreamBuilder<List<PublishRecipe>>(
            stream: _publishService.getRecommendedRecipes(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text("Không có công thức nổi bật.").tr();
              }

              final recipes = snapshot.data!;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: recipes.map((recipe) => _recipeCard(context, recipe, isDark)).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _recipeCard(BuildContext context, PublishRecipe recipe, bool isDark) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailPage(recipe: recipe),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: 12.w),
        width: 225.w,
        height: 133.h,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Ảnh từ Cloudinary hoặc ảnh mặc định
            Image.network(
              recipe.images.isNotEmpty ? recipe.images.first : '',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Image.asset(
                  'assets/images/placeholder_recipe.jpg',
                  fit: BoxFit.cover
              ),
            ),

            // Rating badge lấy từ Firestore
            Positioned(
              top: 8.h,
              left: 8.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: Colors.white, size: 15.r),
                    SizedBox(width: 4.w),
                    Text(
                      recipe.averageRating.toStringAsFixed(1), // Hiển thị trung bình cộng
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ' (${recipe.totalRatings})', // Hiển thị tổng số đánh giá
                      style: TextStyle(color: Colors.white70, fontSize: 11.sp),
                    ),
                  ],
                ),
              ),
            ),

            // Tên món
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 36.h,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(isDark ? 0.75 : 0.45),
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Text(
                      recipe.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}