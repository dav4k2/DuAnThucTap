import 'package:flutter/material.dart';

class AuthMessage extends StatelessWidget {
  const AuthMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.12),
      child: const Text(
        'Vui lòng đăng nhập để sử dụng tính năng này',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.57,
        ),
      ),
    );
  }
}
