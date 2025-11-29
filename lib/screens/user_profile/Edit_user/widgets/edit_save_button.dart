import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditSaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const EditSaveButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    // Thay thế Positioned bằng Padding
    return Padding(
      // Thêm padding ngang để căn chỉnh nút vào giữa
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          // Dùng double.infinity để Container chiếm hết chiều rộng của Padding
          width: double.infinity,
          height: 44.h,
          decoration: ShapeDecoration(
            color: const Color(0xFFFFB901),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
            shadows: const [BoxShadow(color: Color(0x3F000000), blurRadius: 4, offset: Offset(0, 4))],
          ),
          alignment: Alignment.center,
          child: Text('Lưu', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600, color: Colors.black)),
        ),
      ),
    );
  }
}