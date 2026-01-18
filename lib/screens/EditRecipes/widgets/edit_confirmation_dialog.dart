import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../NewRecipes/logic/add_recipe_provider.dart';


class EditExitConfirmationDialog extends ConsumerWidget {
  const EditExitConfirmationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final dialogBg = isDark ? Colors.grey[850] : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final secondaryTextColor = isDark ? Colors.grey[300] : Colors.grey[700];
    final buttonBgColor = isDark ? Colors.grey[700] : Colors.grey[100];

    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 32.w),
        padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 24.h),
        decoration: BoxDecoration(
          color: dialogBg,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 20.r,
              offset: Offset(0, 10.h),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80.w,
              height: 80.w,
              decoration: const BoxDecoration(
                color: Color(0xFFFFF3E0),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.help_outline_rounded,
                color: const Color(0xFFFF9800),
                size: 44.sp,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Thoát mà không lưu?',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: textColor,
                decoration: TextDecoration.none,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            Text(
              'Bạn có muốn lưu công thức dưới dạng nháp\ntrước khi thoát không?',
              style: TextStyle(
                fontSize: 15.5.sp,
                color: secondaryTextColor,
                height: 1.5,
                decoration: TextDecoration.none,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      Navigator.pop(context, true);
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        side: BorderSide(color: isDark ? Colors.grey[600]! : Colors.grey[300]!),
                      ),
                    ),
                    child: Text(
                      'Không lưu',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: secondaryTextColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context, null),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      backgroundColor: buttonBgColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    child: Text(
                      'Hủy',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: const Color(0xFFFE724C),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      // 1. Gọi lưu nháp (logic mới đã xử lý mảng lồng nhau)
                      final success = await ref.read(addRecipeProvider.notifier).saveAsDraft(context);

                      // 2. Chỉ thoát nếu lưu thành công
                      if (success && context.mounted) {
                        Navigator.pop(context, true); // Trả về true để Screen chính cũng pop
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFE724C),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      elevation: 6,
                      shadowColor: const Color(0xFFFE724C).withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    child: Text(
                      'Lưu nháp',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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