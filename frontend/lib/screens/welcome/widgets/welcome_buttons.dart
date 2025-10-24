import 'package:flutter/material.dart';
import 'package:frontend/screens/sign_in_&_sign_up/sign_in_screen.dart';

class WelcomeButtons extends StatelessWidget {
  const WelcomeButtons({super.key});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 380, height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const SignInScreen(initialTab: true))), // tab Sign In
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                    shadowColor: const Color(0x3F000000),
                    elevation: 4,
                    fixedSize: const Size.fromHeight(70)),
                child: const Text('Đăng nhập',
                    style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'SF Pro Rounded',
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.25)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const SignInScreen(initialTab: false))), // tab Sign Up
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.black.withOpacity(0.4)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                    shadowColor: const Color(0x3F000000),
                    elevation: 4,
                    fixedSize: const Size.fromHeight(70)),
                child: const Text('Đăng ký',
                    style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'SF Pro Rounded',
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        height: 1.25)),
              ),
            ),
          ],
        ),
      );
}
