// lib/widgets/setting_item.dart (hoặc đường dẫn thực tế của bạn)
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingItem extends StatelessWidget {
  final String iconPath;
  final String title;
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
    this.onTap,
    this.trailing,
    this.showArrow = true,
    this.customArrow,
    this.forceIconColor,
    this.forceTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyMedium?.color ?? Colors.black;
    const Color primaryGoldColor = Color(0xFFFFB901);

    final iconColor = forceIconColor ?? primaryGoldColor;
    final titleColor = forceTextColor ?? textColor;
    final arrowColor = forceIconColor ?? primaryGoldColor;

    // QUAN TRỌNG: Dùng Container, KHÔNG ĐƯỢC DÙNG POSITIONED Ở ĐÂY
    return Container(
      height: 60.h,
      width: double.infinity,
      color: Colors.transparent,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          splashColor: primaryGoldColor.withOpacity(0.15),
          highlightColor: primaryGoldColor.withOpacity(0.08),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                // Icon
                Image.asset(
                  iconPath,
                  width: 31.w,
                  height: 31.h,
                  fit: BoxFit.contain,
                  color: iconColor,
                  errorBuilder: (_, __, ___) => Icon(Icons.image, size: 31.sp, color: iconColor),
                ),
                SizedBox(width: 15.w),
                // Title
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      height: 1.0,
                    ),
                  ),
                ),
                // Trailing & Arrow
                if (trailing != null) ...[trailing!],
                if (showArrow || customArrow != null)
                  Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: Icon(
                      customArrow ?? Icons.arrow_forward_ios_rounded,
                      size: 20.sp,
                      color: arrowColor,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}