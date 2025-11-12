import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingItem extends StatelessWidget {
  final String iconPath;
  final String title;
  final double iconLeft, iconTop; // Chỉ cần iconTop để đặt dòng
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool showArrow;
  final IconData? customArrow;

  const SettingItem({
    super.key,
    required this.iconPath,
    required this.title,
    required this.iconLeft,
    required this.iconTop,
    this.onTap,
    this.trailing,
    this.showArrow = true,
    this.customArrow,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      top: iconTop.h,
      width: 402.w,
      height: 60.h,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.grey.withOpacity(0.1),
          child: Row(
            children: [
              // ICON
              SizedBox(width: iconLeft.w),
              Image.asset(
                iconPath,
                width: 31.w,
                height: 31.h,
                fit: BoxFit.contain,
                color: const Color(0xFFD4A017),
                errorBuilder: (_, __, ___) => Icon(Icons.image, size: 31.sp, color: const Color(0xFFD4A017)),
              ),

              SizedBox(width: 11.w),

              // TEXT
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28.sp,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w600,
                    height: 1.0, // Căn giữa dọc
                  ),
                ),
              ),

              // TRAILING
              if (trailing != null) ...[
                trailing!,
                SizedBox(width: 10.w),
              ],

              // MŨI TÊN
              if (showArrow || customArrow != null)
                Padding(
                  padding: EdgeInsets.only(right: 20.w),
                  child: Icon(
                    customArrow ?? Icons.arrow_forward_ios,
                    size: 24.sp,
                    color: const Color(0xFFD4A017),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}