/// Sơn
/// Trang Tab ĐN/ĐK

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignInTabs extends StatefulWidget {
  final bool initialTab;
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
    isSignIn = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    final textSize = 30.sp;
    final underlineThickness = 2.3.h;
    final spacing = 20.w;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// Tab đăng nhập / đăng ký
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


        /// Thanh trượt (gạch đen dưới tab)
        AnimatedAlign(
          duration: const Duration(milliseconds: 300),
          alignment: isSignIn ? Alignment.centerLeft : Alignment.centerRight,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: EdgeInsets.symmetric(horizontal: 33.w),
            width: isSignIn ? 150.w : 110.w,
            height: underlineThickness,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
