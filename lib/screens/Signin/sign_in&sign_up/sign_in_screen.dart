/// Sơn /// Trang Sign in và Sign up
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'widgets/sign_in_background.dart';
import 'widgets/sign_in_tabs.dart';
import 'widgets/sign_in_form.dart';
import 'widgets/sign_in_social_buttons.dart';
import 'widgets/sign_up_form.dart';

class SignInScreen extends ConsumerStatefulWidget {
  final bool initialTab;
  const SignInScreen({super.key, this.initialTab = true});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  late bool isSignIn;

  @override
  void initState() {
    super.initState();
    isSignIn = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // bắt buộc để đẩy nội dung khi mở bàn phím
      body: SignInBackground(
        child: Stack(
          children: [
            // =================== NỘI DUNG CHÍNH (có padding 30.w) ===================
            SafeArea(
              top: false,
              bottom: false,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    // Khi bàn phím mở → tự động thêm padding dưới để không bị che
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 107.h),

                            // Tab Đăng nhập / Đăng ký
                            SignInTabs(
                              initialTab: widget.initialTab,
                              onTabChanged: (val) => setState(() => isSignIn = val),
                            ),
                            SizedBox(height: 45.h),

                            // Form
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: isSignIn ? const SignInForm() : const SignUpForm(),
                            ),

                            // Khoảng cách để khi bàn phím mở, nút Google không đè lên nút Đăng nhập
                            SizedBox(height: 80.h),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // =================== NÚT GOOGLE & iCLOUD — FULL WIDTH, ĂN LUÔN SAFEAREA DƯỚI ===================
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SignInSocialButtons(), // BỎ SafeArea ở đây → để nó ăn trọn phần dưới
            ),

            // =================== NÚT BACK ===================
            Positioned(
              top: 61.h,
              left: 8.w,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black, size: 33),
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/welcome'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}