// lib/widgets/search/recent_recipes_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fontend/screens/Searching/search_content/recent_view_card.dart';


class RecentRecipesSection extends StatelessWidget {
  final List<Map<String, String>> recentViews;
  final Function(String) onItemTap;

  const RecentRecipesSection({
    super.key,
    required this.recentViews,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Đã xem",
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        SizedBox(height: 16.h),
        ...recentViews.map((item) => RecentViewItem(
          title: item["title"]!,
          author: item["author"]!,
          rating: item["rating"]!,
          time: item["time"]!,
          difficulty: item["difficulty"]!,
          imageUrl: item["image"]!,
          onTap: () => onItemTap(item["title"]!),
        )),
      ],
    );
  }
}