import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../theme/theme_provider.dart';

class ResponsiveButtonCard extends ConsumerWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Widget icon;

  // Light mode colors
  final Color titleColorLight;
  final Color subtitleColorLight;
  final Color backgroundColorLight;

  // Dark mode colors
  final Color titleColorDark;
  final Color subtitleColorDark;
  final Color backgroundColorDark;

  const ResponsiveButtonCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.icon,
    required this.titleColorLight,
    required this.subtitleColorLight,
    required this.backgroundColorLight,
    required this.titleColorDark,
    required this.subtitleColorDark,
    required this.backgroundColorDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);

    final titleColor = isDarkMode ? titleColorDark : titleColorLight;
    final subtitleColor = isDarkMode ? subtitleColorDark : subtitleColorLight;
    final backgroundColor = isDarkMode ? backgroundColorDark : backgroundColorLight;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150.w,
        height: 160.h,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
              blurRadius: 6.r,
              offset: Offset(0, 3.h),
            ),
          ],
        ),
        padding: EdgeInsets.all(15.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            icon,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 18.sp,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: subtitleColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
