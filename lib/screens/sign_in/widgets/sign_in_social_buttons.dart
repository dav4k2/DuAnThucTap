///Sơn
/// Trang login với google/icloud

import 'package:flutter/material.dart';

class SignInSocialButtons extends StatelessWidget {
  const SignInSocialButtons({super.key});

  ///Xử lý login google với icloud
  Future<void> _handleGoogleLogin(BuildContext context) async {
    // TODO: Gọi Google SDK hoặc API backend để login
    debugPrint('Google login pressed');

    //Test nút
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đang xử lý đăng nhập Google...')),
    );
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
  Widget build(BuildContext context) {
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
            onTap: () => _handleGoogleLogin(context),
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
