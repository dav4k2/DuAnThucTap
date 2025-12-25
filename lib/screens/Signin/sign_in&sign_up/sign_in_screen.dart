/// Sơn /// Trang Sign in và Sign up - FIXED POSITION & AUTO-HIDE SOCIAL
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
    // Kiểm tra xem bàn phím có đang mở hay không
    final bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      // Vẫn giữ true để Scaffold tự đẩy View khi có bàn phím
      resizeToAvoidBottomInset: true,
      body: SignInBackground(
        child: Stack(
          children: [
            // =================== NỘI DUNG CHÍNH (FORM) ===================
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    // Chỉ cho phép cuộn khi thực sự bị thiếu diện tích (bàn phím mở)
                    physics: isKeyboardVisible
                        ? const AlwaysScrollableScrollPhysics()
                        : const NeverScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.w),
                        child: Column(
                          children: [
                            SizedBox(height: 60.h), // Điều chỉnh lại khoảng cách top

                            // Tab Đăng nhập / Đăng ký
                            SignInTabs(
                              initialTab: widget.initialTab,
                              onTabChanged: (val) => setState(() => isSignIn = val),
                            ),
                            SizedBox(height: 45.h),

                            // Form nội dung
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: isSignIn ? const SignInForm() : const SignUpForm(),
                            ),

                            // Tạo khoảng trống bên dưới để không bị sát đáy khi cuộn
                            SizedBox(height: 100.h),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // =================== NÚT SOCIAL (CỐ ĐỊNH Ở ĐÁY) ===================
            // Sử dụng AnimatedOpacity để ẩn nút đi khi bàn phím hiện lên
            if (!isKeyboardVisible)
              Positioned(
                left: 0,
                right: 0,
                bottom: 20.h, // Cách đáy một khoảng cố định
                child: const SignInSocialButtons(),
              ),

            // =================== NÚT BACK (CỐ ĐỊNH) ===================
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