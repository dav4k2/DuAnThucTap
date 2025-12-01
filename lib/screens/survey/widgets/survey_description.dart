// lib/screens/survey/widgets/survey_description.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SurveyDescription extends StatelessWidget {
  final String text;

  const SurveyDescription({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 27.w,
      top: 222.h,
      child: SizedBox(
        width: 347.w,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black.withOpacity(0.7),
            fontSize: 15.sp,
            fontFamily: 'SF Pro',
            fontWeight: FontWeight.w400,
            height: 1.47,
            decoration: TextDecoration.none,
            shadows: [Shadow(color: Colors.transparent)],
          ),
        ),
      ),
    );
  }
}