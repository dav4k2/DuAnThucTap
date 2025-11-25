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


  final Color? forceIconColor;
  final Color? forceTextColor;

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
    this.forceIconColor,
    this.forceTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium!.color!;
    final goldColor = const Color(0xFFD4A017);

    // DÙNG MÀU ĐỎ CỐ ĐỊNH NẾU CÓ, KHÔNG THÌ DÙNG THEO THEME
    final iconColor = forceIconColor ?? goldColor;
    final titleColor = forceTextColor ?? textColor;
    final arrowColor = forceIconColor ?? goldColor;

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
          splashColor: (forceIconColor ?? goldColor).withOpacity(0.15),
          highlightColor: (forceIconColor ?? goldColor).withOpacity(0.08),
          child: Row(
            children: [
              SizedBox(width: iconLeft.w),
              Image.asset(
                iconPath,
                width: 31.w,
                height: 31.h,
                fit: BoxFit.contain,
                color: iconColor, // ← giờ có thể đỏ
                errorBuilder: (_, __, ___) => Icon(Icons.image, size: 31.sp, color: iconColor),
              ),
              SizedBox(width: 11.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 28.sp,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w600,
                    height: 1.0,
                  ),
                ),
              ),
              if (trailing != null) ...[trailing!, SizedBox(width: 10.w)],
              if (showArrow || customArrow != null)
                Padding(
                  padding: EdgeInsets.only(right: 20.w),
                  child: Icon(
                    customArrow ?? Icons.arrow_forward_ios,
                    size: 24.sp,
                    color: arrowColor,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}