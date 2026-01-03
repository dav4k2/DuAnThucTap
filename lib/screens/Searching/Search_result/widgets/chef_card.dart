// lib/widgets/chef_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Crete_recipe/logic/publish_service.dart';
import '../../../user_profile/User_profile/chef_profile_screen.dart';

class ChefCard extends StatelessWidget {
  final String name;
  final String recipeCount;
  final String avatarPath;
  final bool isNetworkImage;
  final String chefId;

  const ChefCard({
    super.key,
    required this.name,
    required this.recipeCount,
    required this.avatarPath,
    this.isNetworkImage = true,
    required this.chefId,
  });

  void _toggleFollow() {
    PublishService().toggleFollow(chefId);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChefProfileScreen(userId: chefId),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20.r),
      child:  Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.4 : 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // FIX AVATAR: Sử dụng child làm fallback thay vì AssetImage
            CircleAvatar(
              radius: 32.r,
              backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
              child: ClipOval(
                child: avatarPath.isNotEmpty
                    ? Image.network(
                  avatarPath,
                  width: 64.r,
                  height: 64.r,
                  fit: BoxFit.cover,
                  // Xử lý khi ảnh Cloudinary lỗi hoặc không load được
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.person, size: 32.r, color: Colors.grey[400]),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(child: CircularProgressIndicator(strokeWidth: 2.w));
                  },
                )
                    : Icon(Icons.person, size: 32.r, color: Colors.grey[400]),
              ),
            ),
            SizedBox(width: 16.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    recipeCount,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDark ? Colors.white70 : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // FIX NÚT THEO DÕI: Dùng trực tiếp dữ liệu từ Stream
            StreamBuilder<bool>(
              stream: PublishService().isFollowingStream(chefId),
              builder: (context, snapshot) {
                final isFollowing = snapshot.data ?? false;

                return GestureDetector(
                  onTap: _toggleFollow,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: isFollowing
                          ? (isDark ? Colors.white.withOpacity(0.1) : Colors.white)
                          : const Color(0xFFFFC735),
                      border: Border.all(color: const Color(0xFFFFC735), width: 1.5),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Text(
                      isFollowing ? 'Đang theo dõi' : 'Theo dõi',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        // Màu chữ tương phản với nền
                        color: isFollowing ? const Color(0xFFFFC735) : Colors.white,
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}