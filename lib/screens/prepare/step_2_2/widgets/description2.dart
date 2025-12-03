import 'package:flutter/material.dart';

class StepDescription2 extends StatelessWidget {
  const StepDescription2({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      top: 212,
      left: 22,
      right: 22,
      child: Text(
        'Thêm nước vào nồi, đun đến khi sôi thì vớt hết bọt, thêm gói vị phở rồi ninh 30p',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          height: 1.38,
          color: Colors.black87,
        ),
      ),
    );
  }
}