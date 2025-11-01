import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../logic/verify_provider.dart';

class VerifyButton extends ConsumerWidget {
  const VerifyButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(verifyCodeProvider.notifier).submitCode(context);
      },
      child: Container(
        height: 65.h,
        width: 371.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFFFB901),
          borderRadius: BorderRadius.circular(50.r),
          border: Border.all(color: Colors.black, width: 2.w),
        ),
        child: Text(
          'Xác nhận',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24.sp,
            fontFamily: 'SF Pro Rounded',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
