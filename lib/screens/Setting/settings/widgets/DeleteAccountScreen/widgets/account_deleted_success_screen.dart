// lib/screens/delete_account/account_deletion_success_screen.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Thay bằng màn hình trang chủ thật của bạn
import '../../../../../Start/welcome/welcome_screen.dart';

class AccountDeletionSuccessScreen extends StatelessWidget {
  const AccountDeletionSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ẩn hoàn toàn status bar + navigation bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ));

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 402.w,
          height: 874.h,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              SizedBox(height: 147.h),

              // Tiêu đề
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 29.w),
                child: Text(
                  'Xóa tài khoản thành công.'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 36.sp,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w600,
                    height: 1.17,
                  ),
                ),
              ),

              SizedBox(height: 80.h),

              // Ảnh tròn từ assets
              Container(
                width: 234.w,
                height: 234.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: const DecorationImage(
                    image: AssetImage('image/deleteacc.png'),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 100.h),

              // Nút "Đến trang chủ" - kiểu PrimaryButton vàng viền đen
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                child: GestureDetector(
                  onTap: () {
                    // Chuyển về trang chủ và xóa toàn bộ stack cũ
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                          (route) => false,
                    );
                  },
                  child: Container(
                    width: 368.w,
                    height: 65.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFB901),
                      borderRadius: BorderRadius.circular(50.r),
                      border: Border.all(color: Colors.black, width: 2.w),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 8,
                          offset: Offset(0, 4.h),
                        ),
                      ],
                    ),
                    child: Text(
                      'Đến trang chủ'.tr(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24.sp,
                        fontFamily: 'SF Pro Rounded',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}