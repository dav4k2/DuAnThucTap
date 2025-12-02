import 'package:flutter/material.dart';

class StepImage extends StatelessWidget {
  final double width;

  const StepImage({super.key, required this.width});

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
            image: AssetImage("image/p4.png"), // ảnh trong dự án
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
