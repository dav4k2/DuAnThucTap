import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecipeCard extends StatelessWidget {
  final String title;
  final String time;
  final String level;
  final String author;
  final String rating;
  final String imagePath; // ảnh local: images/tenanh.png
  final VoidCallback? onTap;

  const RecipeCard({
    super.key,
    required this.title,
    required this.time,
    required this.level,
    required this.author,
    required this.rating,
    required this.imagePath,
    this.onTap,
  });

  Widget _frosted({
    required BuildContext context,
    required Widget child,
    BorderRadius? radius,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color:
        isDark ? Colors.white.withOpacity(0.15) : Colors.white.withOpacity(0.75),
        borderRadius: radius ?? BorderRadius.circular(20.r),
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
    final textColor = Theme.of(context).textTheme.bodyMedium!.color!;
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            height: 200.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.r),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.r),
                  bottom: Radius.circular(30.r),
                ),
                border: Border.all(color: Colors.black.withOpacity(0.5)),
              ),
            ),
          ),
          Positioned(
            left: 20.w,
            top: 151.h,
            right: 20.w,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Positioned(
            left: 16.w,
            bottom: 5.h,
            child: Row(
              children: [
                Icon(Icons.access_time, size: 14.sp, color: textColor),
                SizedBox(width: 4.w),
                Text(time, style: TextStyle(fontSize: 12.sp, color: textColor)),
              ],
            ),
          ),
          Positioned(
            left: 100.w,
            bottom: 5.h,
            child: Row(
              children: [
                Icon(Icons.whatshot, size: 14.sp, color: Colors.red),
                SizedBox(width: 4.w),
                Text(level, style: TextStyle(fontSize: 12.sp, color: textColor)),
              ],
            ),
          ),
          Positioned(
            right: 20.w,
            bottom: 5.h,
            child: Text(
              'Đăng bởi $author',
              style: TextStyle(fontSize: 12.sp, color: textColor),
            ),
          ),
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
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 16.w,
            top: 12.h,
            child: _frosted(
              context: context,
              radius: BorderRadius.circular(16.r),
              child: Icon(Icons.favorite,
                  color: Color(0xFFFF6B9D), size: 18.sp),
            ),
          ),
        ],
      ),
    );
  }
}
