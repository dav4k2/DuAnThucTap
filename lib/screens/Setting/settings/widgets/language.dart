// lib/widgets/language_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fontend/screens/Setting/settings/widgets/reset_pass/password_reset_screen.dart';
import '../../../../theme/app_localizations.dart';
import '../../../../theme/language_provider.dart';


class LanguageBottomSheet extends ConsumerWidget {
  const LanguageBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: 402.w,
      height: 360.h,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
        border: Border.all(color: isDark ? Colors.white24 : Colors.black.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.5) : const Color(0x3F000000),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Thanh kéo
          Positioned(
            top: 10.h,
            left: 140.w,
            child: Container(
              width: 122.w,
              height: 2.h,
              color: isDark ? Colors.white54 : Colors.black.withOpacity(0.5),
            ),
          ),

          // Tiêu đề
          Positioned(
            top: 35.h,
            left: 26.w,
            child: SizedBox(
              width: 349.w,
              child: Text(
                l10n.translate('language'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.36,
                  color: theme.textTheme.titleLarge?.color,
                ),
              ),
            ),
          ),

          // Gạch ngang dưới tiêu đề
          Positioned(
            top: 84.h,
            left: 0,
            child: Container(
              width: 402.w,
              height: 1.h,
              color: isDark ? Colors.white24 : Colors.black.withOpacity(0.15),
            ),
          ),

          // Danh sách ngôn ngữ
          Positioned(
            top: 100.h,
            left: 0,
            right: 0,
            child: Column(
              children: [
                _buildLanguageOption(
                  context: context,
                  ref: ref,
                  title: 'Tiếng Việt',
                  subtitle: 'Vietnamese',
                  value: 'vi',
                ),
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
    final selected = ref.read(languageProvider) == value;

    return ListTile(
      onTap: () {
        ref.read(languageProvider.notifier).set(value);
        Navigator.pop(context);
      },
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: theme.textTheme.bodyLarge?.color,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14.sp,
          color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
        ),
      ),
      trailing: selected
          ? Icon(Icons.check, color: kPrimaryColor)
          : SizedBox(width: 24.w),
    );
  }
}

// Hàm tiện ích để show bottom sheet
void showLanguageBottomSheet(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const LanguageBottomSheet(),
  );
}
