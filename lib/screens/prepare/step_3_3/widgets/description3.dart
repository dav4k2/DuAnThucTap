import 'package:flutter/material.dart';

class StepDescription3 extends StatelessWidget {
  const StepDescription3({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      top: 212,
      left: 22,
      right: 22,
      child: Text(
        'Cho bánh phở vào bát, thêm hành mùi vào, nhúng thịt bò vào nước sôi cho chín tái, bày ra bát, sau đó chan nước dùng nóng lên rồi thưởng thức',
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