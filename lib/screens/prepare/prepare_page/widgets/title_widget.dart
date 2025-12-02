import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Nút Back ở góc trên bên trái
        Padding(
          padding: const EdgeInsets.only(top: 50, left: 20),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back,     // icon giống như hình bạn gửi
              size: 30,
              color: Colors.black,
            ),
          ),
        ),

        // Tiêu đề
        const Padding(
          padding: EdgeInsets.only(top: 20, left: 31),
          child: Text(
            'Hãy chuẩn bị nguyên liệu cần thiết',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
