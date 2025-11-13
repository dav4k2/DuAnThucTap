///Sơn
///Text chào mừng
import 'package:flutter/material.dart';

class WelcomeTexts extends StatelessWidget {
  const WelcomeTexts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        ///Xin chào
        SizedBox(
          width: 264,
          child: Text(
            'Xin Chào !',
            style: TextStyle(
              color: Colors.black,
              fontSize: 36,
              fontFamily: 'SF Pro Rounded',
              fontWeight: FontWeight.w700,
              height: 0.61,
            ),
          ),
        ),

        SizedBox(height: 20),

        ///Text chào mừng
        SizedBox(
          width: 370,
          child: Text(
            'Mỗi công thức là một cuộc phiêu lưu vị giác.\n'
            'Sẵn sàng khám phá và tạo nên những món ăn mang dấu ấn của riêng bạn.',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: 'SF Pro Rounded',
              fontWeight: FontWeight.w700,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
