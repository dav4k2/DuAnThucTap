import 'package:flutter/material.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      _buildInput('Tài khoản'), const SizedBox(height: 20),
      _buildInput('Mật khẩu', obscure: true), const SizedBox(height: 10),
      Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ForgotPasswordScreen())),
            child: const Text('Quên mật khẩu ?', style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'SF Pro Rounded', fontWeight: FontWeight.w600, decoration: TextDecoration.underline)),
          ),
        ),
      ),
      const SizedBox(height: 30),
      GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen())),
        child: _buildButton('Đăng nhập', isPrimary: true),
      ),
      const SizedBox(height: 20),
      GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => GuestHomeScreen())),
        child: const Text('Đăng nhập với tư cách khách', textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'SF Pro Rounded', fontWeight: FontWeight.w600, decoration: TextDecoration.underline)),
      ),
    ]);
  }

  Widget _buildInput(String placeholder, {bool obscure = false}) {
    return Container(
      width: 370, height: 65, alignment: Alignment.centerLeft, padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(color: const Color(0xFFEBEBEB), border: Border.all(color: Colors.black.withOpacity(0.4)), borderRadius: BorderRadius.circular(50)),
      child: TextField(obscureText: obscure, decoration: InputDecoration(border: InputBorder.none, hintText: placeholder, hintStyle: TextStyle(color: Colors.black.withOpacity(0.3), fontSize: 24, fontFamily: 'SF Pro Rounded', fontWeight: FontWeight.w700))),
    );
  }

  Widget _buildButton(String text, {bool isPrimary = false}) {
    return Container(
      width: 370, height: 65, alignment: Alignment.center,
      decoration: BoxDecoration(color: isPrimary ? Colors.black : Colors.white, borderRadius: BorderRadius.circular(50), border: Border.all(color: Colors.black.withOpacity(0.4))),
      child: Text(text, style: TextStyle(color: isPrimary ? Colors.white : Colors.black, fontSize: 24, fontFamily: 'SF Pro Rounded', fontWeight: FontWeight.w700)),
    );
  }
}

// Dummy screens để ví dụ, bạn thay bằng screen thật
class ForgotPasswordScreen extends StatelessWidget { @override Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Forgot Password')));}
class HomeScreen extends StatelessWidget { @override Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Home')));}
class GuestHomeScreen extends StatelessWidget { @override Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Guest Home')));}
