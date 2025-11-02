import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/title_text.dart';
import 'widgets/description_text.dart';
import 'widgets/otp_input_area.dart';
import 'widgets/resend_email_text.dart';
import 'widgets/verify_button.dart';
import 'widgets/error_message.dart';
import 'logic/verify_signup_email_provider.dart';

class VerifySignupEmailScreen extends ConsumerWidget {
  const VerifySignupEmailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(verifySignupEmailProvider);
    final notifier = ref.read(verifySignupEmailProvider.notifier);

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
                    title: 'Xác minh Email',
                    description:
                    'Nhập mã xác minh đã được gửi đến email của bạn để đăng ký tài khoản.',
                  ),

                  SizedBox(height: 28.h),
                  OTPInputArea(
                    onChanged: notifier.setCode,
                  ),

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
