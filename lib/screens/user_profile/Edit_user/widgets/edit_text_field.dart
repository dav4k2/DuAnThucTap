// lib/widgets/edit_profile/edit_text_field.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditTextField extends StatelessWidget {
  final String label;           // ← Không required nữa
  final String hintText;
  final TextEditingController controller;
  final int? maxLength;
  final int maxLines;
  final bool readOnly;
  final bool showCounter;

  const EditTextField({
    super.key,
    this.label = '',           // ← Mặc định rỗng → không bắt buộc truyền
    required this.hintText,
    required this.controller,
    this.maxLength,
    this.maxLines = 1,
    this.readOnly = false,
    this.showCounter = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(left: 17.w, bottom: 8.h),
            child: Text(
              label,
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
            ),
          ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: BoxDecoration(
            color: const Color(0xFFEBEBEB),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: Colors.black.withOpacity(0.4)),
          ),
          child: TextField(
            controller: controller,
            readOnly: readOnly,
            maxLines: maxLines,
            maxLength: maxLength,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.black54, fontSize: 16.sp),
              border: InputBorder.none,
              counterText: showCounter && maxLength != null
                  ? '${controller.text.length}/$maxLength'
                  : '',
              counterStyle: TextStyle(fontSize: 13.sp, color: Colors.black54),
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            ),
            style: TextStyle(fontSize: 16.sp),
          ),
        ),
      ],
    );
  }
}