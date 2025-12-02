// lib/screens/delete_account/widgets/other_reason_input.dart
import 'package:flutter/material.dart';

class OtherReasonInput extends StatelessWidget {
  final bool isVisible;
  final TextEditingController controller;
  final int maxLength;
  final ValueChanged<String> onChanged;

  const OtherReasonInput({
    super.key,
    required this.isVisible,
    required this.controller,
    required this.maxLength,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xB5E5E4E4),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: controller,
            maxLines: 5,
            maxLength: maxLength,
            decoration: const InputDecoration(
              hintText: 'Nếu có thể hãy chia sẻ lý do với chúng tôi (tối đa 200 ký tự)',
              hintStyle: TextStyle(color: Colors.black54, fontSize: 14),
              border: InputBorder.none,
              counterText: '',
            ),
            onChanged: onChanged,
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '${controller.text.length}/$maxLength',
            style: const TextStyle(color: Colors.black54, fontSize: 14),
          ),
        ),
      ],
    );
  }
}