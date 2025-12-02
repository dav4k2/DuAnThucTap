import 'package:flutter/material.dart';

class StepImage1 extends StatelessWidget {
  final Size size;

  const StepImage1({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 270,
      left: size.width * 0.12,
      child: Container(
        width: size.width * 0.76,
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F000000),   // đen chỉ ~6% opacity → siêu nhẹ
              offset: Offset(0, 4),       // lệch xuống 4px (chỉ thấy bóng dưới)
              blurRadius: 10,             // mờ tự nhiên
              spreadRadius: 0,   // đen chỉ 8% độ trong suốt → siêu nhẹ, tự nhiên
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            "image/p4.png",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}