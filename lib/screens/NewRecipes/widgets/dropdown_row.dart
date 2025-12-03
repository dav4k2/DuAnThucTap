// lib/features/add_recipe/widgets/dropdown_row.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DropdownRow extends ConsumerWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? errorText;

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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = isDark ? Colors.grey.shade800 : const Color(0xFFEBEBEB);
    final textColor = isDark ? Colors.white : Colors.black87;
    final hintColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;
    final iconColor = isDark ? Colors.white70 : Colors.black54;

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
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: textColor),
              ),
              const Spacer(),
              Container(
                width: 164.w,
                height: 48.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: backgroundColor,
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
                      style: TextStyle(fontSize: 15.sp, color: hintColor),
                    ),
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 24.sp,
                      color: iconColor,
                    ),
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: textColor,
                      fontWeight: FontWeight.w500,
                    ),
                    dropdownColor: backgroundColor,
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
