import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResendEmailText extends StatelessWidget {
  const ResendEmailText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Không nhận được mã OPT ?',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black.withOpacity(0.7),
            fontSize: 15.sp,
            fontWeight: FontWeight.w400,
            height: 1.47,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Gửi lại',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black.withOpacity(0.7),
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            decoration: TextDecoration.underline,
            height: 1.47,
          ),
        ),
      ],
    );
  }
}
