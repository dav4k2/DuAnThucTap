// lib/features/add_recipe/widgets/dropdown_row.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DropdownRow extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const DropdownRow({
    Key? key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 40.h),
      child: Row(
        children: [
          SizedBox(width: 36.w),

          Text(
            label,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
          ),

          const Spacer(),

          // Dropdown đẹp + giống hệt kiểu cũ của mày
          Container(
            width: 164.w,
            height: 48.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: const Color(0xFFEBEBEB),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 24.sp,
                  color: Colors.black54,
                ),
                style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
                dropdownColor: const Color(0xFFEBEBEB),
                borderRadius: BorderRadius.circular(16.r),
                items: items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),

          SizedBox(width: 36.w),
        ],
      ),
    );
  }
}