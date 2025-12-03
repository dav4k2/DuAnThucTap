import 'package:flutter/material.dart';

class FRPrimaryButton extends StatelessWidget {
  final VoidCallback onTap;

  const FRPrimaryButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 665,
      left: 16,
      right: 16,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 65,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFFFC107), // màu vàng giống ảnh
            borderRadius: BorderRadius.circular(35), // bo góc giống ảnh
          ),
          child: const Text(
            "Vâng, đến phần đánh giá",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,      // chữ màu đen như ảnh
              fontSize: 20,             // chữ nhỏ hơn 1 chút cho cân đối
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
