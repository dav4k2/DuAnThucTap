// lib/features/add_recipe/widgets/dropdown_row.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../logic/add_recipe_provider.dart';

class DropdownRow extends ConsumerWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? errorText; // THÊM ĐỂ HIỆN LỖI

  const DropdownRow({
    Key? key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(top: 40.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(width: 36.w),
              Text(
                label,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              Container(
                width: 164.w,
                height: 48.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFEBEBEB),
                  borderRadius: BorderRadius.circular(20.r),
                  border: errorText != null
                      ? Border.all(color: Colors.red.withOpacity(0.6), width: 1.5)
                      : null,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: value,
                    isExpanded: true,
                    hint: Text(
                      'Chọn...',
                      style: TextStyle(fontSize: 15.sp, color: Colors.grey.shade600),
                    ),
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
          if (errorText != null)
            Padding(
              padding: EdgeInsets.only(left: 210.w, top: 6.h),
              child: Text(
                errorText!,
                style: TextStyle(color: Colors.red, fontSize: 12.sp),
              ),
            ),
        ],
      ),
    );
  }
}