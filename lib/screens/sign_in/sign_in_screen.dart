import 'package:flutter/material.dart';
import 'widgets/sign_in_background.dart';
import 'widgets/sign_in_tabs.dart';
import 'widgets/sign_in_form.dart';
import 'widgets/sign_in_social_buttons.dart';
import 'widgets/sign_up_form.dart';

class SignInScreen extends StatefulWidget {
  final bool initialTab;
  const SignInScreen({super.key, this.initialTab = true});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late bool isSignIn;

  @override
  void initState() {
    super.initState();
    isSignIn = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SignInBackground(
        child: Stack(
          children: [
            // Nội dung chính
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    SignInTabs(
                      onTabChanged: (val) => setState(() => isSignIn = val),
                    ),
                    const SizedBox(height: 60),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: isSignIn
                            ? const SignInForm()
                            : const SignUpForm(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Social buttons luôn sát đáy màn hình, tôn trọng SafeArea
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                top: false, // bỏ padding trên
                child: const SignInSocialButtons(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
