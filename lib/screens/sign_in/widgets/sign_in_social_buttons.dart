import 'package:flutter/material.dart';

class SignInSocialButtons extends StatelessWidget {
  const SignInSocialButtons({super.key});

@override
Widget build(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final verticalPadding = size.height * 0.035; 

  return Container(
    width: double.infinity,
    color: const Color(0xFFEBEBEB),
    padding: EdgeInsets.symmetric(vertical: verticalPadding),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SocialButton(
          iconPath: 'image/google_icon.png',
          text: 'Đăng nhập bằng Google',
        ),
        SizedBox(height: size.height * 0.025), 
        _SocialButton(
          iconPath: 'image/apple_logo.png',
          text: 'Tiếp tục với iCloud',
        ),
      ],
    ),
  );
}
}




class _SocialButton extends StatelessWidget {
  final String iconPath;
  final String text;
  final double iconSize;

  const _SocialButton({required this.iconPath, required this.text, this.iconSize = 28});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 370, height: 65,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.black),
        boxShadow: const [BoxShadow(color: Color(0x26000000), blurRadius: 4, offset: Offset(0, 4))],
      ),
      child: Row(
        children: [
          const SizedBox(width: 20),
          Image.asset(iconPath, width: iconSize, height: iconSize),
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
    );
  }
}