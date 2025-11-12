import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fontend/screens/enter_new_password/widgets/password_field.dart';
import 'package:fontend/screens/enter_new_password/widgets/confirm_password_field.dart';
import 'widgets/title.dart';
import 'logic/enter_new_password_provider.dart';

class EnterResetPasswordScreen extends ConsumerWidget {
  const EnterResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(resetProvider);
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // 🧱 Nội dung chính
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 120.h),

                  TitleSection(),

                  const PasswordFieldGroup(),
                  const ConfirmPasswordFieldGroup(),
                  SizedBox(height: 24.h),

                  // 🟥 Thông báo lỗi
                  if (controller.errorText != null)
                    Container(
                      width: width * 0.85,
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 6.h),
                      margin: EdgeInsets.only(bottom: 24.h),
                      decoration: ShapeDecoration(
                        color: const Color(0xA8F0A4A4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.warning_amber_rounded,
                              color: const Color(0xFFF01E1E), size: 22.sp),
                          SizedBox(width: 10.w),
                          Flexible(
                            child: Text(
                              controller.errorText!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color(0xFFF01E1E),
                                fontSize: 13.sp,
                                fontFamily: 'SF Pro Rounded',
                                fontWeight: FontWeight.w400,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // 🟨 Nút xác nhận
                  GestureDetector(
                    onTap: () {
                      final success = controller.validateAndSubmit();
                      if (success) {
                        Navigator.pushNamed(context, '/success');
                      }
                    },
                    child: Container(
                      width: width * 0.85,
                      height: 65.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFB901),
                        borderRadius: BorderRadius.circular(50.r),
                        border: Border.all(color: Colors.black, width: 2.w),
                      ),
                      child: Text(
                        'Tạo mật khẩu mới',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24.sp,
                          fontFamily: 'SF Pro Rounded',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 40.h),
                ],
              ),
            ),


            Positioned(
              top: 10.h,
              left: 10.w,
              child: IconButton(
                icon: const Icon(Icons.arrow_back,
                    color: Colors.black, size: 33),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
