// lib/widgets/popular_users_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PopularUsersSection extends StatelessWidget {
  final double width;
  const PopularUsersSection({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Màu "Xem thêm" giống hệt KeywordsSection
    final seeMoreColor = isDark ? Colors.white : const Color(0xFF00695C);

    return Container(
      width: width,
      color: isDark ? const Color(0xFF121212) : Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tiêu đề + Xem thêm
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Người dùng phổ biến',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              Text(
                'Xem thêm',
                style: TextStyle(
                  fontSize: 14.5.sp,        // giống KeywordsSection
                  fontWeight: FontWeight.w600,
                  color: seeMoreColor,      // giống hệt: cyanAccent (dark) / xanh đậm (light)
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h), // tăng nhẹ cho thoáng như KeywordsSection

          // 3 user – giữ nguyên kích thước, chỉ đổi màu chữ
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _userItem('Mr.Dean', 'image/bean.png', isDark),
              _userItem('Donald D.', 'image/vit.png', isDark),
              _userItem('Cristiano M.', 'image/7ga.png', isDark),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _userItem(String name, String imagePath, bool isDark) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40.r,
          backgroundImage: AssetImage(imagePath),
          backgroundColor: Colors.transparent,
        ),
        SizedBox(height: 10.h),
        Text(
          name,
          style: TextStyle(
            fontSize: 14.5.sp,                    // giống KeywordsSection
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }
}