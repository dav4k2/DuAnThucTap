import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../logic/follower_provider.dart';

class FollowersListPage extends ConsumerWidget {
  final bool isFollowingTab;

  const FollowersListPage({super.key, required this.isFollowingTab});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = isFollowingTab
        ? ref.watch(followingListProvider)
        : ref.watch(followersListProvider);

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Container(
        height: 500.h, // Tăng nhẹ chiều cao để danh sách thoáng hơn
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28.r), // Bo góc mềm mại hơn
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
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
                      fontWeight: FontWeight.w800, // Đậm hơn để tạo điểm nhấn
                      letterSpacing: -0.5,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close_rounded, color: Colors.grey[400], size: 24.sp),
                  )
                ],
              ),
            ),
            const Divider(height: 1, thickness: 0.5),

            // --- Danh sách ---
            Expanded(
              child: list.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                itemCount: list.length,
                physics: const BouncingScrollPhysics(), // Hiệu ứng cuộn mượt kiểu iOS
                separatorBuilder: (context, index) => SizedBox(height: 18.h),
                itemBuilder: (context, index) {
                  final user = list[index];
                  return _buildUserTile(context, ref, user);
                },
              ),
            ),

            // --- Footer ---
            Padding(
              padding: EdgeInsets.only(bottom: 15.h, top: 5.h),
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFFFFCC33),
                  padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
                ),
                child: Text(
                  "Đóng",
                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Widget hiển thị từng dòng người dùng
  Widget _buildUserTile(BuildContext context, WidgetRef ref, Follower user) {
    return Row(
      children: [
        // Avatar với đổ bóng nhẹ
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: CircleAvatar(
            radius: 28.r,
            backgroundColor: Colors.grey[100],
            backgroundImage: user.avatarUrl.isNotEmpty ? NetworkImage(user.avatarUrl) : null,
            child: user.avatarUrl.isEmpty ? Icon(Icons.person, size: 24.sp, color: Colors.grey[400]) : null,
          ),
        ),
        SizedBox(width: 14.w),
        // Thông tin tên
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp, color: Colors.black87),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2.h),
              Text(
                '${user.recipeCount} công thức',
                style: TextStyle(color: Colors.grey[500], fontSize: 12.sp),
              ),
            ],
          ),
        ),
        // Nút bấm trạng thái
        _buildActionButton(ref, user),
      ],
    );
  }

  // Widget Nút Follow/Unfollow
  Widget _buildActionButton(WidgetRef ref, Follower user) {
    final bool isFollowing = user.isFollowedByMe;
    return GestureDetector(
      onTap: () => ref.read(followerProvider.notifier).toggleFollow(user.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: isFollowing ? Colors.white : const Color(0xFFFFCC33),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: const Color(0xFFFFCC33),
            width: 1.5,
          ),
          boxShadow: isFollowing
              ? null
              : [BoxShadow(color: const Color(0xFFFFCC33).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Text(
          isFollowing ? "Đang theo dõi" : "Theo dõi",
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: isFollowing ? const Color(0xFFFFCC33) : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline_rounded, size: 40.sp, color: Colors.grey[300]),
          SizedBox(height: 10.h),
          Text("Chưa có ai ở đây", style: TextStyle(color: Colors.grey[400], fontSize: 14.sp)),
        ],
      ),
    );
  }
}