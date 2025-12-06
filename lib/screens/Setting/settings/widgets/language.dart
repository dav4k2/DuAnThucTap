// lib/widgets/language_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../theme/app_localizations.dart';
import '../../../../theme/language_provider.dart';

// Màu vàng chủ đạo theo yêu cầu
const Color kPrimaryYellow = Color(0xFFFFB901);

class LanguageBottomSheet extends ConsumerWidget {
  const LanguageBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Màu nền bottom sheet
    final backgroundColor = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    // Màu thanh kéo (drag handle)
    final dragHandleColor = isDark ? Colors.grey[700] : Colors.grey[300];

    return Container(
      width: double.infinity,
      // Loại bỏ chiều cao cố định để nội dung tự co giãn
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
        mainAxisSize: MainAxisSize.min, // Quan trọng: Chiều cao tối thiểu
        children: [
          SizedBox(height: 12.h),

          // Thanh kéo (Drag Handle) - Căn giữa tự động thay vì Positioned
          Container(
            width: 50.w,
            height: 5.h,
            decoration: BoxDecoration(
              color: dragHandleColor,
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),

          SizedBox(height: 20.h),

          // Tiêu đề
          Text(
            l10n.translate('language'),
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
                  ref: ref,
                  title: 'Tiếng Việt',
                  subtitle: 'Vietnamese',
                  value: 'vi',
                ),
                SizedBox(height: 12.h),
                _buildLanguageOption(
                  context: context,
                  ref: ref,
                  title: 'English',
                  subtitle: 'English',
                  value: 'en',
                ),
              ],
            ),
          ),

          // Khoảng cách an toàn phía dưới (cho các dòng máy tai thỏ/dynamic island)
          SizedBox(height: 30.h + MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required WidgetRef ref,
    required String title,
    required String subtitle,
    required String value,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Dùng watch để UI cập nhật trạng thái ngay lập tức
    final currentLang = ref.watch(languageProvider);
    final isSelected = currentLang == value;

    // Màu sắc logic
    final baseBorderColor = isDark ? Colors.grey[800]! : Colors.grey[200]!;
    final baseBgColor = isDark ? Colors.grey[900]! : Colors.grey[50]!;

    // Khi được chọn: Viền vàng, nền vàng nhạt (opacity thấp)
    final borderColor = isSelected ? kPrimaryYellow : baseBorderColor;
    final bgColor = isSelected
        ? kPrimaryYellow.withOpacity(isDark ? 0.15 : 0.08)
        : baseBgColor;

    return GestureDetector(
      onTap: () {
        // Logic giữ nguyên
        ref.read(languageProvider.notifier).set(value);
        Navigator.pop(context);
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
            // Cờ hoặc Icon ngôn ngữ (Optional: có thể thêm hình cờ vào đây nếu muốn)

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

            // Icon check vàng
            if (isSelected)
              Container(
                padding: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
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
            // Placeholder để giữ layout không bị nhảy
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

// Hàm tiện ích g
void showLanguageBottomSheet(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const LanguageBottomSheet(),
  );
}