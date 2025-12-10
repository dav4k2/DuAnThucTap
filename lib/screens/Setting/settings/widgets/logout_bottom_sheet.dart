import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LogoutBottomSheett extends StatelessWidget {
  final VoidCallback onConfirm;

  const LogoutBottomSheett({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDarkMode ? Colors.grey[900] : Colors.white;
    final borderColor = isDarkMode ? Colors.white24 : Colors.black.withOpacity(0.30);
    final dragBarColor = isDarkMode ? Colors.white54 : Colors.black.withOpacity(0.5);
    final titleColor = isDarkMode ? Colors.white : Colors.black;
    final subtitleColor = isDarkMode ? Colors.white70 : Colors.black.withOpacity(0.5);
    final cancelButtonColor = isDarkMode ? Colors.white24 : const Color(0x2B8F8F8F);
    final cancelTextColor = isDarkMode ? Colors.white70 : Colors.black.withOpacity(0.5);

    return Container(
      width: 402.w,
      height: 309.h,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Thanh kéo
          Positioned(
            top: 10.h,
            left: 140.w,
            child: Container(
              width: 122.w,
              height: 2.h,
              color: dragBarColor,
            ),
          ),

          // Tiêu đề
          Positioned(
            top: 35.h,
            left: 26.w,
            child: SizedBox(
              width: 349.w,
              child: Text(
                'Bạn có muốn đăng xuất?'.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: titleColor,
                  fontSize: 22.sp,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w600,
                  height: 1.36,
                ),
              ),
            ),
          ),

          // Gạch ngang dưới tiêu đề
          Positioned(
            top: 84.h,
            left: 0,
            child: Container(
              width: 402.w,
              height: 1.h,
              color: borderColor.withOpacity(0.5),
            ),
          ),

          // Dòng text buồn
          Positioned(
            top: 104.h,
            left: 55.w,
            child: SizedBox(
              width: 292.w,
              child: Text(
                'Hẹn gặp lại bạn sớm nhé!'.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: subtitleColor,
                  fontSize: 22.sp,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w400,
                  height: 1.18,
                ),
              ),
            ),
          ),

          // Nút Hủy
          Positioned(
            top: 200.h,
            left: 26.w,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 169.w,
                height: 58.h,
                decoration: BoxDecoration(
                  color: cancelButtonColor,
                  borderRadius: BorderRadius.circular(50.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Hủy'.tr(),
                  style: TextStyle(
                    color: cancelTextColor,
                    fontSize: 22.sp,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w600,
                    height: 1.36,
                  ),
                ),
              ),
            ),
          ),

          // Nút Đăng xuất
          Positioned(
            top: 200.h,
            left: 212.w,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context); // đóng bottom sheet
                onConfirm();            // thực hiện logout
              },
              child: Container(
                width: 169.w,
                height: 58.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB901),
                  borderRadius: BorderRadius.circular(50.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Đăng xuất'.tr(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22.sp,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w600,
                    height: 1.36,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
