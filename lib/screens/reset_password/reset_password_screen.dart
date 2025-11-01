import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../enter_verification_code/verify_code_screen.dart';
import '../sign_in/sign_in_screen.dart';
import 'widgets/custom_status_bar.dart';
import 'widgets/reset_header.dart';
import 'widgets/reset_form.dart';
import 'widgets/reset_button.dart';
import 'logic/reset_provider.dart';


class ResetPasswordScreen extends ConsumerWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // 🟡 Toàn bộ nội dung màn hình
            Container(
              width: size.width,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: size.height * 0.08),
                  const ResetHeader(),
                  SizedBox(height: size.height * 0.05),
                  const ResetForm(),
                  ResetButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const VerifyCodeScreen(),
                        ),
                      );
                      final email = ref.watch(emailProvider);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Đã gửi mã xác minh tới: $email')),
                      );
                    },
                  ),
                ],
              ),
            ),

            // 🔙 Nút quay lại đè trên nền vàng
            Positioned(
              top: size.height * 0.006,
              left: size.width * 0.014,
              child: SafeArea(
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SignInScreen(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
