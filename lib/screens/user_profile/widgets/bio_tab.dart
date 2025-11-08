// lib/widgets/bio_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BioTab extends StatelessWidget {
  const BioTab({super.key});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 43.w,
      top: 594.h,
      child: SizedBox(
        width: 322.w,
        child: Text(
          "Kong Fuong là đầu bếp chuyên nghiệp với hơn 10 năm kinh nghiệm. "
              "Anh nổi tiếng với các món gà rán giòn tan và bánh mì kẹp sáng tạo. "
              "Hiện đang sở hữu 3 nhà hàng tại TP.HCM.",
          style: TextStyle(fontSize: 14.sp, height: 1.5),
        ),
      ),
    );
  }
}