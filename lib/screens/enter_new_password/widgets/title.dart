import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TitleSection extends StatelessWidget {
  const TitleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned(

      child: _TitleText(),
    );
  }
}

class _TitleText extends StatelessWidget {
  const _TitleText();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 300.w,
          child: Text(
            'Nhập mật khẩu mới',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 32.sp,
              fontWeight: FontWeight.w700,
              height: 0.69,
            ),
          ),
        ),
        SizedBox(height: 20.h),
        SizedBox(
          width: 230.w,
          child: Text(
            'Mật khẩu mới của bạn phải khác so với mật khẩu cũ.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
              height: 1.47,
            ),
          ),
        ),
      ],
    );
  }
}
