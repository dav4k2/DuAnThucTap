// lib/widgets/highlight_recipes.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HighlightRecipes extends StatelessWidget {
  final double width;
  const HighlightRecipes({super.key, required this.width});

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
                'Công thức nổi bật',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              Text(
                'Xem thêm',
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: recipes.map((r) => _recipeCard(r, isDark)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _recipeCard(Map<String, String> r, bool isDark) {
    return Container(
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
          // Ảnh nền
          Image.asset(
            r['image']!,
            fit: BoxFit.cover,
          ),

          // Rating badge – giữ nguyên màu cam đẹp
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
                    r['rating']!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    ' (${r['reviews']})',
                    style: TextStyle(color: Colors.white70, fontSize: 11.sp),
                  ),
                ],
              ),
            ),
          ),

          // Tên món – TĂNG TƯƠNG PHẢN Ở DARK MODE
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 36.h,
              decoration: BoxDecoration(
                // Dark: tối hơn + trong suốt hơn → chữ trắng dễ đọc
                // Light: giữ nguyên như cũ (0.45)
                color: Colors.black.withOpacity(isDark ? 0.75 : 0.45),
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(
                    r['name']!,
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
    );
  }
}