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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final secondaryColor = isDark ? Colors.white.withOpacity(0.6) : Colors.black.withOpacity(0.6);

    return Stack(
      children: [
        // TÊN ĐẦU BẾP
        Positioned(
          left: 161.w,
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
          left: 147.w,
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