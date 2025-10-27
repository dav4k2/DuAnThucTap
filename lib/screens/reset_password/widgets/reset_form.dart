import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../reset_provider.dart';

class ResetForm extends ConsumerWidget {
  const ResetForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailOrPhone = ref.watch(emailProvider);
    final controller = TextEditingController(text: emailOrPhone);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nhập email/sđt nhận mã xác minh',
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'SF Pro Rounded',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFEBEBEB),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.black.withOpacity(0.4)),
          ),
          child: TextField(
            controller: controller,
            onChanged: (value) => ref.read(emailProvider.notifier).state = value,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              border: InputBorder.none,
              hintText: 'Email/SĐT',
              hintStyle: TextStyle(
                color: Colors.black54,
                fontSize: 18,
                fontFamily: 'SF Pro Rounded',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
