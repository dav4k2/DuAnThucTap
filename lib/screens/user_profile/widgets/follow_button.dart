// lib/widgets/follow_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FollowButton extends StatelessWidget {
  const FollowButton({super.key});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 62.w,
      top: 412.h,
      child: Container(
        width: 277.w,
        height: 39.h,
        decoration: ShapeDecoration(
          color: const Color(0xFFFFC735),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
          shadows: const [BoxShadow(color: Color(0x3F000000), blurRadius: 4, offset: Offset(0, 4))],
        ),
        alignment: Alignment.center,
        child: Text('Theo dõi', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600, height: 1.10)),
      ),
    );
  }
}