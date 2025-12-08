// lib/screens/chat/widgets/chat_input_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isDark;

  const ChatInputBar({Key? key, required this.controller, required this.onSend, required this.isDark}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputColor = isDark ? Colors.grey[800] : Colors.grey[100];
    final textColor = isDark ? Colors.white : Colors.black87;

    return Container(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: inputColor,
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: TextField(
                controller: controller,
                style: TextStyle(color: textColor),
                maxLines: null,
                textInputAction: TextInputAction.send,
                decoration: InputDecoration(
                  hintText: 'Nhập nguyên liệu hoặc món ăn...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
                ),
                onSubmitted: (_) => onSend(),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          GestureDetector(
            onTap: onSend,
            child: CircleAvatar(
              radius: 22.r,
              backgroundColor: const Color(0xFFFFB901),
              child: const Icon(Icons.arrow_upward, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}