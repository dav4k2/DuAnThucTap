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
    final size = MediaQuery.of(context).size; // Lấy kích thước màn hình
    final height = size.height;
    final width = size.width;

    return Scaffold(
      body: SignInBackground(
        child: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.08), // responsive padding
                child: Column(
                  children: [
                    SizedBox(height: height * 0.06), // thay cho 50px
                    SignInTabs(
                      onTabChanged: (val) => setState(() => isSignIn = val),
                    ),
                    SizedBox(height: height * 0.08), // thay cho 60px
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

            // Social buttons luôn sát đáy, tự co giãn theo màn hình
            Positioned(
              left: width * 0.05,
              right: width * 0.05,
              bottom: height * 0.02,
              child: SafeArea(
                top: false,
                child: FractionallySizedBox(
                  widthFactor: 1,
                  child: const SignInSocialButtons(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
