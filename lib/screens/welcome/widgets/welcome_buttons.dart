import 'package:flutter/material.dart';
import '../../sign_in/sign_in_screen.dart';

class WelcomeButtons extends StatelessWidget {
  const WelcomeButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;

    // ✅ responsive font và chiều cao
    final buttonHeight = width * 0.16; // 16% chiều rộng
    final fontSize = width * 0.06; // 6% chiều rộng (vd iPhone 390px → ~23.4)
    final spacing = width * 0.04; // 4% khoảng cách giữa 2 nút
    final borderRadius = width * 0.12; // bo góc tỉ lệ

    return SizedBox(
      width: width * 0.9, // chiếm 90% màn hình
      height: buttonHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 🔹 Nút Đăng nhập
          Expanded(
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SignInScreen(initialTab: true),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                shadowColor: const Color(0x3F000000),
                elevation: 4,
                fixedSize: Size.fromHeight(buttonHeight),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Đăng nhập',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontFamily: 'SF Pro Rounded',
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(width: spacing),

          // 🔹 Nút Đăng ký
          Expanded(
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SignInScreen(initialTab: false),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.black.withOpacity(0.4)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                shadowColor: const Color(0x3F000000),
                elevation: 4,
                fixedSize: Size.fromHeight(buttonHeight),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Đăng ký',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontFamily: 'SF Pro Rounded',
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    height: 1.2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
