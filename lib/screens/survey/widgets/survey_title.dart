
import 'package:flutter/material.dart';

class SurveyTitle extends StatelessWidget {
  const SurveyTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      left: 19,
      top: 132,
      child: SizedBox(
        width: 364,
        child: Text(
          'Hoàn tất hồ sơ nấu ăn của bạn để nhận công thức chuẩn gu!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 36,
            fontFamily: 'SF Pro',
            fontWeight: FontWeight.w600,
            height: 1.17,
            letterSpacing: -0.5,
            decoration: TextDecoration.none,
            shadows: [Shadow(color: Colors.transparent)],
          ),
        ),
      ),
    );
  }
}