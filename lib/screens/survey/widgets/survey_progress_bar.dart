// lib/screens/survey/widgets/survey_progress_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SurveyProgressBar extends StatelessWidget {
  final int currentStep; // 1, 2, hoặc 3
  final int totalSteps = 3;

  const SurveyProgressBar({
    super.key,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    double progress = currentStep / totalSteps;
    double filledWidth = 75.w * (currentStep); // mỗi bước 75w

    return Stack(
      children: [
        // Thanh nền xám
        Positioned(
          left: 89.w,
          top: 77.h,
          child: Container(
            width: 224.w,
            height: 5.h,
            decoration: BoxDecoration(
              color: const Color(0xFFDADADA),
              borderRadius: BorderRadius.circular(60.r),
            ),
          ),
        ),
        // Thanh tiến độ vàng (animate được)
        Positioned(
          left: 89.w,
          top: 77.h,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            width: filledWidth,
            height: 5.h,
            decoration: BoxDecoration(
              color: const Color(0xFFFFC735),
              borderRadius: BorderRadius.circular(60.r),
            ),
          ),
        ),
        // Text 1/3, 2/3, 3/3
        Positioned(
          right: 40.w,
          top: 68.h,
          child: Text(
            '$currentStep/$totalSteps',
            style: TextStyle(
              color: Colors.black.withOpacity(0.6),
              fontSize: 12.sp,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}