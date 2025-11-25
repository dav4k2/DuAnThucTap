// lib/features/add_recipe/widgets/ingredient_item.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IngredientItem extends StatelessWidget {
  final String text;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onDelete;

  const IngredientItem({
    Key? key,
    required this.text,
    this.onChanged,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: Row(
        children: [
          SizedBox(width: 36.w),
          Container(
            width: 8.w,
            height: 8.h,
            decoration: const BoxDecoration(
              color: Color(0xFFFFB901),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 20.w),

          // Ô nhập – giờ gõ được luôn!
          Expanded(
            child: Container(
              height: 48.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: const Color(0xFFEBEBEB),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: TextField(
                controller: TextEditingController(text: text)
                  ..selection = TextSelection.fromPosition(
                      TextPosition(offset: text.length)),
                style: TextStyle(fontSize: 15.sp, color: Colors.black87),
                decoration: InputDecoration(
                  hintText: 'VD: 200g bột mì, 2 quả trứng...',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                ),
                onChanged: onChanged,
              ),
            ),
          ),

          // Nút xóa
          if (onDelete != null)
            IconButton(
              icon: Icon(Icons.close, size: 20.sp, color: Colors.grey.shade600),
              onPressed: onDelete,
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
            ),

          SizedBox(width: 16.w),
        ],
      ),
    );
  }
}