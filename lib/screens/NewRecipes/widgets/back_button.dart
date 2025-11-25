import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Padding(
        padding: EdgeInsets.all(0.r),
        child: Icon(
          Icons.arrow_back, // mũi tên đầy đủ kiểu <- có thân
          size: 30.sp,
          color: Colors.black,
        ),
      ),
    );
  }
}
