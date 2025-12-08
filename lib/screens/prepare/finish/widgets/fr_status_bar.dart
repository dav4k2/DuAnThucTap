import 'package:flutter/material.dart';

class FRStatusBar extends StatelessWidget {
  const FRStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0, // Để 0 để SafeArea tự căn chỉnh từ mép trên
      left: 0,
      child: SafeArea(
        child: Padding(
          // 👇 Tăng left lên (ví dụ 25-30) để né góc bo tròn 50px
          // 👇 Thêm top một chút cho thoáng
          padding: const EdgeInsets.only(top: 10, left: 30),
          child: GestureDetector( // Thêm cái này nếu bạn muốn ấn vào nó quay lại được
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back, size: 28),
          ),
        ),
      ),
    );
  }
}