// lib/widgets/profile_tabs.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../logic/chef_provider.dart';

class ProfileTabs extends ConsumerWidget {
  const ProfileTabs({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cur = ref.watch(profileTabProvider);
    final notifier = ref.read(profileTabProvider.notifier);

    return Stack(
      children: [
        _tab('Công thức', 30.w, 475.h, ProfileTab.congThuc, cur, notifier),
        _tab('Tiểu sử', 138.w, 475.h, ProfileTab.tieuSu, cur, notifier),
        _tab('Ảnh', 224.w, 474.h, ProfileTab.anh, cur, notifier),
        _tab('Đánh giá', 284.w, 474.h, ProfileTab.danhGia, cur, notifier),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          left: _underlineLeft(cur),
          top: 500.h,
          child: Container(width: 82.w, height: 3.h, decoration: BoxDecoration(color: const Color(0xFFFFB901), borderRadius: BorderRadius.circular(15.r))),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          left: _underlineLeft(cur),
          top: 502.h,
          child: Container(width: 82.w, height: 1.h, color: const Color(0xFFFFB901)),
        ),
      ],
    );
  }

  Widget _tab(String text, double left, double top, ProfileTab tab, ProfileTab cur, StateController<ProfileTab> notifier) {
    return Positioned(
      left: left,
      top: top,
      child: GestureDetector(
        onTap: () => notifier.state = tab,
        child: Text(
          text,
          style: TextStyle(
            color: cur == tab ? const Color(0xFFFFB901) : Colors.black,
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            height: 1.38,
          ),
        ),
      ),
    );
  }

  double _underlineLeft(ProfileTab t) => {
    ProfileTab.congThuc: 30.w,
    ProfileTab.tieuSu: 138.w,
    ProfileTab.anh: 224.w,
    ProfileTab.danhGia: 284.w,
  }[t]!;
}