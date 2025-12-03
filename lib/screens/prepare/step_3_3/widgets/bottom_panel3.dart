import 'package:flutter/material.dart';
import 'time_text3.dart';
import 'action_buttons3.dart';
import 'divider3.dart';

class StepBottomPanel3 extends StatelessWidget {
  final Size size;

  const StepBottomPanel3({
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
        child: Stack(
          children: [
            // Tiêu đề "Sơ chế nguyên liệu"
            const Positioned(
              top: 30,
              left: 97,
              child: Text(
                "Chế nước dùng",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  fontFamily: "SF Pro Rounded",
                ),
              ),
            ),

            // Thời gian - tự động lấy từ provider
            const StepTimeText3(),

            // Nút hành động - tự động kết nối với provider
            const StepActionButtons3(),

            const StepDivider3(),
          ],
        ),
      ),
    );
  }
}