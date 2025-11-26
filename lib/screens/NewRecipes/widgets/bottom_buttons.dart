// lib/features/add_recipe/widgets/bottom_buttons.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomButtons extends StatelessWidget {
  final VoidCallback? onRegister; // THÊM DÒNG NÀY – callback khi nhấn Đăng

  const BottomButtons({
    Key? key,
    this.onRegister, // NHẬN VÀO
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.h, left: 36.w, right: 36.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SizedBox(
              height: 70.h,
              child: OutlinedButton(
                onPressed: () {
                  // TODO: Xử lý lưu nháp sau
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.black.withOpacity(0.4), width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                ),
                child: Text(
                  'Lưu nháp',
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ),
            ),
          ),
          SizedBox(width: 20.w),
          Expanded(
            child: SizedBox(
              height: 70.h,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20.r),
                  onTap: onRegister,
                  child: Container(
                    decoration: ShapeDecoration(
                      color: const Color(0xFFFFB901),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: Colors.black.withOpacity(0.40)),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Đăng',
                        style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}