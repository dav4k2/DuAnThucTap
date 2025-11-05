///Sơn
/// Trang login với google/icloud

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_provider.dart';

class SignInSocialButtons extends ConsumerWidget {
  const SignInSocialButtons({super.key});

  ///Xử lý login google với icloud
  Future<void> _handleGoogleLogin(BuildContext context, WidgetRef ref) async {
    // Lấy services và notifiers
    final authService = ref.read(authServiceProvider);
    final authNotifier = ref.read(authProvider.notifier);

    try {
      // Xóa lỗi cũ (nếu có)
      authNotifier.setError(null);

      // Thực hiện đăng nhập Google
      final userCredential = await authService.signInWithGoogle();

      // Đăng nhập thành công!
      // AuthGate sẽ tự động xử lý việc chuyển hướng
      // đến ExploreScreen vì authStateProvider đã thay đổi.
      if (userCredential != null) {
        // Đăng nhập thành công, chuyển hướng sang trang chính
        Navigator.pushReplacementNamed(context, '/explore');
      } else {
        // Đăng nhập bị hủy hoặc thất bại
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng nhập Google bị hủy hoặc thất bại')),
        );
      }

    } on Exception catch (e) {
      // Xử lý lỗi
      final errorMessage = e.toString().contains(':')
          ? e.toString().split(': ').last
          : 'Đăng nhập Google không thành công.';
      authNotifier.setError(errorMessage);
    }
  }

  Future<void> _handleAppleLogin(BuildContext context) async {
    // TODO: Gọi Apple Sign-In SDK hoặc API backend để login
    debugPrint('Apple login pressed');

    // cửa sổ test nút
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đang xử lý đăng nhập iCloud...')),
    );
  }

  ///Xắp xếp widget
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      color: const Color(0xFFEBEBEB),
      padding: EdgeInsets.symmetric(vertical: size.height * 0.035),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SocialButton(
            iconPath: 'image/google_icon.png',
            text: 'Đăng nhập bằng Google',
            onTap: () => _handleGoogleLogin(context, ref),
          ),
          const SizedBox(height: 20),
          _SocialButton(
            iconPath: 'image/apple_logo.png',
            text: 'Đăng nhập với iCloud',
            onTap: () => _handleAppleLogin(context),
          ),
        ],
      ),
    );
  }
}

/// Widget nút đăng nhập Google / iCloud
class _SocialButton extends StatelessWidget {
  final String iconPath;
  final String text;
  final VoidCallback onTap;

  const _SocialButton({
    required this.iconPath,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.8;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: width,
        height: 65,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Colors.black),
          boxShadow: const [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 4,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 20),
            Image.asset(iconPath, width: 28, height: 28),
            Expanded(
              child: Center(
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'SF Pro Rounded',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
          ],
        ),
      ),
    );
  }
}
