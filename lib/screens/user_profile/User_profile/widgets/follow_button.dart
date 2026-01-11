// lib/widgets/follow_button.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../Service/user_service.dart';
import '../../../notification/logic/notification_service.dart';
import '../../MyUser_profile/logic/follower_provider.dart';

class FollowButton extends ConsumerWidget {
  final String targetUserId;
  final String targetUserName;

  const FollowButton({
    super.key,
    required this.targetUserId,
    required this.targetUserName
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId == targetUserId) return const SizedBox.shrink();

    final isFollowingAsync = ref.watch(isFollowingProvider(targetUserId));

    return Positioned(
      left: 62.w,
      top: 437.h,
      child: isFollowingAsync.when(
        loading: () => _buildButtonUI(isLoading: true),
        error: (_, __) => const SizedBox.shrink(),
        data: (isFollowing) {
          return GestureDetector(
            onTap: () async {
              if (currentUserId == null) return;

              final userService = UserService();
              final notificationService = NotificationService(); // Khởi tạo service

              // LOGIC BỎ THEO DÕI
              if (isFollowing) {
                final confirm = await _showConfirmDialog(context, targetUserName);
                if (confirm != true) return;

                // Hủy follow
                await userService.toggleFollowUser(targetUserId: targetUserId);
              }
              // LOGIC THEO DÕI (MỚI)
              else {
                // 1. Thực hiện follow trong DB
                await userService.toggleFollowUser(targetUserId: targetUserId);

                // 2. Gửi thông báo cho người được follow
                // (Không cần await để tránh làm chậm UI)
                notificationService.sendFollowNotification(targetUserId: targetUserId);
              }

              // Refresh UI như cũ
              ref.invalidate(isFollowingProvider(targetUserId));
              ref.invalidate(followersListProvider(targetUserId));
              ref.invalidate(followingListProvider(currentUserId));
            },
            child: _buildButtonUI(isFollowing: isFollowing),
          );
        },
      ),
    );
  }

  // ... (Phần UI _buildButtonUI và _showConfirmDialog giữ nguyên như code trước)
  Widget _buildButtonUI({bool isFollowing = false, bool isLoading = false}) {
    if (isLoading) {
      return Container(
        width: 277.w, height: 39.h,
        decoration: ShapeDecoration(
          color: Colors.grey[200],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
        ),
        child: const Center(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))),
      );
    }

    return Container(
      width: 277.w,
      height: 39.h,
      decoration: ShapeDecoration(
        color: isFollowing ? Colors.white : const Color(0xFFFFC735),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: isFollowing ? const Color(0xFFFFB901) : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(30.r),
        ),
        shadows: const [
          BoxShadow(color: Color(0x3F000000), blurRadius: 4, offset: Offset(0, 4))
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (isFollowing)
            Positioned(
              left: 20.w,
              child: Icon(Icons.check, size: 20.sp, color: const Color(0xFFFFB901)),
            ),
          Text(
            isFollowing ? 'Đã theo dõi' : 'Theo dõi',
            style: TextStyle(
              color: isFollowing ? const Color(0xFFFFB901) : Colors.black,
              fontSize: 20.sp,
              fontFamily: 'SF Pro Rounded',
              fontWeight: FontWeight.w600,
              height: 1.10,
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showConfirmDialog(BuildContext context, String name) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bỏ theo dõi?'),
        content: Text('Bạn có chắc muốn bỏ theo dõi $name?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hủy')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Bỏ theo dõi', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}