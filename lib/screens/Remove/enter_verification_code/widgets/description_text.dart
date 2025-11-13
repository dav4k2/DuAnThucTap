import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DescriptionText extends StatelessWidget {
  final String description;
  const DescriptionText({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 370.w,
      child: Text(
        description,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w400,
          height: 1.47,
          color: Colors.black87,
        ),
      ),
    );
  }
}
