// screens/verify_reset_email_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/title_text.dart';
import 'widgets/description_text.dart';
import 'widgets/otp_input_area.dart';
import 'widgets/resend_email_text.dart';
import 'widgets/verify_button.dart';
import 'widgets/error_message.dart';
import 'logic/verify_reset_email_provider.dart';

class VerifyResetEmailScreen extends ConsumerWidget {
  const VerifyResetEmailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(verifyResetEmailProvider);
    final notifier = ref.read(verifyResetEmailProvider.notifier);

    return ScreenUtilInit(
      designSize: const Size(402, 874),
      minTextAdapt: true,
      builder: (_, __) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Stack(
              children: [
                Center(
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
                          'Nhập mã xác minh đã được gửi đến email của bạn để đặt lại mật khẩu.',
                        ),

                        SizedBox(height: 28.h),
                        OTPInputArea(
                          onChanged: (code) {
                            notifier.setCode(code);
                          },
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
                          onPressed: () {
                            notifier.submitCode(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),


                Positioned(
                  top: 10.h,
                  left: 10.w,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: Colors.black, size: 30),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),

              ],
            ),
          ),
        );
      },
    );
  }
}
