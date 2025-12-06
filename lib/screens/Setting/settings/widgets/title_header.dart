// lib/widgets/title_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TitleHeader extends StatelessWidget {
  const TitleHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // Thêm check null an toàn để tránh crash màu
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyMedium?.color ?? (theme.brightness == Brightness.dark ? Colors.white : Colors.black);

    // SỬA: Thay Positioned bằng Container/Padding
    return Container(
      width: double.infinity, // Chiếm hết chiều ngang
      padding: EdgeInsets.only(top: 20.h, bottom: 10.h), // Căn lề trên dưới thay vì top: 65.h
      alignment: Alignment.center, // Căn giữa chữ
      child: Text(
        'Cài đặt',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: textColor,
          fontSize: 24.sp,
          fontFamily: 'SF Pro',
          fontWeight: FontWeight.w700,
          height: 0.92,
        ),
      ),
    );
  }
}