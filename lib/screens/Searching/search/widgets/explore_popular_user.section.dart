import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../Service/user_model.dart';
import '../../../../Service/user_service.dart';
import '../../../user_profile/User_profile/chef_profile_screen.dart';

class PopularUsersSection extends StatelessWidget {
  final double width;
  final UserService _userService = UserService();

  PopularUsersSection({super.key, required this.width});

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
            ],
          ),
          SizedBox(height: 20.h),
          FutureBuilder<List<UserModel>>(
            future: _userService.getPopularChefsByRatings(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text("Không có người dùng phổ biến nào.");
              }

              final users = snapshot.data!;

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: users.map((user) => _userItem(context, user, isDark)).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  // Cập nhật hàm _userItem
  static Widget _userItem(BuildContext context, UserModel user, bool isDark) {
    return GestureDetector(
      onTap: () {
        // Có thể truyền user.id qua ChefProfileScreen để hiển thị chi tiết
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
            // Sử dụng avatarUrl từ Cloudinary, nếu null thì dùng ảnh mặc định
            backgroundImage: user.avatarUrl != null
                ? NetworkImage(user.avatarUrl!)
                : const AssetImage('image/default_avatar.png') as ImageProvider,
            backgroundColor: Colors.grey[200],
          ),
          SizedBox(height: 10.h),
          Text(
            user.displayName ?? 'Ẩn danh',
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