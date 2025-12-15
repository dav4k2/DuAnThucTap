import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fontend/screens/survey/survey_0.dart';
import '../../../../Main_layout/main_layout.dart';
import '../../../../Service/user_service.dart';
import '../../../../Service/user_model.dart';
import '../sign_in_screen.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {

        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (!authSnapshot.hasData) {
          return const SignInScreen();
        }

        return FutureBuilder<UserModel?>(
          future: UserService().getUserProfile(),
          builder: (context, userSnapshot) {

            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }

            final user = userSnapshot.data;

            if (user == null) {
              FirebaseAuth.instance.signOut();
              return const SignInScreen();
            }

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