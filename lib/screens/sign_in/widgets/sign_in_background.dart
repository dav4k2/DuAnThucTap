import 'package:flutter/material.dart';

class SignInBackground extends StatelessWidget {
  final Widget child;

  const SignInBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFFFB901), // nền vàng
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
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
            ),
          ),

          // child ở trên hết, để SignInScreen tự bố trí
          child,
        ],
      ),
    );
  }
}
