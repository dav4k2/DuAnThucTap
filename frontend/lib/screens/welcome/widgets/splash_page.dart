import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      // ✅ Kiểm tra widget còn mounted không
      if (!mounted) return;

      // ✅ Sau khi đảm bảo widget vẫn tồn tại, mới chuyển trang
      Navigator.pushReplacementNamed(context, '/welcome');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFB901),
      body: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 36),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              image: const DecorationImage(
                image: AssetImage("image/logo.png"),
                fit: BoxFit.cover,
              ),
            ),
            width: 300,
            height: 300,
          ),
        ),
      ),
    );
  }
}
