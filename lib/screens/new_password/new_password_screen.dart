import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/password_input.dart';
import 'widgets/confirm_password_input.dart';
import 'widgets/submit_button.dart';
import '../new_password/logic/password_provider.dart';

class NewPasswordScreen extends ConsumerWidget {
  const NewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 400;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Container(
            width: isSmall ? size.width * 0.95 : 402,
            height: size.height,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  Text(
                    'Nhập mật khẩu mới',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isSmall ? 28 : 32,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Mật khẩu mới của bạn phải khác \nso với mật khẩu cũ.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.7),
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 40),
                  const PasswordInput(),
                  const SizedBox(height: 30),
                  const ConfirmPasswordInput(),
                  const SizedBox(height: 50),
                  const SubmitButton(),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
