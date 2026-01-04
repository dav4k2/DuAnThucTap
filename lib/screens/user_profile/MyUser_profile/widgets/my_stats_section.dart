import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../logic/follower_provider.dart';

class MyStatsSection extends ConsumerWidget {
  final int recipes;
  // ✅ Thêm 2 callback để xử lý bấm từ bên ngoài
  final VoidCallback onFollowersTap;
  final VoidCallback onFollowingTap;

  const MyStatsSection({
    super.key,
    required this.recipes,
    required this.onFollowersTap,
    required this.onFollowingTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Tự động lấy số lượng từ Riverpod để hiển thị
    final followersCount = ref.watch(followersListProvider).length;
    final followingCount = ref.watch(followingListProvider).length;

    final textColor = Theme.of(context).textTheme.bodyMedium!.color!;
    final secondaryColor = textColor.withOpacity(0.6);
    final dividerColor = textColor.withOpacity(0.3);

    return Stack(
      children: [
        // SỐ CÔNG THỨC
        Positioned(
          left: 63.w, top: 370.h,
          child: Text('$recipes', style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.bold, color: textColor)),
        ),
        Positioned(
          left: 23.w, top: 405.h,
          child: Text('Số công thức', style: TextStyle(color: secondaryColor, fontSize: 15.sp)).tr(),
        ),

        // MỤC FOLLOWER
        Positioned(
          left: 150.w, top: 360.h,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onFollowersTap, // ✅ Gọi hàm truyền từ bên ngoài
            child: Container(
              width: 100.w, height: 70.h,
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('$followersCount', style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.bold, color: textColor)),
                  Text('Follower'.tr(), style: TextStyle(color: secondaryColor, fontSize: 15.sp)),
                ],
              ),
            ),
          ),
        ),

        // MỤC ĐÃ FOLLOW
        Positioned(
          left: 275.w, top: 360.h,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onFollowingTap, // ✅ Gọi hàm truyền từ bên ngoài
            child: Container(
              width: 100.w, height: 70.h,
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('$followingCount', style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.bold, color: textColor)),
                  Text('Đã follow'.tr(), style: TextStyle(color: secondaryColor, fontSize: 15.sp)),
                ],
              ),
            ),
          ),
        ),

        // VẠCH NGĂN
        Positioned(
          left: 115.w, top: 395.h,
          child: Transform.rotate(angle: 1.55, child: Container(width: 50.w, height: 1.5.h, color: dividerColor)),
        ),
        Positioned(
          left: 240.w, top: 395.h,
          child: Transform.rotate(angle: 1.55, child: Container(width: 50.w, height: 1.5.h, color: dividerColor)),
        ),
      ],
    );
  }
}