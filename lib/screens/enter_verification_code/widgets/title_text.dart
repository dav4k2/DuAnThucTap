import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TitleText extends StatelessWidget {
  const TitleText({super.key});

  @override
  Widget build(BuildContext context) {

    return Column(

      children: const [
        ///Xin chào
        SizedBox(
          width: 280,
          child: Text(
            'Nhập mã xác minh',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 32,
              fontWeight: FontWeight.w700,
              height: 0.69,
            ),
          )
        ),

        SizedBox(height: 20),

        ///Text chào mừng
        SizedBox(
          width: 370,
          child: Text(
            'Nếu email của bạn có trong cơ sở dữ liệu của chúng tôi, bạn sẽ nhận được một email chứa mã xác minh.\nNếu không thấy email, hãy kiểm tra cả hộp spam.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              height: 1.47,
            ),
          )
        ),
      ],
    );
  }
}
