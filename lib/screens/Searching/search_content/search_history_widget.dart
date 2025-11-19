// lib/widgets/search/search_history_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchHistorySection extends StatelessWidget {
  final List<String> history;
  final Function(String) onHistoryTap;
  final Function(String) onRemove;

  const SearchHistorySection({
    super.key,
    required this.history,
    required this.onHistoryTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Tìm kiếm gần đây",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: history.map((q) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.12) : Colors.grey[100],
                borderRadius: BorderRadius.circular(30.r),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.history, size: 18.r, color: isDark ? Colors.white70 : Colors.black54),
                  SizedBox(width: 8.w),
                  GestureDetector(
                    onTap: () => onHistoryTap(q),
                    child: Text(
                      q,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontSize: 14.5.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  GestureDetector(
                    onTap: () => onRemove(q),
                    child: Icon(Icons.close, size: 18.r, color: isDark ? Colors.white70 : Colors.black54),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}