import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyChefInfo extends StatelessWidget {
  final String name;
  final String title;

  const MyChefInfo({
    super.key,
    required this.name,
    required this.title, // Ví dụ: "Đầu bếp tại gia"
  });

  @override
  Widget build(BuildContext context) {
    // LẤY MÀU TỪ THEME
    final textColor = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;
    final secondaryColor = textColor.withOpacity(0.6);

    return Stack(
      children: [
        // TÊN ĐẦU BẾP
        Positioned(
          left: 0, // Chỉnh lại layout: nên để center hoặc full width để tránh bị lệch tên dài
          right: 0,
          top: 280.h,
          child: Center(
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26.sp,
                fontWeight: FontWeight.w600,
                height: 0.85,
                color: textColor,
              ),
            ),
          ),
        ),

        // CHỨC DANH / TRÌNH ĐỘ
        Positioned(
          left: 0,
          right: 0,
          top: 310.h,
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: secondaryColor,
                fontSize: 15.sp,
                height: 1.47,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}