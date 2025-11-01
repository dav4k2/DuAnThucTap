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
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Positioned(top: 62.h, left: 10.w, child: SizedBox(width: 40.w, height: 34.h)),
                Positioned(top: 141.h, child: const TitleText(
                  title: 'Xác ',
                  description: 'Nhập mã xác minh đã được gửi đến email của bạn để đăng ký tài khoản.',
                ),),

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
