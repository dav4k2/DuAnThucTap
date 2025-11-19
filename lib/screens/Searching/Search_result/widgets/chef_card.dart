// lib/widgets/chef_card.dart (hoặc đường dẫn hiện tại)
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChefCard extends StatefulWidget {
  final String name;
  final String recipeCount;
  final String avatarPath;
  final bool initiallyFollowing;

  const ChefCard({
    super.key,
    required this.name,
    required this.recipeCount,
    required this.avatarPath,
    this.initiallyFollowing = false,
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
    setState(() {
      isFollowing = !isFollowing;
    });
    // TODO: Gọi API follow/unfollow ở đây
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900]! : Colors.white, // Nền đen mịn / trắng
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.1) : Colors.transparent,
          width: 1,
        ),
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
          // Avatar
          CircleAvatar(
            radius: 32.r,
            backgroundImage: AssetImage(widget.avatarPath),
            onBackgroundImageError: (_, __) {
              debugPrint('Không load được ảnh: ${widget.avatarPath}');
            },
            backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
          ),

          SizedBox(width: 16.w),

          // Tên + số công thức
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

          // Nút Theo dõi / Đang theo dõi – ĐẸP CỰC KỲ Ở DARK MODE
          GestureDetector(
            onTap: _toggleFollow,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 9.h),
              decoration: BoxDecoration(
                color: isFollowing
                    ? (isDark ? Colors.white.withOpacity(0.15) : Colors.white)
                    : const Color(0xFFFFC735),
                border: Border.all(
                  color: isFollowing
                      ? const Color(0xFFFFC836)
                      : Colors.transparent,
                  width: 1.8,
                ),
                borderRadius: BorderRadius.circular(30.r),
                boxShadow: isFollowing
                    ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.4 : 0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ]
                    : null,
              ),
              child: Text(
                isFollowing ? 'Đang theo dõi' : 'Theo dõi',
                style: TextStyle(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w600,
                  color: isFollowing
                      ? (isDark ? const Color(0xFFFFC836) : const Color(0xFFFFC836))
                      : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}