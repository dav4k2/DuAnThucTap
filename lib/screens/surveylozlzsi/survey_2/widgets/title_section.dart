import 'package:flutter/material.dart';

class TitleSection extends StatelessWidget {
  const TitleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SizedBox(height: 141),
        Text(
          'Bạn quan tâm tới\nnhững công thức nào',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 15),
        Text(
          'Chọn một hoặc nhiều công thức bạn quan tâm',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
