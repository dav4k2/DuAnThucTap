import 'package:flutter/material.dart';

class StepImage3 extends StatelessWidget {
  final double width;

  const StepImage3({super.key, required this.width});

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
            image: AssetImage("image/p1.png"), 
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}