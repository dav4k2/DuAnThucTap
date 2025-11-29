// lib/widgets/edit_profile_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Edit_user/edit_profile_screen.dart';

// Thay tên này thành trang chỉnh sửa profile của bạn
//import '../screens/edit_profile_screen.dart';   // <-- CHỈ CẦN ĐỔI ĐƯỜNG DẪN NÀY LÀ CHẠY NGON

class EditProfileButton extends StatelessWidget {
  const EditProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 62.w,
      top: 437.h,
      child: GestureDetector(
        onTap: () {
          // Mở trang chỉnh sửa profile
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const EditProfileScreen(), // <-- tên class trang chỉnh sửa
            ),
          );
        },
        child: Container(
          width: 277.w,
          height: 39.h,
          decoration: ShapeDecoration(
            color: Colors.white,                           // luôn trắng (giống nút "Đã theo dõi")
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                width: 1,
                color: Color(0xFFFFB901),
              ),
              borderRadius: BorderRadius.circular(30.r),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 4,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Icon chỉnh sửa (biểu tượng bút chì)
              Positioned(
                left: 20.w,
                child: Icon(
                  Icons.edit_outlined,
                  size: 20.sp,
                  color: const Color(0xFFFFB901),
                ),
              ),

              // Text
              Text(
                'Chỉnh sửa hồ sơ',
                style: TextStyle(
                  color: const Color(0xFFFFB901),
                  fontSize: 20.sp,
                  fontFamily: 'SF Pro Rounded',
                  fontWeight: FontWeight.w600,
                  height: 1.10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}