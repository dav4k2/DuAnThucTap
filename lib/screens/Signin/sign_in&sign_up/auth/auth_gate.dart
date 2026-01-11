// auth_gate.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fontend/screens/Start/welcome/welcome_screen.dart';
import 'package:fontend/screens/survey/survey_0.dart';
import '../../../../Main_layout/main_layout.dart';
import '../../../../Service/user_service.dart';
import '../../../../Service/user_model.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        // 1. Chờ Firebase Auth xác định trạng thái
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        // 2. Nếu chưa đăng nhập -> Về màn hình Welcome
        if (!authSnapshot.hasData || authSnapshot.data == null) {
          return const WelcomeScreen();
        }

        // 3. Đã đăng nhập -> Lấy thông tin User Profile từ Firestore
        return FutureBuilder<UserModel?>(
          // Mẹo: Truyền uid vào để đảm bảo Future được gọi lại khi user thay đổi
          future: UserService().getUserProfile(),
          builder: (context, userSnapshot) {

            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }

            // Xử lý lỗi nếu có
            if (userSnapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Text("Lỗi tải dữ liệu: ${userSnapshot.error}"),
                ),
              );
            }

            final user = userSnapshot.data;

            // --- KHU VỰC SỬA LỖI ---
            // Nếu user profile null (do mạng lag hoặc chưa tạo doc), ĐỪNG tự động sign out.
            // Hãy hiện thông báo để debug hoặc nút Retry.
            if (user == null) {
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Không tìm thấy thông tin người dùng."),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        // Chỉ đăng xuất khi người dùng chủ động bấm
                        onPressed: () => FirebaseAuth.instance.signOut(),
                        child: const Text("Quay lại màn hình chính (Đăng xuất)"),
                      ),
                    ],
                  ),
                ),
              );
            }
            // -----------------------

            if (user.isProfileCompleted == true) {
              return const MainLayout();
            } else {
              return const SurveyStartScreen();
            }
          },
        );
      },
    );
  }
}