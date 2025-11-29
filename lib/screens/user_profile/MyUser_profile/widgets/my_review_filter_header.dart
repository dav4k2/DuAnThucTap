// lib/widgets/my_review_filter_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../logic/my_profile_provider.dart';   // dùng provider của trang cá nhân

class MyReviewFilterHeader extends ConsumerWidget {
  const MyReviewFilterHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(myReviewFilterProvider);           // đổi provider
    final notifier = ref.read(myReviewFilterProvider.notifier); // đổi provider

    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            _chip('Mới nhất', ReviewFilter.newest, filter == ReviewFilter.newest, notifier),
            SizedBox(width: 8.w),
            _chip('Cũ nhất', ReviewFilter.oldest, filter == ReviewFilter.oldest, notifier),
            SizedBox(width: 8.w),
            _chip('Tất cả', ReviewFilter.all, filter == ReviewFilter.all, notifier),
          ],
        ),
      ),
    );
  }

  Widget _chip(
      String label,
      ReviewFilter value,
      bool active,
      StateController<ReviewFilter> notifier,
      ) {
    return GestureDetector(
      onTap: () => notifier.state = value,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFFFB901) : const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 14.sp, color: Colors.black, height: 1.57),
        ),
      ),
    );
  }
}

// SliverPersistentHeaderDelegate cho MyReviewTab
class MyReviewFilterDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: const MyReviewFilterHeader(),
    );
  }

  @override
  double get maxExtent => 54.h;

  @override
  double get minExtent => 54.h;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}