import 'package:flutter/material.dart';

class StepImage2 extends StatelessWidget {
  final double width;

  const StepImage2({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 310,
      left: width * 0.16,
      child: Container(
        width: width * 0.65,
        height: width * 0.45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          image: const DecorationImage(
            image: AssetImage("image/p3.png"), // ảnh trong dự án
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}