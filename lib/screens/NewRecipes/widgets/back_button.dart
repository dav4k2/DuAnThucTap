import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BackButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;

  const BackButtonWidget({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () => Navigator.of(context).pop(),
      child: Icon(
        Icons.arrow_back_rounded,
        size: 26.sp,
        color: Colors.black87,
      ),
    );
  }
}
