// lib/features/add_recipe/widgets/edit_missing_info_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditMissingInfoDialog extends StatelessWidget {
  final Set<String> missingFields; // nhận danh sách lỗi đã được .toSet()

  const EditMissingInfoDialog({
    Key? key,
    required this.missingFields,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Màu nền dialog
    final backgroundColor = isDark ? Color(0xFF1E1E1E) : Colors.white;
    // Màu text chính
    final primaryTextColor = isDark ? Colors.white : Colors.black87;
    // Màu text phụ
    final secondaryTextColor = isDark ? Colors.grey[300]! : Colors.grey[800]!;
    // Màu icon lỗi
    final errorIconColor = Color(0xFFE53935);
    final errorIconBg = isDark ? Color(0x66E53935) : Color(0xFFFFEBEE);
    // Màu nút
    final buttonColor = const Color(0xFFFE724C);

    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 32.w),
        padding: EdgeInsets.fromLTRB(28.w, 36.h, 28.w, 28.h),
        decoration: BoxDecoration(
          color: backgroundColor,
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
              decoration: BoxDecoration(
                color: errorIconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                color: errorIconColor,
                size: 50.sp,
              ),
            ),

            SizedBox(height: 28.h),

            // Tiêu đề
            Text(
              'Ối, bạn điền thiếu thông tin rồi', // giữ nguyên text cũ
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: primaryTextColor,
                // THÊM: Xóa gạch chân
                decoration: TextDecoration.none,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 16.h),

            // Nội dung lỗi – đẹp, dễ đọc
            Text(
              'Nhập đủ thông tin mới có thể đăng công thức nhé!',
              style: TextStyle(
                fontSize: 16.sp,
                color: secondaryTextColor,
                height: 1.5,
                decoration: TextDecoration.none,
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
                    decoration: BoxDecoration(
                      color: errorIconColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    field,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: primaryTextColor,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            )),

            SizedBox(height: 36.h),

            // Nút Đóng
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  padding: EdgeInsets.symmetric(vertical: 18.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  elevation: 8,
                  shadowColor: buttonColor.withOpacity(0.4),
                ),
                child: Text(
                  'Quat lại chỉnh sửa',
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    decoration: TextDecoration.none,
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