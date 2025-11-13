// lib/widgets/popular_users_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PopularUsersSection extends StatelessWidget {
  final double width;

  const PopularUsersSection({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: width,
      color: isDarkMode ? const Color(0xFF121212) : Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Người dùng phổ biến',
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
          SizedBox(height: 16.h),


          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _userItem('Mr.Dean', 'image/bean.png', isDarkMode),
              _userItem('Donald D.', 'image/vit.png', isDarkMode),
              _userItem('Cristiano M.', 'image/7ga.png', isDarkMode),
            ],
          ),
        ],
      ),
    );
  }


  static Widget _userItem(String name, String imagePath, bool isDarkMode) {
    return Column(
      children: [

        CircleAvatar(
          radius: 40.r,
          backgroundImage: AssetImage(imagePath),
        ),
        SizedBox(height: 8.h),


        Text(
          name,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }
}