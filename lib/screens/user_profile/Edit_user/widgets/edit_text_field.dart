// lib/widgets/edit_profile/edit_text_field.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditTextField extends StatelessWidget {
  final String label; // Không required
  final String hintText;
  final TextEditingController controller;
  final int? maxLength;
  final int maxLines;
  final bool readOnly;
  final bool showCounter;

  const EditTextField({
    super.key,
    this.label = '', // Mặc định rỗng
    required this.hintText,
    required this.controller,
    this.maxLength,
    this.maxLines = 1,
    this.readOnly = false,
    this.showCounter = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Màu sắc theo theme
    final backgroundColor = isDark ? Colors.grey[800]! : const Color(0xFFEBEBEB);
    final borderColor = isDark ? Colors.white.withOpacity(0.4) : Colors.black.withOpacity(0.4);
    final labelColor = isDark ? Colors.white : Colors.black;
    final hintColor = isDark ? Colors.white60 : Colors.black54;
    final textColor = isDark ? Colors.white : Colors.black;
    final counterColor = isDark ? Colors.white60 : Colors.black54;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(left: 17.w, bottom: 8.h),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                color: labelColor,
              ),
            ),
          ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: borderColor),
          ),
          child: TextField(
            controller: controller,
            readOnly: readOnly,
            maxLines: maxLines,
            maxLength: maxLength,
            style: TextStyle(fontSize: 16.sp, color: textColor),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: hintColor, fontSize: 16.sp),
              border: InputBorder.none,
              counterText: showCounter && maxLength != null
                  ? '${controller.text.length}/$maxLength'
                  : '',
              counterStyle: TextStyle(fontSize: 13.sp, color: counterColor),
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            ),
          ),
        ),
      ],
    );
  }
}