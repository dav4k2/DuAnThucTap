// lib/screens/Setting/settings/widgets/language.dart
import 'package:easy_localization/easy_localization.dart'; // <--- IMPORT QUAN TRỌNG
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Màu vàng chủ đạo theo yêu cầu
const Color kPrimaryYellow = Color(0xFFFFB901);

class LanguageBottomSheet extends StatelessWidget {
  const LanguageBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Màu nền bottom sheet
    final backgroundColor = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    // Màu thanh kéo (drag handle)
    final dragHandleColor = isDark ? Colors.grey[700] : Colors.grey[300];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 12.h),

          // Thanh kéo
          Container(
            width: 50.w,
            height: 5.h,
            decoration: BoxDecoration(
              color: dragHandleColor,
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),

          SizedBox(height: 20.h),

          // Tiêu đề (Dùng .tr() để dịch)
          Text(
            'language'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.titleLarge?.color,
            ),
          ),

          SizedBox(height: 15.h),

          // Đường kẻ mờ
          Divider(
            height: 1,
            color: isDark ? Colors.white12 : Colors.black12,
            thickness: 1,
          ),

          SizedBox(height: 20.h),

          // Danh sách ngôn ngữ
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                _buildLanguageOption(
                  context: context,
                  title: 'Tiếng Việt',
                  subtitle: 'Vietnamese',
                  value: 'vi',
                ),
                SizedBox(height: 12.h),
                _buildLanguageOption(
                  context: context,
                  title: 'English',
                  subtitle: 'English',
                  value: 'en',
                ),
              ],
            ),
          ),

          SizedBox(height: 30.h + MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String value,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // LOGIC MỚI: Lấy ngôn ngữ hiện tại từ EasyLocalization
    final currentLangCode = context.locale.languageCode;
    final isSelected = currentLangCode == value;

    // Màu sắc logic
    final baseBorderColor = isDark ? Colors.grey[800]! : Colors.grey[200]!;
    final baseBgColor = isDark ? Colors.grey[900]! : Colors.grey[50]!;

    final borderColor = isSelected ? kPrimaryYellow : baseBorderColor;
    final bgColor = isSelected
        ? kPrimaryYellow.withOpacity(isDark ? 0.15 : 0.08)
        : baseBgColor;

    return GestureDetector(
      onTap: () async {
        // LOGIC MỚI: Đặt ngôn ngữ và đóng popup
        await context.setLocale(Locale(value));
        if (context.mounted) {
          Navigator.pop(context);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? kPrimaryYellow
                          : theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),

            if (isSelected)
              Container(
                padding: EdgeInsets.all(4.r),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: kPrimaryYellow,
                ),
                child: Icon(
                  Icons.check,
                  size: 16.sp,
                  color: isDark ? Colors.black : Colors.white,
                ),
              )
            else
              Container(
                width: 24.sp,
                height: 24.sp,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                    width: 1.5,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}