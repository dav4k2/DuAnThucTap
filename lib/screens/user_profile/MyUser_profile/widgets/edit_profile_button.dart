import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../theme/theme_provider.dart';

import '../../Edit_user/edit_profile_screen.dart';

class EditProfileButton extends ConsumerWidget {
  final VoidCallback? onTap;
  const EditProfileButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);

    // Nền nút: Light mode trắng, Dark mode vàng FFC836
    final bgColor = isDarkMode ? const Color(0xFFFFC836) : Colors.white;

    // Màu chữ, icon, border: Light mode vàng, Dark mode đen tương phản
    final contentColor = isDarkMode ? Colors.black87 : const Color(0xFFFFB901);

    return Positioned(
      left: 62.w,
      top: 437.h,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 277.w,
          height: 39.h,
          decoration: ShapeDecoration(
            color: bgColor,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                color: contentColor,
              ),
              borderRadius: BorderRadius.circular(30.r),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 4,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Icon chỉnh sửa
              Positioned(
                left: 20.w,
                child: Icon(
                  Icons.edit_outlined,
                  size: 20.sp,
                  color: contentColor,
                ),
              ),
              // Text
              Text(
                'Chỉnh sửa hồ sơ',
                style: TextStyle(
                  color: contentColor,
                  fontSize: 20.sp,
                  fontFamily: 'SF Pro Rounded',
                  fontWeight: FontWeight.w600,
                  height: 1.10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
