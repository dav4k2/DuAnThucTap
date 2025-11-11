// lib/widgets/recipe_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../logic/chef_provider.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;

  const RecipeCard({super.key, required this.recipe, required this.onTap});

  // Widget nền mờ nhẹ (thay thế Liquid Glass)
  Widget _frostedContainer({
    required Widget child,
    double? width,
    double? height,
    EdgeInsets? padding,
    BorderRadius? borderRadius,
  }) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.75), // Mờ nhẹ, không dùng blur
        borderRadius: borderRadius ?? BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withOpacity(0.9), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
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
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          // === ẢNH MÓN ĂN ===
          Container(
            width: 360.w,
            height: 178.h,
            decoration: ShapeDecoration(
              image: DecorationImage(
                image: AssetImage(recipe.imageAsset),
                fit: BoxFit.cover,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
              shadows: const [
                BoxShadow(color: Color(0x3F000000), blurRadius: 6, offset: Offset(0, 4))
              ],
            ),
          ),

          // === THANH DƯỚI – NỀN MỜ NHẸ ===
          Positioned(
            top: 135.h,
            left: 2.w,
            right: 2.w,
            bottom : 2.w,
            child: _frostedContainer(
              height: 43.h,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.r),
                topRight: Radius.circular(40.r),
                bottomLeft: Radius.circular(40.r),
                bottomRight: Radius.circular(40.r),
              ),
              child: const SizedBox(),
            ),
          ),

          // === TIÊU ĐỀ ===
          Positioned(
            left: 20.w,
            top: 138.h,
            right: 16.w,
            child: Text(
              recipe.title,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // === THÔNG TIN DƯỚI ===
          Positioned(
            left: 16.w,
            top: 158.h,
            child: Row(
              children: [
                Icon(Icons.access_time, size: 13.sp, color: Colors.black.withOpacity(0.85)),
                SizedBox(width: 5.w),
                Text(recipe.time, style: _info()),
              ],
            ),
          ),

          Positioned(
            left: 92.w,
            top: 158.h,
            child: Row(
              children: [
                Icon(Icons.whatshot, size: 13.sp, color: Colors.red.withOpacity(0.9)),
                SizedBox(width: 5.w),
                Text(recipe.difficulty, style: _info()),
              ],
            ),
          ),

          Positioned(
            right: 16.w,
            top: 158.h,
            child: Row(
              children: [
                Icon(Icons.person_outline, size: 13.sp, color: Colors.black.withOpacity(0.85)),
                SizedBox(width: 5.w),
                Text('Đăng bởi ${recipe.author}', style: _info()),
              ],
            ),
          ),

          // === RATING – NỀN MỜ NHẸ ===
          Positioned(
            left: 12.w,
            top: 8.h,
            child: _frostedContainer(
              width: 162.w,
              height: 26.h,
              borderRadius: BorderRadius.circular(20.r),
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 15.sp),
                  SizedBox(width: 5.w),
                  Text(
                    '${recipe.rating} (1k+ Đánh giá)',
                    style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),

          // === TRÁI TIM – NỀN TRẮNG MỜ ===
          Positioned(
            right: 12.w,
            top: 12.h,
            child: _frostedContainer(
              width: 28.w,
              height: 28.h,
              borderRadius: BorderRadius.circular(14.r),
              child: Center(
                child: Icon(
                  Icons.favorite,
                  color: const Color(0xFFFF6B9D),
                  size: 17.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _info() => TextStyle(
    color: Colors.black.withOpacity(0.85),
    fontSize: 11.5.sp,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );
}