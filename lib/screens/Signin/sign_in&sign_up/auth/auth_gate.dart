import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../Main_layout/main_layout.dart';
import '../../signup_successfully/success_screen.dart';
import 'auth_state_provider.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Màn hình chờ
        }
        if (snapshot.hasData) {
          // Đã đăng nhập
          return MainLayout();
        }
        // Chưa đăng nhập
        return SuccessScreen();
      },
    );
  }
}