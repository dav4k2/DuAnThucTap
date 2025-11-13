// lib/widgets/search/recent_view_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecentViewItem extends StatelessWidget {
  final String title;
  final String author;
  final String rating;
  final String time;
  final String difficulty;
  final String imageUrl;
  final VoidCallback onTap;

  const RecentViewItem({
    super.key,
    required this.title,
    required this.author,
    required this.rating,
    required this.time,
    required this.difficulty,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        height: 89.h,
        decoration: BoxDecoration(
          color: const Color(0x60EDECEC),
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: Colors.black.withOpacity(0.4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.r),
              child: Image.network(
                imageUrl,
                width: 100.w,
                height: 89.h,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: Colors.grey[300]),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "Đăng bởi $author",
                    style: TextStyle(fontSize: 11.sp, color: Colors.black54),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.49),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Text(rating, style: TextStyle(fontSize: 10.sp)),
                      ),
                      SizedBox(width: 12.w),
                      Text(time, style: TextStyle(fontSize: 11.sp)),
                      SizedBox(width: 20.w),
                      Text(difficulty, style: TextStyle(fontSize: 11.sp)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}