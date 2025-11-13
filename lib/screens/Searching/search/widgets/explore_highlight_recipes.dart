// lib/widgets/highlight_recipes.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HighlightRecipes extends StatelessWidget {
  final double width;

  const HighlightRecipes({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
      color: isDarkMode ? const Color(0xFF121212) : Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TIÊU ĐỀ – GIỮ NGUYÊN, CHỈ ĐỔI MÀU CHỮ KHI DARK MODE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Công thức nổi bật',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              Text(
                'Xem thêm',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // DANH SÁCH NGANG – GIỮ NGUYÊN 100%
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: recipes.map((r) => _recipeCard(r, isDarkMode)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _recipeCard(Map<String, String> r, bool isDarkMode) {
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
          // ẢNH NỀN – GIỮ NGUYÊN
          Image.asset(
            r['image']!,
            fit: BoxFit.cover,
          ),

          // RATING BADGE – GIỮ NGUYÊN MÀU CAM TRONG SUỐT
          Positioned(
            top: 6.h,
            left: 6.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.85),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, color: Colors.white, size: 14.r),
                  SizedBox(width: 3.w),
                  Text(
                    '${r['rating']} ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '(${r['reviews']})',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // TÊN MÓN – GIỮ NGUYÊN CONTAINER ĐEN 0.45 + CHỮ TRẮNG
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 30.h,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(isDarkMode ? 0.65 : 0.45), // tối hơn chút ở dark mode cho dễ đọc
              ),
              child: Center(
                child: Text(
                  r['name']!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}