import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // quan trọng để InkWell hoạt động
      child: InkWell(
        borderRadius: BorderRadius.circular(50.r),
        onTap: onPressed,
        child: Container(
          width: width ?? 371.w,
          height: 65.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFFFB901),
            borderRadius: BorderRadius.circular(50.r),
            border: Border.all(color: Colors.black, width: 2.w),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 24.sp,
              fontFamily: 'SF Pro Rounded',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
