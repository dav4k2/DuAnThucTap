// lib/widgets/follow_button.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../Service/user_service.dart';
import '../../MyUser_profile/logic/follower_provider.dart';
import '../logic/chef_provider.dart';

class FollowButton extends ConsumerWidget {
  const FollowButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chef = ref.watch(chefProvider);
    final followStatusAsync = ref.watch(isFollowingProvider(chef.id));
    final isFollowing = followStatusAsync.value ?? false;
    final followNotifier = ref.read(followStateProvider(chef.id).notifier);

    return Positioned(
      left: 62.w,
      top: 437.h,
      child: GestureDetector(
        onTap: () async {
          final userService = UserService();

          if (isFollowing) {
            // Hiển thị Dialog xác nhận bỏ theo dõi (như code cũ của bạn)
            final confirm = await _showConfirmDialog(context, chef.name);
            if (confirm != true) return;
          }

          // 2. Gọi logic lưu vào Database
          await userService.toggleFollowUser(targetUserId: chef.id);

          // 3. LÀM MỚI DỮ LIỆU: Quan trọng nhất
          // Invalidate để các provider chạy lại và lấy dữ liệu mới nhất từ DB
          ref.invalidate(isFollowingProvider(chef.id)); // Cập nhật lại trạng thái nút
          ref.invalidate(chefDataProvider(chef.id));   // Cập nhật lại stats (số người follow) trên Profile
          ref.invalidate(followingListProvider(FirebaseAuth.instance.currentUser!.uid)); // Cập nhật danh sách nếu đang ở trang list
        },
        child: Container(
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
              // Icon (chỉ hiện khi đã follow)
              if (isFollowing)
                Positioned(
                  left: 20.w,
                  child: Icon(Icons.check, size: 20.sp, color: const Color(0xFFFFB901)),
                ),

              // Text
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
        ),
      ),
    );
  }

  Future<bool?> _showConfirmDialog(BuildContext context, String chefName) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Text('Bỏ theo dõi?', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600)),
        content: Text('Bạn có chắc muốn bỏ theo dõi $chefName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Bỏ theo dõi', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}