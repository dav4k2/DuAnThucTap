import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fontend/screens/explore/explore_screen.dart';
import 'package:fontend/screens/sign_in/sign_in_screen.dart';
import 'package:fontend/screens/sign_in/widgets/sign_in_form.dart';
import 'package:fontend/screens/welcome/welcome_screen.dart';

import 'auth_state_provider.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot){
        //Đang chờ kết nối
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        //Đã đăng nhập
        if(snapshot.hasData){
          return const ExploreScreen();
        }

        //Chưa đăng nhập
        return const SignInScreen();
      }
    );
  }
}