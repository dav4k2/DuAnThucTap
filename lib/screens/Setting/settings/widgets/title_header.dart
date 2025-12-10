
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TitleHeader extends StatelessWidget {
  const TitleHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyMedium?.color ?? (theme.brightness == Brightness.dark ? Colors.white : Colors.black);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 20.h, bottom: 10.h),
      alignment: Alignment.center,
      child: Text(
        'settings'.tr(),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: textColor,
          fontSize: 24.sp,
          fontFamily: 'SF Pro',
          fontWeight: FontWeight.w700,
          height: 0.92,
        ),
      ),
    );
  }
}