// lib/screens/survey/widgets/survey_input_field.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SurveyInputField extends ConsumerWidget {
  final String label;
  final String placeholder;
  final int maxLength;
  final bool isRequired;
  final TextInputType inputType;
  final Function(String) onChanged;

  const SurveyInputField({
    super.key,
    required this.label,
    required this.placeholder,
    this.maxLength = 30,
    this.isRequired = false,
    this.inputType = TextInputType.text,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500, fontFamily: 'SF Pro Rounded')),
            if (isRequired)
              Text(' (*)', style: TextStyle(color: const Color(0xFFFF5959), fontSize: 13.sp)),
          ],
        ),
        SizedBox(height: 8.h),
        Container(
          width: 370.w,
          height: 48.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: const Color(0xFFEBEBEB),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: Colors.black.withOpacity(0.4)),
          ),
          child: TextField(
            onChanged: onChanged,
            maxLength: maxLength,
            keyboardType: inputType,
            style: TextStyle(fontSize: 16.sp, color: Colors.black.withOpacity(0.5)),
            decoration: InputDecoration(
              hintText: placeholder,
              counterText: '',
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}