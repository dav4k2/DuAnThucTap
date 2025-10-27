import 'package:flutter/material.dart';

class ResetButton extends StatelessWidget {
  final VoidCallback onPressed;
  const ResetButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 65,
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(vertical: 32),
        decoration: BoxDecoration(
          color: Colors.amberAccent,
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Text(
          'Xác nhận',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontFamily: 'SF Pro Rounded',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
