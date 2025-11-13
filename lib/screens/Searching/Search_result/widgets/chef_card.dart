import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChefCard extends StatefulWidget {
  final String name;
  final String recipeCount;
  final String avatarPath;           // ảnh local: images/gordon.png
  final bool initiallyFollowing;     // trạng thái ban đầu

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
    // TODO: Sau này thêm gọi API follow/unfollow ở đây
    // await followUser(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // ẢNH USER (LOCAL)
          CircleAvatar(
            radius: 32.r,
            backgroundImage: AssetImage(widget.avatarPath),
            onBackgroundImageError: (_, __) {
              debugPrint('Không load được ảnh: ${widget.avatarPath}');
            },
          ),
          SizedBox(width: 16.w),

          // TÊN + SỐ CÔNG THỨC
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                Text(
                  widget.recipeCount,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // NÚT THEO DÕI / BỎ THEO DÕI
          GestureDetector(
            onTap: _toggleFollow,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isFollowing ? Colors.white : const Color(0xFFFFC735),
                border: Border.all(
                  color: isFollowing ? const Color(0xFFFFC836) : Colors.transparent,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(30.r),
                boxShadow: isFollowing
                    ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 4,
                    offset: const Offset(0, 4),
                  ),
                ]
                    : null,
              ),
              child: Text(
                isFollowing ? 'Đang theo dõi' : 'Theo dõi',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: isFollowing ? const Color(0xFFFFC836) : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}