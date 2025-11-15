// lib/screens/search/widgets/explore_appbar.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../search_content/search_screen.dart';

class ExploreAppBar extends ConsumerWidget {
  final double width;

  const ExploreAppBar({super.key, required this.width});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: width,
      color: const Color(0xFFFFC221), // ← CỐ ĐỊNH MÀU VÀNG (không đổi theo theme)
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 16.w,
        right: 16.w,
        bottom: 10.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ROW CHỨA NÚT BACK VÀ TIÊU ĐỀ
          Row(
            children: [
              // Nút back
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),

              // Tiêu đề "Khám phá" ở giữa
              Expanded(
                child: Text(
                  'Khám phá',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // ← CỐ ĐỊNH MÀU ĐEN
                  ),
                ),
              ),

              // Spacer để cân bằng với back button
              const SizedBox(width: 40),
            ],
          ),

          SizedBox(height: 12.h),

          // THANH TÌM KIẾM
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
            child: Container(
              height: 48.h,
              width: 0.88.sw,
              decoration: BoxDecoration(
                color: Colors.white, // ← CỐ ĐỊNH MÀU TRẮNG
                borderRadius: BorderRadius.circular(30.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: Colors.grey[400],
                    size: 22,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Nhập tên món ăn hoặc nguyên liệu...',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}