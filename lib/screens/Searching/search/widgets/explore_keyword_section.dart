// lib/screens/search/widgets/keywords_section.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class KeywordsSection extends StatelessWidget {
  final double width;
  final Function(String)? onKeywordSelected;

  const KeywordsSection({
    super.key,
    required this.width,
    this.onKeywordSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final keywords = [
      'Healthy', 'Đồ cay', 'Ngọt', 'Đồ ăn nhanh',
      'Mỳ sốt', 'Ăn sáng', 'Bánh', 'Súp', 'Đồ chay',
    ];

    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final tagBgColor = isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF2F2F2);
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.white : const Color(0xFF00695C);
    final borderColor = isDark ? Colors.white.withOpacity(0.18) : Colors.black.withOpacity(0.15);

    return Container(
      width: width,
      color: bgColor,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Từ khóa nổi bật'.tr(),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              Text(
                'Xem thêm',
                style: TextStyle(
                  fontSize: 14.5.sp,
                  fontWeight: FontWeight.w600,
                  color: subtitleColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children: keywords.map((k) {
              return GestureDetector(
                onTap: () {
                  if (onKeywordSelected != null) {
                    onKeywordSelected!(k);
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 11.h),
                  decoration: BoxDecoration(
                    color: tagBgColor,
                    borderRadius: BorderRadius.circular(30.r),
                    border: Border.all(color: borderColor, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.5 : 0.08),
                        blurRadius: isDark ? 10 : 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    k,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.5.sp,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}