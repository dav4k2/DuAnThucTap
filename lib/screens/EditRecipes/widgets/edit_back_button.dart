import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditBackButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;

  const EditBackButtonWidget({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onPressed ?? () => Navigator.of(context).pop(),
      child: Icon(
        Icons.arrow_back_rounded,
        size: 26.sp,
        color: isDark ? Colors.white : Colors.black87,
      ),
    );
  }
}
