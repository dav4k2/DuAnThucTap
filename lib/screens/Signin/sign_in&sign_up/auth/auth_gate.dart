import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fontend/screens/Signin/sign_in&sign_up/auth/storage_service.dart';
import 'package:fontend/screens/survey/survey_0.dart';
import '../../../../Main_layout/main_layout.dart';
import '../../../../Service/user_service.dart';
import '../../../survey/survey_flow_screen.dart';
import '../sign_in_screen.dart'; // Import màn hình đăng nhập
import 'storage_service.dart'; // Import service lưu token

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  // Tạo hàm check logic tách biệt
  Future<int> _checkAuthState() async {
    final token = await StorageService.getToken();
    if (token == null) return 0; // 0: Chưa đăng nhập

    // Có token -> Check tiếp profile đã completed chưa
    final user = await UserService().getUserProfile();
    if (user == null) return 0; // Token lỗi hoặc hết hạn

    if (user.isProfileCompleted) {
      return 1; // 1: Đã đăng nhập & Đã xong profile -> Vào Main
    } else {
      return 2; // 2: Đã đăng nhập & CHƯA xong profile -> Vào Survey
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<int>(
      future: _checkAuthState(),
      builder: (context, snapshot) {
        // 1. Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(), // Màn hình chờ
            ),
          );
        }

        // 2. Điều hướng dựa trên kết quả
        final state = snapshot.data ?? 0;

        if (state == 1) {
          return const MainLayout(); // Đã xong hết -> Vào App chính
        } else if (state == 2) {
          return SurveyStartScreen(); // Chưa xong survey -> Vào Survey
        } else {
          return const SignInScreen(); // Chưa đăng nhập -> Vào Login
        }
      },
    );
  }
}