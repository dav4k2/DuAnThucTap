import 'package:flutter/material.dart';
import 'step_timer_circle.dart';

class StepBottomCard extends StatelessWidget {
  final double width;
  final double height;

  const StepBottomCard({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        width: width,
        height: height * 0.35,
        decoration: const BoxDecoration(
          color: Color(0xFFFDB803),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
            bottom: Radius.zero, // ✅ Đã sửa: Vuông góc dưới
          ),
        ),
        child: Stack(
          children: const [
            Positioned(
              top: 20,
              left: 20,
              child: Text(
                "Hãy sẵn sàng cho bước tiếp theo!",
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
              ),
            ),
            Positioned(
              top: 70,
              left: 100,
              child: Text(
                "Sơ chế nguyên liệu",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            // Vòng tròn đếm ngược (đã căn chỉnh ở file step_timer_circle.dart)
            StepTimerCircle(),
          ],
        ),
      ),
    );
  }
}