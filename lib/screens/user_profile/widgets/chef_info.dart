// lib/widgets/chef_info.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChefInfo extends StatelessWidget {
  final String name;
  final String title;

  const ChefInfo({
    super.key,
    required this.name,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    // LẤY MÀU TỪ THEME → TỰ ĐỔI THEO DARK MODE
    final textColor = Theme.of(context).textTheme.bodyMedium!.color!;
    final secondaryColor = textColor.withOpacity(0.6); // Màu phụ (60%)

    return Stack(
      children: [
        // TÊN ĐẦU BẾP
        Positioned(
          left: 131.w,
          top: 280.h,
          child: Text(
            name,
            style: TextStyle(
              fontSize: 26.sp,
              fontWeight: FontWeight.w600,
              height: 0.85,
              color: textColor, // TỰ ĐỔI: ĐEN → TRẮNG
            ),
          ),
        ),

        // CHỨC DANH
        Positioned(
          left: 117.w,
          top: 310.h,
          child: Text(
            title,
            style: TextStyle(
              color: secondaryColor, // TỰ ĐỔI: XÁM → TRẮNG NHẠT
              fontSize: 15.sp,
              height: 1.47,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}