// lib/features/add_recipe/widgets/missing_info_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MissingInfoDialog extends StatelessWidget {
  final Set<String> missingFields; // nhận danh sách lỗi đã được .toSet()

  const MissingInfoDialog({
    Key? key,
    required this.missingFields,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 32.w),
        padding: EdgeInsets.fromLTRB(28.w, 36.h, 28.w, 28.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 30.r,
              offset: Offset(0, 12.h),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon lỗi đỏ cam đẹp đẽ
            Container(
              width: 90.w,
              height: 90.w,
              decoration: const BoxDecoration(
                color: Color(0xFFFFEBEE),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                color: const Color(0xFFE53935),
                size: 50.sp,
              ),
            ),

            SizedBox(height: 28.h),

            // Tiêu đề
            Text(
              'Đăng cái con cặc',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 16.h),

            // Nội dung lỗi – đẹp, dễ đọc
            Text(
              'Nhập đủ thông tin vào đi thằng l',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[800],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 20.h),

            // Danh sách lỗi có dấu chấm tròn đỏ
            ...missingFields.map((field) => Padding(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              child: Row(
                children: [
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE53935),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    field,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )).toList(),

            SizedBox(height: 36.h),

            // Nút Đóng – bo tròn, đỏ cam, nổi bật
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFE724C),
                  padding: EdgeInsets.symmetric(vertical: 18.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  elevation: 8,
                  shadowColor: const Color(0xFFFE724C).withOpacity(0.4),
                ),
                child: Text(
                  'OK! bố mày biết rồi',
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}