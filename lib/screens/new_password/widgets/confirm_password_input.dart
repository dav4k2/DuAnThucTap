import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../logic/password_provider.dart';

final _obscureConfirmProvider = StateProvider<bool>((ref) => true);

class ConfirmPasswordInput extends ConsumerWidget {
  const ConfirmPasswordInput({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final confirm = ref.watch(confirmPasswordProvider);
    final obscure = ref.watch(_obscureConfirmProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nhập lại mật khẩu',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 10),
        TextField(
          obscureText: obscure,
          obscuringCharacter: '•',
          onChanged: (val) =>
          ref.read(confirmPasswordProvider.notifier).state = val,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(
                obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: Colors.black54,
              ),
              onPressed: () =>
              ref.read(_obscureConfirmProvider.notifier).state = !obscure,
            ),
            filled: true,
            fillColor: const Color(0xFFEDEDED),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(color: Colors.black.withOpacity(0.3)),
            ),
            hintText: 'Nhập lại mật khẩu',
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
        ),
      ],
    );
  }
}
