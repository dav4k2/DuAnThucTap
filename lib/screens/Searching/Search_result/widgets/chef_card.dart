// lib/widgets/chef_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Crete_recipe/logic/publish_service.dart';

class ChefCard extends StatefulWidget {
  final String name;
  final String recipeCount;
  final String avatarPath;
  final bool initiallyFollowing;
  final bool isNetworkImage;
  final String chefId;

  const ChefCard({
    super.key,
    required this.name,
    required this.recipeCount,
    required this.avatarPath,
    this.initiallyFollowing = false,
    this.isNetworkImage = true,
    required this.chefId,
  });

  @override
  State<ChefCard> createState() => _ChefCardState();
}

class _ChefCardState extends State<ChefCard> {
  late bool isFollowing;

  @override
  void initState() {
    super.initState();
    isFollowing = widget.initiallyFollowing;
  }

  void _toggleFollow() {
    PublishService().toggleFollow(widget.chefId);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Logic chọn ImageProvider phù hợp
    final ImageProvider avatarImage = (widget.isNetworkImage && widget.avatarPath.isNotEmpty)
        ? NetworkImage(widget.avatarPath)
        : AssetImage(widget.avatarPath.isNotEmpty ? widget.avatarPath : 'assets/images/default_avatar.png') as ImageProvider;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900]! : Colors.white,
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
          // Avatar xử lý linh hoạt ảnh Network/Asset
          CircleAvatar(
            radius: 32.r,
            backgroundImage: avatarImage,
            backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
            onBackgroundImageError: (exception, stackTrace) {
              debugPrint('Lỗi tải ảnh đại diện: $exception');
            },
          ),

          SizedBox(width: 16.w),

          // Thông tin tên và số lượng bài đăng
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  widget.recipeCount,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isDark ? Colors.white70 : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          StreamBuilder<bool>(
            stream: PublishService().isFollowingStream(widget.chefId),
            builder: (context, snapshot) {
              final following = snapshot.data ?? false;
              return GestureDetector(
                onTap: _toggleFollow,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 9.h),
                  decoration: BoxDecoration(
                    color: isFollowing
                        ? (isDark ? Colors.white.withOpacity(0.15) : Colors.white)
                        : const Color(0xFFFFC735),
                    border: Border.all(
                      color: const Color(0xFFFFC836),
                      width: 1.8,
                    ),
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Text(
                    isFollowing ? 'Đang theo dõi' : 'Theo dõi',
                    style: TextStyle(
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFFFC836),
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}