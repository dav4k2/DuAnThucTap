import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResendEmailText extends StatelessWidget {
  final VoidCallback? onTap;

  const ResendEmailText({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Không nhận được mã OTP?',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black.withOpacity(0.7),
            fontSize: 15.sp,
            fontWeight: FontWeight.w400,
            height: 1.47,
          ),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: onTap,
          child: Text(
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
        ),
      ],
    );
  }
}
