// widgets/verify_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VerifyButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;

  const VerifyButton({super.key, this.onPressed, this.text = 'Xác nhận'});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 65.h,
        width: 371.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFFFB901),
          borderRadius: BorderRadius.circular(50.r),
          border: Border.all(color: Colors.black, width: 2.w),
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.black, fontSize: 24.sp, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
