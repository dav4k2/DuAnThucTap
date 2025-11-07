import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../sign_in/sign_in_screen.dart';

class WelcomeButtons extends StatelessWidget {
  const WelcomeButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.9.sw, // 90% chiều rộng màn hình theo ScreenUtil
      height: 70.h, // responsive theo chiều cao
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Nút Đăng nhập
          Expanded(
            child: _buildButton(
              context,
              label: 'Đăng nhập',
              backgroundColor: const Color(0xFFFFB901),
              borderColor: Colors.black,
              textColor: Colors.black,
              initialTab: true,
            ),
          ),
          SizedBox(width: 12.w),
          // Nút Đăng ký
          Expanded(
            child: _buildButton(
              context,
              label: 'Đăng ký',
              backgroundColor: Colors.white,
              textColor: Colors.black,
              borderColor: Colors.black,
              initialTab: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
      BuildContext context, {
        required String label,
        required Color backgroundColor,
        required Color textColor,
        Color? borderColor,
        required bool initialTab,
      }) {
    return SizedBox(
      height: 70.h,
      child: ElevatedButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SignInScreen(initialTab: initialTab),
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          side: borderColor != null
              ? BorderSide(color: borderColor, width: 2.w)
              : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.r),
          ),
          elevation: 4,
          shadowColor: const Color(0x3F000000),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 23.sp,
            fontFamily: 'SF Pro Rounded',
            fontWeight: FontWeight.w700,
            color: textColor,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}
