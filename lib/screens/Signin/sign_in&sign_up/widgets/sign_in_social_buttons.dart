import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_provider.dart';

class SignInSocialButtons extends ConsumerWidget {
  const SignInSocialButtons({super.key});

  /// Xử lý login Google
  Future<void> _handleGoogleLogin(BuildContext context, WidgetRef ref) async {
    final authService = ref.read(authServiceProvider);
    final authNotifier = ref.read(authProvider.notifier);

    try {
      authNotifier.setError(null);

      final userCredential = await authService.signInWithGoogle();

      if (userCredential != null && userCredential.user != null) {
        final isCompleted = await authService.checkProfileCompletion(userCredential.user!.uid);

        if (context.mounted) {
          if (isCompleted) {
            Navigator.pushNamedAndRemoveUntil(context, '/authgate', (route) => false);
          } else {
            Navigator.pushNamedAndRemoveUntil(context, '/survey', (route) => false);
          }
        }
      } else {
        print("Đăng nhập Google bị hủy");
      }
    } catch (e) {
      authNotifier.setError("Đăng nhập Google thất bại: $e");
    }
  }

  /// Xử lý login Apple
  Future<void> _handleAppleLogin(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tính năng đang phát triển...')),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDarkMode ? Colors.grey[900] : const Color(0xFFEBEBEB);

    return Container(
      width: double.infinity,
      color: bgColor,
      padding: EdgeInsets.symmetric(vertical: size.height * 0.035),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SocialButton(
            iconPath: 'image/google_icon.png',
            text: 'Đăng nhập bằng Google',
            onTap: () => _handleGoogleLogin(context, ref),
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: 20),
          _SocialButton(
            iconPath: 'image/apple_logo.png',
            text: 'Đăng nhập với iCloud',
            onTap: () => _handleAppleLogin(context),
            isDarkMode: isDarkMode,
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
  final bool isDarkMode;

  const _SocialButton({
    required this.iconPath,
    required this.text,
    required this.onTap,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.8;
    final containerColor = isDarkMode ? Colors.grey[800] : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final borderColor = isDarkMode ? Colors.white70 : Colors.black;
    final shadowColor = isDarkMode ? Colors.black45 : const Color(0x26000000);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: width,
        height: 65,
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 4,
              offset: const Offset(0, 4),
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
                  style: TextStyle(
                    color: textColor,
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
