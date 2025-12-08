// lib/screens/chat/widgets/empty_chat_state.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyChatState extends StatelessWidget {
  final bool isDark;
  const EmptyChatState({Key? key, required this.isDark}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : Colors.black87;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant, size: 48.r, color: Colors.grey),
          SizedBox(height: 16.h),
          Text(
            "Tôi có thể giúp gì cho bạn hôm nay?",
            style: TextStyle(fontSize: 16.sp, color: textColor, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}