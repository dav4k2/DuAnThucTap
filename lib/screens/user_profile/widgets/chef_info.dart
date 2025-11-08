// lib/widgets/chef_info.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChefInfo extends StatelessWidget {
  final String name;
  final String title;
  const ChefInfo({super.key, required this.name, required this.title});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 131.w,
          top: 270.h,
          child: Text(name, style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.w600, height: 0.85)),
        ),
        Positioned(
          left: 117.w,
          top: 299.h,
          child: Text(
            title,
            style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 15.sp, height: 1.47, fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }
}