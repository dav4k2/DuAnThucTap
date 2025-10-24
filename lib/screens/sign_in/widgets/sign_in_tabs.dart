import 'package:flutter/material.dart';

class SignInTabs extends StatefulWidget {
  const SignInTabs({super.key, required this.onTabChanged});

  final Function(bool isSignIn) onTabChanged;

  @override
  State<SignInTabs> createState() => _SignInTabsState();
}

class _SignInTabsState extends State<SignInTabs> {
  bool isSignIn = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                setState(() => isSignIn = true);
                widget.onTabChanged(true);
              },
              child: Text(
                'Đăng nhập',
                style: TextStyle(
                  color: isSignIn
                      ? Colors.black
                      : Colors.black.withOpacity(0.15),
                  fontSize: 32,
                  fontFamily: 'SF Pro Rounded',
                  fontWeight: FontWeight.w700,
                  height: 0.61,
                ),
              ),
            ),
            const SizedBox(width: 20),
            GestureDetector(
              onTap: () {
                setState(() => isSignIn = false);
                widget.onTabChanged(false);
              },
              child: Text(
                'Đăng ký',
                style: TextStyle(
                  color: isSignIn
                      ? Colors.black.withOpacity(0.15)
                      : Colors.black,
                  fontSize: 32,
                  fontFamily: 'SF Pro Rounded',
                  fontWeight: FontWeight.w700,
                  height: 0.61,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        AnimatedAlign(
          duration: const Duration(milliseconds: 300),
          alignment: isSignIn ? Alignment.centerLeft : Alignment.centerRight,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            width: isSignIn ? 170 : 125, // 👈 chỉnh tay theo độ dài chữ
            height: 2,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
