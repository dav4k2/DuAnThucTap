// lib/widgets/setting_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingItem extends StatelessWidget {
  final String iconPath;
  final String title;
  final double iconLeft, iconTop;
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
    // LẤY MÀU TỪ THEME → TỰ ĐỔI THEO DARK MODE
    final textColor = Theme.of(context).textTheme.bodyMedium!.color!;
    final goldColor = const Color(0xFFD4A017);

    return Positioned(
      left: 0,
      top: iconTop.h,
      width: 402.w,
      height: 60.h,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          splashColor: goldColor.withOpacity(0.15), // RIPPLE VÀNG NHẸ
          highlightColor: goldColor.withOpacity(0.08),
          child: Row(
            children: [
              // ICON
              SizedBox(width: iconLeft.w),
              Image.asset(
                iconPath,
                width: 31.w,
                height: 31.h,
                fit: BoxFit.contain,
                color: goldColor,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.image,
                  size: 31.sp,
                  color: goldColor,
                ),
              ),
              SizedBox(width: 11.w),

              // TEXT
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: textColor, // TỰ ĐỔI: ĐEN → TRẮNG
                    fontSize: 28.sp,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w600,
                    height: 1.0,
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
                    color: goldColor,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}