import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../Service/recipe_model.dart';


class MyRecipeCard extends StatelessWidget {
  final RecipeModel recipe; // Đổi kiểu dữ liệu ở đây
  final VoidCallback? onTap;

  const MyRecipeCard({
    super.key,
    required this.recipe,
    this.onTap,
  });

  // Widget nền mờ (Giữ nguyên logic giao diện đẹp của bạn)
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

    // Lấy ảnh đầu tiên, nếu không có thì dùng ảnh placeholder
    final String imageUrl = recipe.images.isNotEmpty
        ? recipe.images.first
        : 'https://placehold.co/400x300?text=No+Image';

    // Số lượt thích (Thay cho rating giả)
    final String likesText = recipe.likesCount > 0
        ? '${recipe.likesCount} Yêu thích'
        : 'Mới đăng';

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          // 1. ẢNH MÓN ĂN (Sửa thành NetworkImage)
          Container(
            width: 360.w,
            height: 178.h,
            decoration: ShapeDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl), // <-- SỬA Ở ĐÂY
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {
                  // Xử lý khi lỗi ảnh (tránh crash app)
                },
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

          // 2. THANH DƯỚI – NỀN MỜ
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

          // 3. TIÊU ĐỀ
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
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // 4. THÔNG TIN DƯỚI (Thời gian, Độ khó, Tác giả)
          Positioned(
            left: 16.w,
            top: 158.h,
            child: Row(
              children: [
                Icon(Icons.access_time, size: 13.sp, color: iconColor),
                SizedBox(width: 5.w),
                Text(recipe.cookingTime, style: _info(textColor)), // Lấy từ Model
              ],
            ),
          ),
          Positioned(
            left: 100.w,
            top: 158.h,
            child: Row(
              children: [
                Icon(Icons.whatshot, size: 13.sp, color: Colors.red.withOpacity(0.9)),
                SizedBox(width: 5.w),
                Text(recipe.difficulty, style: _info(textColor)), // Lấy từ Model
              ],
            ),
          ),
          // Nếu bạn muốn hiện tên tác giả, cần lấy từ User data,
          // nhưng ở màn hình "Của tôi" thì không cần thiết lắm nên mình ẩn tạm hoặc để text cố định
          /*
          Positioned(
            right: 16.w,
            top: 158.h,
            child: Row(
              children: [
                Icon(Icons.person_outline, size: 13.sp, color: iconColor),
                SizedBox(width: 5.w),
                Text('Đăng bởi TÔI', style: _info(textColor)),
              ],
            ),
          ),
          */

          // 5. RATING / LIKE – NỀN MỜ (Góc trên trái)
          Positioned(
            left: 12.w,
            top: 12.h,
            child: _frostedContainer(
              context: context,
              width: 140.w,
              height: 26.h,
              borderRadius: BorderRadius.circular(20.r),
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite, color: Colors.redAccent, size: 15.sp),
                  SizedBox(width: 5.w),
                  Text(
                    likesText,
                    style: TextStyle(
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 6. NÚT TIM (Góc trên phải) - Chỉ để trang trí hoặc chờ tính năng Edit
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
                  Icons.more_horiz, // Đổi thành nút option để sau này làm Edit/Delete
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
    fontSize: 11.5.sp,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );
}