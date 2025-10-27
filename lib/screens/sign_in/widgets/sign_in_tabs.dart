import 'package:flutter/material.dart';

class SignInTabs extends StatefulWidget {
  final bool initialTab; // ✅ thêm trạng thái tab ban đầu
  final Function(bool isSignIn) onTabChanged;

  const SignInTabs({
    super.key,
    required this.onTabChanged,
    this.initialTab = true, // true = đăng nhập, false = đăng ký
  });

  @override
  State<SignInTabs> createState() => _SignInTabsState();
}

class _SignInTabsState extends State<SignInTabs> {
  late bool isSignIn;

  @override
  void initState() {
    super.initState();
    isSignIn = widget.initialTab; //
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textSize = size.width * 0.075; // responsive theo chiều rộng
    final underlineThickness = size.height * 0.0025;
    final spacing = size.width * 0.05; // khoảng cách giữa 2 tab

    return Column(
      mainAxisSize: MainAxisSize.min,
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
                  color:
                      isSignIn ? Colors.black : Colors.black.withOpacity(0.15),
                  fontSize: textSize,
                  fontFamily: 'SF Pro Rounded',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(width: spacing),
            GestureDetector(
              onTap: () {
                setState(() => isSignIn = false);
                widget.onTabChanged(false);
              },
              child: Text(
                'Đăng ký',
                style: TextStyle(
                  color:
                      isSignIn ? Colors.black.withOpacity(0.15) : Colors.black,
                  fontSize: textSize,
                  fontFamily: 'SF Pro Rounded',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: size.height * 0.00002),
        AnimatedAlign(
          duration: const Duration(milliseconds: 300),
          alignment: isSignIn ? Alignment.centerLeft : Alignment.centerRight,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: EdgeInsets.symmetric(horizontal: size.width * 0.039),
            width: isSignIn
                ? size.width * 0.41 // Đăng nhập
                : size.width * 0.3, // Đăng ký
            height: underlineThickness,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
