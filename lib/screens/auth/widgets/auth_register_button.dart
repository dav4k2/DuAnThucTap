import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../logic/auth_provider.dart';

class AuthRegisterButton extends ConsumerWidget {
  const AuthRegisterButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMode = ref.watch(authModeProvider);

    return GestureDetector(
      onTap: () => ref.read(authModeProvider.notifier).state = AuthMode.register,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: currentMode == AuthMode.register ? Colors.black : Colors.grey[600],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'Đăng ký',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
