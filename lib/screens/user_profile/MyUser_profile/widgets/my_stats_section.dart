// lib/widgets/my_stats_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyStatsSection extends StatelessWidget {
  final int recipes;
  final String followers;
  final int following;

  const MyStatsSection({
    super.key,
    required this.recipes,
    required this.followers,
    required this.following,
  });

  @override
  Widget build(BuildContext context) {
    // LẤY MÀU TỪ THEME → TỰ ĐỔI THEO DARK MODE
    final textColor = Theme.of(context).textTheme.bodyMedium!.color!;
    final secondaryColor = textColor.withOpacity(0.6);     // Màu phụ (60%)
    final dividerColor = textColor.withOpacity(0.3);       // Vạch ngăn (30%)

    return Stack(
      children: [
        // SỐ CÔNG THỨC
        Positioned(
          left: 63.w,
          top: 370.h,
          child: Text(
            '$recipes',
            style: TextStyle(
              fontSize: 26.sp,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ),
        Positioned(
          left: 23.w,
          top: 405.h,
          child: Text(
            'Số công thức',
            style: TextStyle(
              color: secondaryColor,
              fontSize: 15.sp,
            ),
          ),
        ),

        // FOLLOWERS
        Positioned(
          left: 167.w,
          top: 370.h,
          child: Text(
            followers,
            style: TextStyle(
              fontSize: 26.sp,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ),
        Positioned(
          left: 171.w,
          top: 405.h,
          child: Text(
            'Follower',
            style: TextStyle(
              color: secondaryColor,
              fontSize: 15.sp,
            ),
          ),
        ),

        // FOLLOWING
        Positioned(
          left: 312.w,
          top: 370.h,
          child: Text(
            '$following',
            style: TextStyle(
              fontSize: 26.sp,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ),
        Positioned(
          left: 293.w,
          top: 405.h,
          child: Text(
            'Đã follow',
            style: TextStyle(
              color: secondaryColor,
              fontSize: 15.sp,
            ),
          ),
        ),

        // VẠCH NGĂN 1
        Positioned(
          left: 115.w,
          top: 395.h,
          child: Transform.rotate(
            angle: 1.55,
            child: Container(
              width: 50.w,
              height: 1.5.h,
              color: dividerColor,
            ),
          ),
        ),

        // VẠCH NGĂN 2
        Positioned(
          left: 240.w,
          top: 395.h,
          child: Transform.rotate(
            angle: 1.55,
            child: Container(
              width: 50.w,
              height: 1.5.h,
              color: dividerColor,
            ),
          ),
        ),
      ],
    );
  }
}