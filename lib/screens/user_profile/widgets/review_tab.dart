// lib/widgets/review_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewTab extends StatelessWidget {
  const ReviewTab({super.key});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 43.w,
      top: 594.h,
      child: Column(
        children: [
          _review("Tuyệt vời! Gà rán ngon nhất từng ăn.", 5),
          _review("Công thức dễ làm, cảm ơn chef!", 4),
        ],
      ),
    );
  }

  Widget _review(String text, int stars) => Container(
    width: 322.w,
    margin: EdgeInsets.only(bottom: 16.h),
    padding: EdgeInsets.all(12.w),
    decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12.r)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: List.generate(5, (i) => Icon(Icons.star, size: 16.sp, color: i < stars ? Colors.amber : Colors.grey))),
        SizedBox(height: 4.h),
        Text(text, style: TextStyle(fontSize: 13.sp)),
      ],
    ),
  );
}