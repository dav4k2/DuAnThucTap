//Giải thích chức năng và hướng dẫn nhập email
import 'package:flutter/material.dart';

class ResetHeader extends StatelessWidget {
  const ResetHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text(
          'Nhập Email hoặc SĐT \ncủa bạn',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 32,
            fontFamily: 'SF Pro',
            fontWeight: FontWeight.w600,
            height: 1.16,
          ),
        ),
        SizedBox(height: 12),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Nhập Email hoặc số điện thoại bạn đã dùng để đăng ký tài khoản, để nhận mã xác minh cho yêu cầu cập nhật mật khẩu của bạn.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 15,
              height: 1.47,
            ),
          ),
        ),
      ],
    );
  }
}
