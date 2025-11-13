import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../logic/auth_provider.dart';

class AuthloginButton extends ConsumerWidget {
  const AuthloginButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMode = ref.watch(authModeProvider);

    return GestureDetector(
      onTap: () => ref.read(authModeProvider.notifier).state = AuthMode.login,
      child: Text(
        'Đăng nhập',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: currentMode == AuthMode.login ? Colors.black : Colors.grey,
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
