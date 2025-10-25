import 'package:flutter/material.dart';
import 'widgets/sign_in_background.dart';
import 'widgets/sign_in_tabs.dart';
import 'widgets/sign_in_form.dart';
import 'widgets/sign_in_social_buttons.dart';
import 'widgets/sign_up_form.dart';
import '../welcome/welcome_screen.dart';

class SignInScreen extends StatefulWidget {
  final bool initialTab; // true = đăng nhập, false = đăng ký
  const SignInScreen({super.key, this.initialTab = true});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late bool isSignIn;

  @override
  void initState() {
    super.initState();
    isSignIn = widget.initialTab; // khởi tạo trạng thái ban đầu đúng
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // phần form
    final horizontalPadding = size.width * 0.08;
    final topSpacing = size.height * 0.06;
    final tabToFormSpacing = size.height * 0.05;
    final formHeight = size.height * 0.6;

    // nút back
    final backButtonTopSpacing = size.height * 0.006;
    final backButtonLeftPadding = size.width * 0.014;

    return Scaffold(
      body: SignInBackground(
        child: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  children: [
                    SizedBox(height: topSpacing),

                    // ✅ Tabs đăng nhập / đăng ký — có initialTab
                    SignInTabs(
                      initialTab: widget.initialTab, // <— truyền trạng thái ban đầu
                      onTabChanged: (val) => setState(() => isSignIn = val),
                    ),

                    SizedBox(height: tabToFormSpacing),

                    // ✅ Form đăng nhập / đăng ký
                    SizedBox(
                      height: formHeight,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child:
                            isSignIn ? const SignInForm() : const SignUpForm(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ✅ Nút back
            Positioned(
              top: backButtonTopSpacing,
              left: backButtonLeftPadding,
              child: SafeArea(
                child: IconButton(
                  icon: const Icon(Icons.arrow_back,
                      color: Colors.black, size: 33),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const WelcomeScreen(),
                      ),
                    );
                  },
                ),
              ),
            ),

            // ✅ Social buttons
            Positioned(
              left: size.width * 0,
              right: size.width * 0,
              bottom: size.height * 0,
              child: SafeArea(
                top: false,
                bottom: false,
                child: const SignInSocialButtons(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
