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

    return SafeArea(
      bottom: false,
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // TIÊU ĐỀ "Khám phá" – TỰ ĐỘNG ĐỔI MÀU THEO DARK MODE
            Text(
              'Khám phá',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w800,
                color: isDarkMode ? Colors.black : Colors.black,
              ),
            ),
            SizedBox(height: 14.h),

            // THANH TÌM KIẾM – ĐẸP CHUẨN, HỖ TRỢ DARK MODE HOÀN HẢO
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchScreen()),
                );
              },
              child: Container(
                height: 50.h,
                width: 0.88.sw,
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
                  borderRadius: BorderRadius.circular(30.r),
                  border: Border.all(
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.2)
                        : Colors.black.withOpacity(0.3),
                    width: 1.2,
                  ),
                  boxShadow: isDarkMode
                      ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                      : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                      size: 22,
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'Tìm món ăn, nguyên liệu...',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black45,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}