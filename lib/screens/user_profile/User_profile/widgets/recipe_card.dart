// lib/widgets/recipe_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fontend/Service/recipe_model.dart';

import '../../../Crete_recipe/logic/publish_recipe.dart'; //

class RecipeCard extends StatelessWidget {
  final PublishRecipe recipe; // Đổi từ Recipe sang RecipeModel
  final VoidCallback onTap;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.onTap,
  });

  // Widget nền mờ nhẹ
  Widget _frostedContainer({
    required BuildContext context,
    required Widget child,
    double? width,
    double? height,
    EdgeInsets? padding,
    BorderRadius? borderRadius,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.15)
            : Colors.white.withOpacity(0.75),
        borderRadius: borderRadius ?? BorderRadius.circular(20.r),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.3)
              : Colors.white.withOpacity(0.9),
          width: 1.2,
        ),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.textTheme.bodyMedium!.color!;
    final iconColor = textColor.withOpacity(0.85);

    // Xử lý ảnh: Lấy ảnh đầu tiên từ mảng images, nếu trống dùng ảnh mặc định
    final String imageUrl = (recipe.images != null && recipe.images!.isNotEmpty)
        ? recipe.images!.first
        : 'https://via.placeholder.com/360x178';

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          // === ẢNH MÓN ĂN (Sử dụng Image.network thay vì AssetImage) ===
          Container(
            width: 360.w,
            height: 178.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              image: DecorationImage(
                image: NetworkImage(imageUrl), // Dùng ảnh từ Cloudinary/Firebase
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black45 : Colors.black12,
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          ),

          // === THANH NỀN MỜ TIÊU ĐỀ ===
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 55.h,
            child: _frostedContainer(
              context: context,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.r)),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title ?? 'Không tên', //
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 12.sp, color: iconColor),
                        SizedBox(width: 4.w),
                        Text(recipe.cookingTime ?? '--', style: _info(textColor)), //
                        SizedBox(width: 12.w),
                        Icon(Icons.whatshot, size: 12.sp, color: Colors.orange),
                        SizedBox(width: 4.w),
                        Text(recipe.difficulty ?? '--', style: _info(textColor)), //
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // === RATING (Dữ liệu thật từ averageRating) ===
          Positioned(
            left: 12.w,
            top: 12.h,
            child: _frostedContainer(
              context: context,
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 14.sp),
                  SizedBox(width: 4.w),
                  Text(
                    '${recipe.averageRating?.toStringAsFixed(1) ?? "0.0"} (${recipe.totalRatings ?? 0})', //
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _info(Color color) => TextStyle(
    color: color.withOpacity(0.8),
    fontSize: 11.sp,
    fontWeight: FontWeight.w400,
  );
}