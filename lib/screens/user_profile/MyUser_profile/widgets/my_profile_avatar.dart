// lib/widgets/my_profile_avatar.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyProfileAvatar extends StatelessWidget {
  const MyProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Viền trắng bên ngoài
        Positioned(
          left: 136.w,
          top: 133.h,
          child: Container(
            width: 130.w,
            height: 130.h,
            decoration: const ShapeDecoration(
              color: Colors.white,
              shape: OvalBorder(),
            ),
          ),
        ),

        // Avatar thật
        Positioned(
          left: 141.w,
          top: 138.h,
          child: Container(
            width: 120.w,
            height: 120.h,
            decoration: const ShapeDecoration(
              image: DecorationImage(
                image: AssetImage("image/avatar.png"), // giữ nguyên ảnh
                fit: BoxFit.fill,
              ),
              shape: OvalBorder(),
            ),
          ),
        ),
      ],
    );
  }
}