import 'package:easy_localization/easy_localization.dart';
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
                'Người dùng phổ biến'.tr(),
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
            future: _userService.getPopularChefsByRatings(), // Gọi hàm mới viết
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              // Nếu không có data hoặc data rỗng (không ai trên 3 sao)
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text("Chưa có đầu bếp nổi bật nào."),
                );
              }

              final users = snapshot.data!;

              // Hiển thị list
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: users.map((user) => _userItem(context, user, isDark)).toList(),
                ),
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
        // Truyền user.uid (lấy từ Firestore) sang màn hình Profile
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChefProfileScreen(userId: user.id ?? ''),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: 15.w), // Khoảng cách giữa các item
        child: Column(
          children: [
            CircleAvatar(
              radius: 40.r,
              backgroundImage: user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                  ? NetworkImage(user.avatarUrl!)
                  : const AssetImage('image/default_avatar.png') as ImageProvider,
            ),
            SizedBox(height: 10.h),
            Text(
              user.displayName ?? 'Ẩn danh',
              style: TextStyle(/*...*/),
            ),
            // Hiển thị số sao
            if (user.averageRating > 0)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 14.sp),
                  SizedBox(width: 4.w),
                  Text(
                    user.averageRating.toStringAsFixed(1),
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                  )
                ],
              )
          ],
        ),
      ),
    );
  }
}