import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../logic/enter_new_password_provider.dart';


class ConfirmPasswordFieldGroup extends ConsumerWidget {
  const ConfirmPasswordFieldGroup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(resetProvider);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 22.w, bottom: 12.h),
            child: Text(
              'Xác nhận mật khẩu',
              style: TextStyle(
                color: Colors.black,
                fontSize: 22.sp,
                fontFamily: 'SF Pro Rounded',
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 65.h,
            decoration: ShapeDecoration(
              color: const Color(0xFFEBEBEB),
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  color: Colors.black.withAlpha((0.4 * 255).toInt()),
                ),
                borderRadius: BorderRadius.circular(50.r),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 25.w),
                    child: TextField(
                      controller: controller.confirmController,
                      obscureText: controller.obscureConfirm,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22.sp,
                        fontFamily: 'SF Pro Rounded',
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 20.w),
                  child: GestureDetector(
                    onTap: controller.toggleConfirm,
                    child: Icon(
                      controller.obscureConfirm
                          ? Icons.visibility_off
                          : Icons.visibility,
                      size: 24.w,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
