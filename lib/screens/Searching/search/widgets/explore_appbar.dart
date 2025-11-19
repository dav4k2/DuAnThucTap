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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textAndIconColor = isDarkMode ? Colors.white : Colors.black;

    return Container(
      width: width,
      color: const Color(0xFFFFC221),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 16.w,
        right: 16.w,
        bottom: 10.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Tiêu đề + back button
          Row(
            children: [
              Expanded(
                child: Text(
                  'Khám phá',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 40),
            ],
          ),
          SizedBox(height: 12.h),

          // THANH TÌM KIẾM – ĐÚNG Y HỆT SearchBarWidget
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.black.withOpacity(0.2) : Colors.white,
              border: Border.all(
                color: isDarkMode ? Colors.white54 : Colors.black26,
                width: 1.2,
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            child: TextField(
              readOnly: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchScreen()),
                );
              },
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 14.5.sp,
              ),
              decoration: InputDecoration(
                hintText: 'Nhập tên món ăn hoặc nguyên liệu...',
                hintStyle: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                  fontSize: 14.5.sp,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
                prefixIcon: Icon(
                  Icons.search,
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}