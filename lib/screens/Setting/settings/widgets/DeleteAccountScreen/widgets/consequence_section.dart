// lib/screens/delete_account/widgets/consequence_section.dart
import 'package:flutter/material.dart';

class ConsequenceSection extends StatelessWidget {
  const ConsequenceSection({super.key});

  final List<String> _consequences = const [
    'Bạn sẽ không thể đăng nhập vào ứng dụng bằng tài khoản hiện tại',
    'Mọi bài đăng của bạn hay những tương tác trên ứng dụng sẽ bị xóa',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sau khi bạn đồng ý xóa tài khoản:',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, fontFamily: 'SF Pro'),
        ),
        const SizedBox(height: 20),
        ..._consequences.map((text) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8, right: 12),
                width: 7,
                height: 7,
                decoration: const ShapeDecoration(
                  color: Color(0xFFD9D9D9),
                  shape: OvalBorder(),
                ),
              ),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(fontSize: 16, fontFamily: 'SF Pro', height: 1.38),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }
}