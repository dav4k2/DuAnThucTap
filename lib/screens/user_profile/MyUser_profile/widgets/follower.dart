import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../Service/user_service.dart';
import '../logic/follower_provider.dart';

class FollowersListPage extends ConsumerWidget {
  final bool isFollowingTab;
  final String userId;

  const FollowersListPage({super.key, required this.isFollowingTab, required this.userId,});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listAsync = isFollowingTab
        ? ref.watch(followingListProvider(userId))
        : ref.watch(followersListProvider(userId));

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = isDark ? Colors.grey[900]! : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final secondaryColor = isDark ? Colors.white.withOpacity(0.6) : Colors.grey[600]!;
    final dividerColor = isDark ? Colors.grey[700]! : Colors.grey[300]!;
    final shadowColor = isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.12);
    final iconColor = isDark ? Colors.grey[500]! : Colors.grey[400]!;
    final avatarBackground = isDark ? Colors.grey[800]! : Colors.grey[100]!;
    final emptyIconColor = isDark ? Colors.grey[500]! : Colors.grey[300]!;
    final emptyTextColor = isDark ? Colors.grey[500]! : Colors.grey[400]!;

    final emptyMessage = isFollowingTab
        ? "Bạn chưa theo dõi ai"
        : "Chưa có người dùng nào follow";

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Container(
        height: 500.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(28.r),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Column(
          children: [
            // --- Header ---
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 20.h, 12.w, 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isFollowingTab ? "Đang theo dõi" : "Người theo dõi",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      color: textColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close_rounded, color: iconColor, size: 24.sp),
                  )
                ],
              ),
            ),
            Divider(height: 1, thickness: 0.5, color: dividerColor),
            // --- Danh sách ---
            Expanded(
              child: listAsync.when(
                data: (list) => list.isEmpty
                    ? _buildEmptyState(emptyIconColor, emptyTextColor, emptyMessage)
                    : ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  itemCount: list.length,
                  physics: const BouncingScrollPhysics(),
                  separatorBuilder: (context, index) => SizedBox(height: 18.h),
                  itemBuilder: (context, index) => _buildUserTile(
                    context, ref, list[index], textColor, secondaryColor, avatarBackground, shadowColor,
                  ),
                ),
                loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFFFFCC33))),
                error: (err, stack) {
                  // In lỗi ra console để bạn debug xem tại sao lỗi (không hiện lên màn hình user)
                  print("Lỗi load follower: $err");
                  return _buildEmptyState(emptyIconColor, emptyTextColor, emptyMessage);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserTile(
      BuildContext context,
      WidgetRef ref,
      Follower user,
      Color textColor,
      Color secondaryColor,
      Color avatarBackground,
      Color shadowColor,
      ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        // Avatar
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: 8,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: CircleAvatar(
            radius: 28.r,
            backgroundColor: avatarBackground,
            backgroundImage: user.avatarUrl.isNotEmpty ? NetworkImage(user.avatarUrl) : null,
            child: user.avatarUrl.isEmpty ? Icon(Icons.person, size: 24.sp, color: secondaryColor) : null,
          ),
        ),
        SizedBox(width: 14.w),
        // Thông tin
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp, color: textColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2.h),
              Text(
                '${user.recipeCount} công thức',
                style: TextStyle(color: secondaryColor, fontSize: 12.sp),
              ),
            ],
          ),
        ),
        // Nút theo dõi
        _buildActionButton(ref, user, isDark),
      ],
    );
  }

  // --- Logic nút bấm thực tế ---
  Widget _buildActionButton(WidgetRef ref, Follower user, bool isDark) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    // Nếu là chính mình thì không hiện nút follow
    if (currentUserId == user.id) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () async {
        final userService = UserService();
        await userService.toggleFollowUser(targetUserId: user.id);

        // Refresh lại danh sách sau khi thực hiện action
        ref.invalidate(followingListProvider(userId));
        ref.invalidate(followersListProvider(userId));
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: user.isFollowedByMe ? Colors.transparent : const Color(0xFFFFCC33),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFFFCC33), width: 1.5),
        ),
        child: Text(
          user.isFollowedByMe ? "Đang theo dõi" : "Theo dõi",
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: user.isFollowedByMe ? const Color(0xFFFFCC33) : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(Color iconColor, Color textColor, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline_rounded, size: 40.sp, color: iconColor),
          SizedBox(height: 10.h),
          Text(
            message, // Hiển thị thông báo động
            style: TextStyle(color: textColor, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }
}