import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TitleHeader extends StatelessWidget {
  const TitleHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 161.w,
      top: 65.h,
      child: Text(
        'Cài đặt',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: 24.sp,
          fontFamily: 'SF Pro',
          fontWeight: FontWeight.w700,
          height: 0.92,
        ),
      ),
    );
  }
}