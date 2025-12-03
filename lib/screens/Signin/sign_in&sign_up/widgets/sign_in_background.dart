import 'package:flutter/material.dart';

class SignInBackground extends StatelessWidget {
  final Widget child;

  const SignInBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Phần trắng phía dưới sẽ đổi màu khi dark mode
    final bottomColor = isDarkMode ? Colors.grey[900] : Colors.white;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFFFC107), // Giữ nguyên màu vàng trên
      ),
      child: Stack(
        children: [
          // phần trắng phía dưới
          Positioned(
            top: 180,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: bottomColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
            ),
          ),

          child,
        ],
      ),
    );
  }
}
