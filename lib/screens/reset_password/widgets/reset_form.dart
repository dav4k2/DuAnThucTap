import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../logic/reset_provider.dart';

class ResetForm extends ConsumerStatefulWidget {
  const ResetForm({super.key});

  @override
  ConsumerState<ResetForm> createState() => _ResetFormState();
}

class _ResetFormState extends ConsumerState<ResetForm> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(
      text: ref.read(emailProvider),
    );

    // Lắng nghe thay đổi trong controller và cập nhật provider
    controller.addListener(() {
      ref.read(emailProvider.notifier).state = controller.text;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              border: InputBorder.none,
              hintText: 'Email/SĐT',
              hintStyle: TextStyle(
                color: Colors.black54,
                fontSize: 20,
                fontFamily: 'SF Pro Rounded',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
