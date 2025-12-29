import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../user_profile/User_profile/chef_profile_screen.dart';

class PopularUsersSection extends StatelessWidget {
  final double width;
  const PopularUsersSection({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final seeMoreColor = isDark ? Colors.white : const Color(0xFF00695C);

    return Container(
      width: width,
      color: isDark ? const Color(0xFF121212) : Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
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
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              /*
              Text(
                'Xem thêm',
                style: TextStyle(
                  fontSize: 14.5.sp,
                  fontWeight: FontWeight.w600,
                  color: seeMoreColor,
                ),
              ),

               */
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _userItem(context, 'Mr.Dean', 'image/bean.png', isDark),
              _userItem(context, 'Donald D.', 'image/vit.png', isDark),
              _userItem(context, 'Cristiano M.', 'image/7ga.png', isDark),
            ],
          ),
        ],
      ),
    );
  }

  // Cập nhật hàm _userItem
  static Widget _userItem(BuildContext context, String name, String imagePath, bool isDark) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ChefProfileScreen(),
          ),
        );
      },
      child: Column(
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
              fontSize: 14.5.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}