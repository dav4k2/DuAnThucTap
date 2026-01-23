import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 1. Import Riverpod
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../Service/user_service.dart';
import '../../../Crete_recipe/logic/publish_service.dart';
import '../../../user_profile/MyUser_profile/logic/follower_provider.dart';
import '../../../user_profile/User_profile/chef_profile_screen.dart';
import '../../../notification/logic/notification_service.dart';
// Import file chứa isFollowingProvider

// 2. Chuyển thành ConsumerWidget
class ChefCard extends ConsumerWidget {
  final String name;
  final String avatarPath;
  final bool isNetworkImage;
  final String chefId;

  const ChefCard({
    super.key,
    required this.name,
    required this.avatarPath,
    this.isNetworkImage = true,
    required this.chefId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    // 3. Lắng nghe trạng thái Follow (Tự động cập nhật khi Stream thay đổi)
    final followStateAsync = ref.watch(isFollowingProvider(chefId));

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
      child: Container(
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
            // --- AVATAR ---
            CircleAvatar(
              radius: 32.r,
              backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
              child: ClipOval(
                child: avatarPath.isNotEmpty
                    ? Image.network(
                  avatarPath,
                  width: 64.r, height: 64.r, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Icon(Icons.person, size: 32.r, color: Colors.grey[400]),
                )
                    : Icon(Icons.person, size: 32.r, color: Colors.grey[400]),
              ),
            ),
            SizedBox(width: 16.w),

            // --- THÔNG TIN ---
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black),
                  ),
                  FutureBuilder<int>(
                    future: PublishService().getRecipeCount(chefId),
                    builder: (context, snapshot) {
                      return Text(
                        "${snapshot.data ?? 0} công thức",
                        style: TextStyle(fontSize: 14.sp, color: isDark ? Colors.white70 : Colors.grey[600]),
                      );
                    },
                  ),
                ],
              ),
            ),

            // --- NÚT THEO DÕI ĐỒNG BỘ ---
            if (currentUserId != chefId) // Không hiện nút follow chính mình
              followStateAsync.when(
                loading: () => const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                error: (_, __) => const SizedBox.shrink(),
                data: (isFollowing) {
                  return GestureDetector(
                    onTap: () async {
                      final userService = UserService();
                      final notificationService = NotificationService();

                      // Gọi API (API sẽ update Firestore -> Stream sẽ tự bắn tín hiệu về đây -> UI tự đổi)
                      await userService.toggleFollowUser(targetUserId: chefId);

                      if (!isFollowing) {
                        notificationService.sendFollowNotification(targetUserId: chefId);
                      }
                    },
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