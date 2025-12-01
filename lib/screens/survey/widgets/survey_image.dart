// lib/screens/survey/widgets/survey_image.dart
import 'package:flutter/material.dart';

class SurveyImage extends StatelessWidget {
  const SurveyImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 95.8,
      top:350,
      child: Transform.rotate(
        angle: 0.23, // khoảng 13 độ
        child: Container(
          width: 256,
          height: 178,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: const DecorationImage(
              image: AssetImage("image/survey.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
