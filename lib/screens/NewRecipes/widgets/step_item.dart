// lib/features/add_recipe/widgets/step_item.dart

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StepItem extends StatelessWidget {
  final int index;
  final String description;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onDelete;

  const StepItem({
    Key? key,
    required this.index,
    required this.description,
    this.onChanged,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 30.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 15.w),

          // Số thứ tự – GIỮ NGUYÊN
          Text(
            '$index',
            style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
          ),

          SizedBox(width: 20.w),

          // Đường dọc xanh – GIỮ NGUYÊN (chỉ đổi width/height cho đúng)
          Container(
            width: 3.w,
            height: 46.h,
            color: const Color(0xFF21DB53),
          ),

          SizedBox(width: 20.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ô nhập mô tả – GIỮ NGUYÊN 100%
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEBEBEB),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: TextField(
                          controller: TextEditingController(text: description)
                            ..selection = TextSelection.fromPosition(
                                TextPosition(offset: description.length)),
                          style: TextStyle(fontSize: 15.sp, color: Colors.black87),
                          decoration: InputDecoration(
                            hintText: 'Mô tả chi tiết bước này...',
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                          ),
                          onChanged: onChanged,
                        ),
                      ),
                    ),

                    // Nút xóa – GIỮ NGUYÊN
                    if (onDelete != null)
                      IconButton(
                        icon: Icon(Icons.close, size: 20.sp, color: Colors.grey.shade600),
                        onPressed: onDelete,
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                  ],
                ),

                SizedBox(height: 12.h),

                // Ô ẢNH – ĐÃ ĐỔI THÀNH NÉT ĐỨT VÀNG ĐẸP, GIỮ NGUYÊN KÍCH THƯỚC + VỊ TRÍ
                DottedBorder(
                  color: const Color(0xFFFFB901),
                  strokeWidth: 2.5,
                  dashPattern: const [8, 5],
                  borderType: BorderType.RRect,
                  radius: Radius.circular(20.r),
                  child: Container(
                    width: 68.w,
                    height: 68.h,
                    decoration: BoxDecoration(
                      color: const Color(0x51D4D4D4),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.add,
                        size: 20.sp,
                        color: const Color(0xFFFFB901),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 20.w),
        ],
      ),
    );
  }
}