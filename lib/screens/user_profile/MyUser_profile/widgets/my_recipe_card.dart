import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// 1. Thay đổi import sang model mới
import '../../../Crete_recipe/logic/publish_recipe.dart';

class MyRecipeCard extends StatelessWidget {
  // 2. Cập nhật kiểu dữ liệu thành PublishRecipe
  final PublishRecipe recipe;
  final VoidCallback? onTap;

  const MyRecipeCard({
    super.key,
    required this.recipe,
    this.onTap,
  });

  // Widget nền mờ (Giữ nguyên logic giao diện của bạn)
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
        color: isDark ? Colors.white.withOpacity(0.15) : Colors.white.withOpacity(0.75),
        borderRadius: borderRadius ?? BorderRadius.circular(20.r),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.3) : Colors.white.withOpacity(0.9),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
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
    final shadowColor = isDark ? Colors.black.withOpacity(0.6) : const Color(0x3F000000);

    // 3. Lấy ảnh đầu tiên từ mảng images (Sử dụng dữ liệu từ Cloudinary URL)
    final String imageUrl = recipe.images.isNotEmpty
        ? recipe.images.first
        : 'https://placehold.co/400x300?text=No+Image';

    // 4. Thời gian đăng (Sử dụng getter timeAgo từ model PublishRecipe)
    final String timePublished = recipe.timeAgo;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          // --- ẢNH MÓN ĂN ---
          Container(
            width: 360.w,
            height: 178.h,
            decoration: ShapeDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              shadows: [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          ),

          // --- THANH NỀN MỜ ---
          Positioned(
            top: 135.h,
            left: 0.w,
            right: 10.w,
            height: 43.h,
            child: _frostedContainer(
              context: context,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(40.r),
                bottom: Radius.circular(33.r),
              ),
              child: const SizedBox(),
            ),
          ),

          // --- TIÊU ĐỀ ---
          Positioned(
            left: 20.w,
            top: 140.h,
            right: 16.w,
            child: Text(
              recipe.title,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: textColor,
                height: 1.3,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // --- THÔNG TIN DƯỚI (Thời gian nấu, Độ khó) ---
          Positioned(
            left: 16.w,
            top: 158.h,
            child: Row(
              children: [
                Icon(Icons.access_time, size: 13.sp, color: iconColor),
                SizedBox(width: 5.w),
                // Hiển thị thời gian nấu (ví dụ: '15-30 phút')
                Text(recipe.cookingTime ?? 'N/A', style: _info(textColor)),
              ],
            ),
          ),
          Positioned(
            left: 110.w,
            top: 158.h,
            child: Row(
              children: [
                Icon(Icons.whatshot, size: 13.sp, color: Colors.red.withOpacity(0.9)),
                SizedBox(width: 5.w),
                // Hiển thị độ khó (ví dụ: 'Dễ')
                Text(recipe.difficulty ?? 'Trung bình', style: _info(textColor)),
              ],
            ),
          ),

          // --- THỜI GIAN ĐÃ ĐĂNG (Góc trên trái) ---
          Positioned(
            left: 12.w,
            top: 12.h,
            child: _frostedContainer(
              context: context,
              width: 100.w,
              height: 26.h,
              borderRadius: BorderRadius.circular(20.r),
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today, color: Colors.orange, size: 12.sp),
                  SizedBox(width: 5.w),
                  Text(
                    timePublished,
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

          // --- NÚT TÙY CHỌN (Góc trên phải) ---
          Positioned(
            right: 22.w,
            top: 12.h,
            child: _frostedContainer(
              context: context,
              width: 28.w,
              height: 28.w,
              borderRadius: BorderRadius.circular(14.r),
              child: Center(
                child: Icon(
                  Icons.more_horiz,
                  color: textColor,
                  size: 17.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _info(Color color) => TextStyle(
    color: color.withOpacity(0.85),
    fontSize: 11.sp,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );
}