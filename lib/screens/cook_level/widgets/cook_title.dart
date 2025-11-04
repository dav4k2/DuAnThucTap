import 'package:flutter/material.dart';

class CookingTitle extends StatelessWidget {
  const CookingTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.08, vertical: 16),
      child: Column(
        children: const [
          Text(
            'Trình độ nấu ăn của bạn thế nào?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Chúng tôi sẽ đề xuất công thức nấu ăn dựa theo trình độ của bạn.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
