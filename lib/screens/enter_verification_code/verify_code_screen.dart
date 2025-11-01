///Sơn - Trang nhập mã xác minh

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/title_text.dart';

import 'widgets/otp_input_area.dart';
import 'widgets/resend_email_text.dart';
import 'widgets/verify_button.dart';
import 'widgets/error_message.dart';
import 'logic/verify_provider.dart';

class VerifyCodeScreen extends ConsumerStatefulWidget {
  const VerifyCodeScreen({super.key});

  @override
  ConsumerState<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends ConsumerState<VerifyCodeScreen> {
  @override
  void initState() {
    super.initState();
    // 🧼 Reset provider mỗi khi vào lại màn hình
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(verifyCodeProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(verifyCodeProvider);

    return ScreenUtilInit(
      designSize: const Size(402, 874),
      minTextAdapt: true,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SizedBox.expand(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Positioned(top: 62.h, left: 10.w, child: SizedBox(width: 40.w, height: 34.h)),
                  Positioned(top: 141.h, child: TitleText()),
                  Positioned(top: 300.h, child: OTPInputArea()),

                  // ⚠️ Chỉ hiện nếu có lỗi
                  if (state.errorMessage.isNotEmpty)
                    Positioned(
                      top: 420.h,
                      child: ErrorMessage(
                        message: state.errorMessage,
                        width: 320.w,
                      ),
                    ),

                  Positioned(top: 483.h, child: ResendEmailText()),
                  Positioned(top: 560.h, child: VerifyButton()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
