import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/title_text.dart';
import 'widgets/otp_input_area.dart';
import 'widgets/resend_email_text.dart';
import 'widgets/verify_button.dart';
import 'widgets/error_message.dart';
import 'logic/verify_reset_phone_provider.dart';

class VerifyResetPhoneScreen extends ConsumerWidget {
  const VerifyResetPhoneScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(verifyResetPhoneProvider);
    final notifier = ref.read(verifyResetPhoneProvider.notifier);

    return ScreenUtilInit(
      designSize: const Size(402, 874),
      minTextAdapt: true,
      builder: (_, __) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 62.h),
                  SizedBox(width: 40.w, height: 34.h),

                  SizedBox(height: 70.h),
                  const TitleText(
                    title: 'Xác minh SĐT',
                    description: 'Nhập mã xác minh đã được gửi đến số điện thoại của bạn để đặt lại mật khẩu.',
                  ),

                  SizedBox(height: 28.h),
                  OTPInputArea(
                    onChanged: notifier.setCode,
                  ),

                  // lỗi xuất hiện + đẩy UI xuống
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: state.errorMessage.isNotEmpty
                        ? Padding(
                      padding: EdgeInsets.only(top: 28.h),
                      child: ErrorMessage(
                        message: state.errorMessage,
                        width: 320.w,
                      ),
                    )
                        : SizedBox(height: 10.h),
                  ),

                  SizedBox(height: 28.h),
                  ResendEmailText(
                    onTap: notifier.resendCode,
                    isWaiting: state.isWaiting,
                    secondsLeft: state.secondsLeft,
                  ),

                  SizedBox(height: 24.h),
                  VerifyButton(
                    onPressed: () => notifier.submitCode(context),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
