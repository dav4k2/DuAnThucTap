import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:CookingHub/screens/Signin/sign_in&sign_up/auth/storage_service.dart';
import '../../../../Main_layout/main_layout.dart';
import '../sign_in_screen.dart'; // Import màn hình đăng nhập
import 'storage_service.dart'; // Import service lưu token

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Sử dụng FutureBuilder để chờ việc kiểm tra Token
    return FutureBuilder<String?>(
      future: StorageService.getToken(), // Gọi hàm lấy token từ bộ nhớ
      builder: (context, snapshot) {

        // 1. TRẠNG THÁI ĐANG KIỂM TRA (Loading)
        // Đây chính là "Màn hình chờ" của bạn
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text("Đang tải dữ liệu..."),
                ],
              ),
            ),
          );
        }

        // 2. TRẠNG THÁI ĐÃ CÓ TOKEN (Đã đăng nhập)
        if (snapshot.hasData && snapshot.data != null) {
          return const MainLayout();
        }

        // 3. TRẠNG THÁI CHƯA CÓ TOKEN (Chưa đăng nhập)
        // Thường sẽ trả về SignInScreen để người dùng đăng nhập
        return const SignInScreen();
      },
    );
  }
}