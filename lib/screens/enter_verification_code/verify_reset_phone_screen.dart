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
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Positioned(top: 62.h, left: 10.w, child: SizedBox(width: 40.w, height: 34.h)),
                Positioned(
                  top: 141.h,
                  child: const TitleText(
                    title: 'Xác minh SDT',
                    description: 'Nhập mã xác minh đã được gửi đến email của bạn để đặt lại mật khẩu.',
                  ),
                ),

                Positioned(
                  top: 300.h,
                  child: OTPInputArea(onChanged: notifier.setCode),
                ),
                if (state.errorMessage.isNotEmpty)
                  Positioned(top: 400.h, child: ErrorMessage(message: state.errorMessage, width: 320.w)),
                Positioned(top: 453.h, child: ResendEmailText(onTap: () {})),
                Positioned(top: 526.h, child: VerifyButton(onPressed: () => notifier.submitCode(context))),
              ],
            ),
          ),
        );
      },
    );
  }
}
