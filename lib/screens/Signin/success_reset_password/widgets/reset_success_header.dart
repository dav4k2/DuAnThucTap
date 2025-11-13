import 'package:flutter/material.dart';

class ResetSuccessHeader extends StatelessWidget {
  const ResetSuccessHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Bạn đã đổi mật khẩu\nthành công',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.black,
        fontSize: MediaQuery.of(context).size.width * 0.08, // responsive
        fontWeight: FontWeight.w600,
        height: 1.2,
      ),
    );
  }
}
