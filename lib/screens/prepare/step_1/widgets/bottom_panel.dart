import 'package:flutter/material.dart';
import 'time_text.dart';
import 'action_buttons.dart';
import 'divider.dart'; // Giữ lại nếu cần, hoặc bỏ nếu action_buttons đã xử lý

class StepBottomPanel1 extends StatelessWidget {
  final Size size;

  const StepBottomPanel1({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: size.height * 0.63,
      child: Container(
        width: size.width,
        height: size.height * 0.37,
        decoration: const BoxDecoration(
          color: Color(0xFFFDB803),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
            bottom: Radius.circular(50),
          ),
        ),
        // ✅ Dùng Column để layout không bị chồng chéo
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 25), // Padding top

            // 1. Tiêu đề
            const Text(
              "Sơ chế nguyên liệu",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                fontFamily: "SF Pro Rounded",
              ),
            ),

            // Spacer đẩy thời gian ra giữa
            const Spacer(),

            // 2. Thời gian (File time_text.dart đã sửa)
            const StepTimeText1(),

            // Spacer đẩy nút xuống dưới
            const Spacer(),

            // 3. Các nút bấm (File action_buttons.dart đã sửa)
            const StepActionButtons1(),

            const SizedBox(height: 30), // Padding bottom
          ],
        ),
      ),
    );
  }
}