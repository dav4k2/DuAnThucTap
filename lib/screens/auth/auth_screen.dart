import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'logic/auth_provider.dart';
import 'widgets/auth_background.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    final currentMode = ref.watch(authModeProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: AuthBackground(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// --- Nút quay lại ---
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                ),

                SizedBox(height: height * 0.05),

                /// --- Icon người dùng ---
                Center(
                  child: Icon(
                    Icons.person,
                    size: height * 0.15,
                    color: Colors.black,
                  ),
                ),

                SizedBox(height: height * 0.03),

                /// --- Dòng hướng dẫn ---
                const Center(
                  child: Text(
                    'Vui lòng đăng nhập để sử dụng tính năng này',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                  ),
                ),

                SizedBox(height: height * 0.04),

                /// --- Nút Đăng nhập ---
                GestureDetector(
                  onTap: () =>
                  ref.read(authModeProvider.notifier).state = AuthMode.login,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFB800),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: const Text(
                      'Đăng nhập',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: height * 0.015),

                /// --- Dòng phụ ---
                const Center(
                  child: Text(
                    'nếu chưa có tài khoản',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                SizedBox(height: height * 0.015),

                /// --- Nút Đăng ký ---
                GestureDetector(
                  onTap: () =>
                  ref.read(authModeProvider.notifier).state = AuthMode.register,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC6C6C6),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text(
                      'Đăng ký',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                /// --- Thanh nhỏ ở dưới cùng ---
                Center(
                  child: Container(
                    width: 134,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),

                SizedBox(height: height * 0.01),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
