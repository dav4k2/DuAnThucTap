import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/sign_in_background.dart';
import 'widgets/sign_in_tabs.dart';
import 'widgets/sign_in_form.dart';
import 'widgets/sign_in_social_buttons.dart';
import 'widgets/sign_up_form.dart';
import '../welcome/welcome_screen.dart';

class SignInScreen extends ConsumerStatefulWidget { // 👈 đổi từ StatefulWidget
  final bool initialTab;
  const SignInScreen({super.key, this.initialTab = true});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState(); // 👈 đổi type
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
    final size = MediaQuery.of(context).size;
    final horizontalPadding = size.width * 0.08;

    // 👇 Ví dụ nếu sau này backend có provider authProvider:
    // final authState = ref.watch(authProvider);

    return Scaffold(
      body: SignInBackground(
        child: Stack(
          children: [
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: size.height * 0.07),

                            // Tab đăng nhập / đăng ký
                            SignInTabs(
                              initialTab: widget.initialTab,
                              onTabChanged: (val) => setState(() => isSignIn = val),
                            ),

                            SizedBox(height: size.height * 0.04),

                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: isSignIn
                                  ? const SignInForm()
                                  : const SignUpForm(),
                            ),

                            SizedBox(height: size.height * 0.05),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Nút back
            Positioned(
              top: size.height * 0.006,
              left: size.width * 0.014,
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

            // Nút social login
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
          ],
        ),
      ),
    );
  }
}
