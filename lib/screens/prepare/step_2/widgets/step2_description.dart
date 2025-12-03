import 'package:flutter/material.dart';

class StepDescription2 extends StatelessWidget {
  const StepDescription2({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      top: 215,
      left: 20,
      right: 20,
      child: Text(
        "Thêm nước vào nồi, đun đến khi sôi thì vớt hết bọt, thêm gói vị phở rồi ninh 30p",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, height: 1.3),
      ),
    );
  }
}