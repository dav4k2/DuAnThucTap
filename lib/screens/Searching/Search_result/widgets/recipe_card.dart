// lib/widgets/recipe_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecipeCard extends StatelessWidget {
  final String title;
  final String time;
  final String level;
  final String author;
  final String rating;
  final String imagePath;
  final bool isNetworkImage; // Thêm cờ đánh dấu ảnh từ internet
  final VoidCallback? onTap;

  const RecipeCard({
    super.key,
    required this.title,
    required this.time,
    required this.level,
    required this.author,
    required this.rating,
    required this.imagePath,
    this.isNetworkImage = true, // Mặc định là ảnh từ mạng
    this.onTap,
  });

  // Giữ nguyên widget _frosted của bạn
  Widget _frosted({
    required BuildContext context,
    required Widget child,
    BorderRadius? radius,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isDark ? Colors.black.withOpacity(0.35) : Colors.white.withOpacity(0.75),
        borderRadius: radius ?? BorderRadius.circular(20.r),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.4) : Colors.white.withOpacity(0.9),
          width: 1.2,
        ),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          // KHỐI HÌNH ẢNH CHÍNH
          Container(
            height: 200.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.r),
              image: DecorationImage(
                // Tự động chọn AssetImage hoặc NetworkImage dựa trên biến isNetworkImage
                image: (isNetworkImage && imagePath.isNotEmpty)
                    ? NetworkImage(imagePath) as ImageProvider
                    : AssetImage(imagePath.isNotEmpty ? imagePath : 'assets/images/placeholder_recipe.jpg'),
                fit: BoxFit.cover,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
          ),

          // LỚP PHỦ NỀN CHO CHỮ (GRADIENT HOẶC OVERLAY)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 65.h, // Tăng nhẹ để text không bị sát
              decoration: BoxDecoration(
                color: isDark ? Colors.black.withOpacity(0.6) : Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.r),
                  bottom: Radius.circular(30.r),
                ),
                border: Border.all(
                  color: isDark ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.1),
                ),
              ),
            ),
          ),

          // TIÊU ĐỀ MÓN ĂN
          Positioned(
            left: 20.w,
            top: 145.h,
            right: 20.w,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // THÔNG TIN CHI TIẾT (THỜI GIAN, ĐỘ KHÓ, TÁC GIẢ)
          Positioned(
            left: 16.w,
            bottom: 10.h,
            right: 16.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14.sp, color: textColor),
                    SizedBox(width: 4.w),
                    Text(time, style: TextStyle(fontSize: 12.sp, color: textColor)),
                    SizedBox(width: 12.w),
                    Icon(Icons.whatshot, size: 14.sp, color: Colors.red),
                    SizedBox(width: 4.w),
                    Text(level, style: TextStyle(fontSize: 12.sp, color: textColor)),
                  ],
                ),
                Text(
                  'Bởi $author',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: textColor.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),

          // ĐÁNH GIÁ (STAR)
          Positioned(
            left: 12.w,
            top: 12.h,
            child: _frosted(
              context: context,
              radius: BorderRadius.circular(20.r),
              child: Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 16.sp),
                  SizedBox(width: 6.w),
                  Text(
                    rating,
                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: textColor),
                  ),
                ],
              ),
            ),
          ),

          // NÚT YÊU THÍCH
          Positioned(
            right: 16.w,
            top: 12.h,
            child: _frosted(
              context: context,
              radius: BorderRadius.circular(16.r),
              child: Icon(Icons.favorite, color: const Color(0xFFFF6B9D), size: 18.sp),
            ),
          ),
        ],
      ),
    );
  }
}