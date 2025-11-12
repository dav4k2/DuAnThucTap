import 'package:flutter/material.dart';
import '../../sign_in/sign_in_screen.dart';

class WelcomeButtons extends StatelessWidget {
  const WelcomeButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return SizedBox(
      width: width * 0.9,
      height: width * 0.16, // button height
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          // Nút Đăng nhập
          _buildButton(
            context,
            label: 'Đăng nhập',
            backgroundColor: const Color(0xFFFFB901),
            borderColor: Colors.black,
            textColor: Colors.black,
            initialTab: true,
          ),

          SizedBox(width: width * 0.04), // spacing

          // Nút Đăng ký
          _buildButton(
            context,
            label: 'Đăng ký',
            backgroundColor: Colors.white,
            textColor: Colors.black,
            borderColor: Colors.black ,
            initialTab: false,
          ),
        ],
      ),
    );
  }

  Expanded _buildButton(
      BuildContext context, {
        required String label,
        required Color backgroundColor,
        required Color textColor,
        Color? borderColor,
        required bool initialTab,
      }) {
    final width = MediaQuery.of(context).size.width;
    final buttonHeight = width * 0.16;
    final fontSize = width * 0.06;
    final borderRadius = width * 0.12;

    return Expanded(
      child: ElevatedButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SignInScreen(initialTab: initialTab),
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          side: borderColor != null ? BorderSide(color: borderColor,width: 2) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          shadowColor: const Color(0x3F000000),
          elevation: 4,
          fixedSize: Size.fromHeight(buttonHeight),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontFamily: 'SF Pro Rounded',
            fontWeight: FontWeight.w700,
            color: textColor,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}
