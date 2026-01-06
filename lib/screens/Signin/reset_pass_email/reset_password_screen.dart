import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Remove/enter_verification_code/verify_reset_email_screen.dart';
import '../../Remove/enter_verification_code/verify_reset_phone_screen.dart';
import '../sign_in&sign_up/auth/auth_provider.dart';
import '../sign_in&sign_up/sign_in_screen.dart';
import '../signup_successfully/logic/success_provider.dart';
import '../success_reset_password/success_reset_password_screen.dart';
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
  String errorMessage = ''; // Biến lưu thông báo lỗi

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

                  // 🟡 Gọi ResetForm và truyền callback khi người dùng nhập lại
                  ResetForm(
                    onChanged: () {
                      if (errorMessage.isNotEmpty) {
                        setState(() {
                          errorMessage = '';
                        });
                      }
                    },
                  ),

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
                          Icon(
                            Icons.warning_amber_rounded,
                            color: Color(0xFFD32F2F),
                            size: 20,
                          ),
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

                  // Nút xác nhận
                  ResetButton(
                    onPressed: _handleResetPassword,
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

  Future<void> _handleResetPassword() async {
    final email = ref.read(emailProvider).trim();
    final authService = ref.read(authServiceProvider);

    // 1. Validate sơ bộ
    if (email.isEmpty || !email.contains('@')) {
      setState(() {
        errorMessage = 'Vui lòng nhập địa chỉ email hợp lệ!';
      });
      return;
    }

    // 2. Hiện loading (Nếu bạn có widget loading, hãy bật lên ở đây)
    setState(() => errorMessage = '');

    // 3. Gọi service của Firebase
    final result = await authService.resetPassword(email: email);

    if (result == null) {
      // Thành công: Thông báo cho người dùng
      if (!mounted) return;
      _showSuccessDialog(context, email);
    } else {
      // Thất bại: Hiển thị lỗi từ Firebase (ví dụ: user-not-found)
      setState(() {
        errorMessage = result;
      });
    }
  }

  // Hàm hiển thị thông báo thành công
  void _showSuccessDialog(BuildContext context, String email) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Kiểm tra Email'),
        content: Text('Một liên kết đặt lại mật khẩu đã được gửi đến $email. Vui lòng kiểm tra hộp thư đến của bạn.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Đóng dialog
              Navigator.of(context).pop(); // Quay lại màn hình SignIn
            },
            child: const Text('Quay lại đăng nhập'),
          ),
        ],
      ),
    );
  }
}
