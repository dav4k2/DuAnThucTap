import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResendEmailText extends StatelessWidget {
  final VoidCallback onTap;
  final bool isWaiting;
  final int secondsLeft;

  const ResendEmailText({
    super.key,
    required this.onTap,
    required this.isWaiting,
    required this.secondsLeft,
  });

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
          onTap: isWaiting ? null : onTap,
          child: Text(
            isWaiting ? "Gửi lại sau $secondsLeft giây" : "Gửi lại",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isWaiting ? Colors.grey : Colors.black.withOpacity(0.7),
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              decoration: isWaiting ? TextDecoration.none : TextDecoration.underline,
              height: 1.47,
            ),
          ),
        ),
      ],
    );
  }
}
