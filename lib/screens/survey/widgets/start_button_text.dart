// lib/screens/survey/widgets/start_button_text.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StartButtonText extends StatelessWidget {
  final String text;
  final double width;

  const StartButtonText({
    super.key,
    required this.text,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.w,
      height: 65.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFFFB901),          // Nền vàng
        borderRadius: BorderRadius.circular(50.r), // Bo tròn 50
        border: Border.all(
          color: Colors.black,
          width: 2.w,                           // Viền đen 2px
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black,
          fontSize: 24.sp,
          fontFamily: 'SF Pro Rounded',
          fontWeight: FontWeight.w700,
          decoration: TextDecoration.none,
          shadows: [Shadow(color: Colors.transparent)],
        ),
      ),
    );
  }
}
