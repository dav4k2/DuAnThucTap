// lib/screens/survey/widgets/survey_title.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SurveyTitle1 extends StatelessWidget {
  final String text;

  const SurveyTitle1({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 10.w,
      top: 111.h,
      width: 382.w,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: 32.sp,
          fontFamily: 'SF Pro',
          fontWeight: FontWeight.w600,
          height: 1.4,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }
}