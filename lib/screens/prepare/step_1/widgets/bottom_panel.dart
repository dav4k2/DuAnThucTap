import 'package:flutter/material.dart';
import 'time_text.dart';
import 'action_buttons.dart';
import 'divider.dart';

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
            bottom: Radius.zero, // ✅ Đã sửa: Vuông góc dưới để không hở trắng
          ),
        ),
        // Layout xếp dọc để Thời gian nằm giữa Text và Nút
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 25),

            // 1. Tiêu đề
            const Text(
              "Sơ chế nguyên liệu",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                fontFamily: "SF Pro Rounded",
              ),
            ),

            const Spacer(),

            // 2. Thời gian
            const StepTimeText1(),

            const Spacer(),

            // 3. Các nút bấm
            const StepActionButtons1(),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}