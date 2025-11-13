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
          "Đã tìm",
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        SizedBox(height: 16.h),
        ...history.map((query) => Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: InkWell(
            onTap: () => onHistoryTap(query),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    query,
                    style: TextStyle(
                      fontSize: 17.sp,
                      color: isDark ? Colors.white70 : Colors.black.withOpacity(0.6),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => onRemove(query),
                  child: Icon(Icons.close, size: 22.r, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }
}