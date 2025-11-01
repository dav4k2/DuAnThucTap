import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../enter_verification_code/verify_reset_phone_screen.dart';
import '../enter_verification_code/verify_reset_email_screen.dart';
import '../sign_in/sign_in_screen.dart';
import 'widgets/reset_header.dart';
import 'widgets/reset_form.dart';
import 'widgets/reset_button.dart';
import 'logic/reset_provider.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  String errorMessage = ''; // biến lưu thông báo lỗi

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
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

                  // Hiển thị thông báo lỗi (nằm giữa TextField và nút)
                  if (errorMessage.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 16, bottom: 8),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFCDD2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.warning_amber_rounded,
                              color: Color(0xFFD32F2F), size: 20),
                          SizedBox(width: 6),
                          Text(
                            'Vui lòng nhập email hoặc số điện thoại hợp lệ!',
                            style: TextStyle(
                              color: Color(0xFFD32F2F),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                  ResetButton(
                    onPressed: () {
                      final input = ref.watch(emailProvider);
                      final isEmail = input.contains('@');
                      final isPhone = RegExp(r'^[0-9]{9,11}$').hasMatch(input);

                      setState(() => errorMessage = ''); // reset lỗi trước

                      if (isEmail) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const VerifyResetEmailScreen(),
                          ),
                        );
                      } else if (isPhone) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const VerifyResetPhoneScreen(),
                          ),
                        );
                      } else {
                        // ❌ Gán thông báo lỗi hiển thị ngay giữa màn hình
                        setState(() {
                          errorMessage = 'Vui lòng nhập email hoặc số điện thoại hợp lệ!';
                        });
                      }
                    },
                  ),
                ],
              ),
            ),

            // Nút quay lại
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
