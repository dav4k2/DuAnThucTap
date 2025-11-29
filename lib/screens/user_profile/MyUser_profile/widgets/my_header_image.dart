// lib/widgets/my_header_image.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyHeaderImage extends StatelessWidget {
  const MyHeaderImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      top: 0,
      child: Container(
        width: 402.w,
        height: 222.h,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("image/profile_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}