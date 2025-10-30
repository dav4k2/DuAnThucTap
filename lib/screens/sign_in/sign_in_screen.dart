/// Sơn
/// Trang Sign in và Sign up

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widgets/sign_in_background.dart';
import 'widgets/sign_in_tabs.dart';
import 'widgets/sign_in_form.dart';
import 'widgets/sign_in_social_buttons.dart';
import 'widgets/sign_up_form.dart';
import '../welcome/welcome_screen.dart';

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
    final horizontalPadding = 30.w;

    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: SignInBackground(
          child: Stack(
            children: [


              /// Tab và form dn/dky
              LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: horizontalPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 107.h),

                            /// Tab đăng nhập / đăng ký
                            SignInTabs(
                              initialTab: widget.initialTab,
                              onTabChanged: (val) =>
                                  setState(() => isSignIn = val),
                            ),

                            SizedBox(height: 63.h),

                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: isSignIn
                                  ? const SignInForm()
                                  : const SignUpForm(),
                            ),

                            SizedBox(height: 60.h),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

              /// Nút social login
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SafeArea(
                  top: false,
                  bottom: false,
                  child: const SignInSocialButtons(),
                ),
              ),
              /// Nút back
              Positioned(
                top: 61.h,
                left: 8.w,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back,
                      color: Colors.black, size: 33),
                  onPressed: () {
                    Navigator.popUntil(context, ModalRoute.withName('/welcome'));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
