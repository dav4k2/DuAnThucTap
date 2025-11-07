import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fontend/screens/explore/explore_screen.dart';
import 'package:fontend/screens/sign_in/sign_in_screen.dart';
import 'package:fontend/screens/sign_in/widgets/sign_in_form.dart';
import 'package:fontend/screens/welcome/welcome_screen.dart';

import '../../../Main_layout/main_layout.dart';
import 'auth_state_provider.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(authStateProvider);
    if (userAsync.isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (userAsync.value != null) {
      return const MainLayout();
    } else {
      return const SignInForm();
    }
  }
}