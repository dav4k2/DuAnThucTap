import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// lib/screens/survey/widgets/survey_text_area.dart
class SurveyTextArea extends ConsumerWidget {
  final Function(String) onChanged;

  const SurveyTextArea({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tiểu sử', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500, fontFamily: 'SF Pro Rounded')),
        SizedBox(height: 8.h),
        Container(
          width: 370.w,
          height: 75.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: const Color(0xFFEBEBEB),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: Colors.black.withOpacity(0.4)),
          ),
          child: TextField(
            onChanged: onChanged,
            maxLength: 200,
            maxLines: 3,
            style: TextStyle(fontSize: 16.sp, color: Colors.black.withOpacity(0.5)),
            decoration: const InputDecoration(
              hintText: 'Nhập tiểu sử của bạn...',
              counterText: '',
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}