import 'package:flutter/material.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center, // 👈 Căn giữa toàn form
      children: [
        _buildInput('Địa chỉ email'),
        const SizedBox(height: 20),
        _buildInput('Mật khẩu'),
        const SizedBox(height: 20),
        _buildInput('Nhập lại mật khẩu'),
        const SizedBox(height: 10),



        _buildButton('Đăng ký', isPrimary: true),


        
      ],
    );
  }

  Widget _buildInput(String placeholder) {
    return Container(
      width: 370,
      height: 65,
      decoration: BoxDecoration(
        color: const Color(0xFFEBEBEB),
        border: Border.all(color: Colors.black.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(50),
      ),
      alignment: Alignment.centerLeft, // 👈 căn trái text
      padding: const EdgeInsets.symmetric(horizontal: 20), // 👈 cách lề 2 bên
      child: Text(
        placeholder,
        style: TextStyle(
          color: Colors.black.withOpacity(0.3),
          fontSize: 24,
          fontFamily: 'SF Pro Rounded',
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildButton(String text, {bool isPrimary = false}) {
    return Container(
      width: 370,
      height: 65,
      decoration: BoxDecoration(
        color: isPrimary ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.black.withOpacity(0.4)),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          color: isPrimary ? Colors.white : Colors.black,
          fontSize: 24,
          fontFamily: 'SF Pro Rounded',
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
