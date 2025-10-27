import 'package:flutter/material.dart';

class WelcomeBackground extends StatelessWidget {
  const WelcomeBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;


    final topWhite = height * 0.55;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFFFB901), // nền vàng
      ),
      child: Stack(
        children: [
          // Phần trắng bên dưới
          Positioned(
            top: topWhite,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFEBEBEB),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(width * 0.12),
                  topRight: Radius.circular(width * 0.12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
