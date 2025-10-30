import 'package:flutter/material.dart';

class BottomIndicator extends StatelessWidget {
  const BottomIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Khoảng cách với mép dưới màn hình
      margin: const EdgeInsets.only(bottom: 12),

      // Kích thước thanh chỉ báo (home indicator)
      width: 140,
      height: 5,

      // Bo tròn hai đầu và tô màu đen
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }
}
