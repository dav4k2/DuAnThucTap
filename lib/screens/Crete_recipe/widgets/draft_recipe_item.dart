import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../theme/theme_provider.dart';
import '../../NewRecipes/add_recipe_screen.dart';
import '../../NewRecipes/logic/add_recipe_provider.dart';
import '../logic/draft_recipe.dart';
import '../logic/draft_service.dart'; // Import service để gọi hàm xóa

class DraftRecipeItem extends ConsumerWidget {
  final DraftRecipe draft;

  const DraftRecipeItem({Key? key, required this.draft}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);

    final bgColor = isDarkMode ? const Color(0xFF1C1C1E) : Colors.white;
    final titleColor = isDarkMode ? Colors.white : Colors.black;
    final subtitleColor = isDarkMode ? Colors.grey[300] : Colors.grey[600];
    final iconColor = isDarkMode ? Colors.grey[400] : Colors.grey[400];

    return Dismissible(
      // Key phải là duy nhất để Flutter định danh được widget nào bị xóa
      key: ValueKey('draft_${draft.id}'),

      // Chỉ cho phép trượt từ phải sang trái (End to Start)
      direction: DismissDirection.endToStart,

      // Giao diện hiện ra phía sau khi trượt
      secondaryBackground: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: Colors.white,
          size: 30,
        ),
      ),

      // Background mặc định (trượt phải) - để trống nếu không dùng
      background: Container(),

      // Hàm xác nhận trước khi thực hiện xóa
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: bgColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
            title: Text(
              'Xóa bản nháp?'.tr(),
              style: TextStyle(color: titleColor, fontWeight: FontWeight.bold),
            ),
            content: Text(
              tr(
                "delete_recipe_confirmation",
                namedArgs: {"title": draft.title},
              ),
              style: TextStyle(color: subtitleColor),
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false), // Trả về false -> Hủy xóa
                child: const Text('Hủy', style: TextStyle(color: Colors.grey)).tr(),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true), // Trả về true -> Đồng ý xóa
                child: const Text('Xóa', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)).tr()
              ),
            ],
          ),
        );
      },

      // Hàm thực hiện xóa khi đã xác nhận
      onDismissed: (direction) {
        // Gọi service để xóa trên Firestore
        ref.read(draftServiceProvider).deleteDraft(draft.id);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              tr(
                "draft_deleted_snackbar",
                namedArgs: {"title": draft.title},
              ),
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },

      child: GestureDetector(
        onTap: () {
          ref.read(addRecipeProvider.notifier).loadFromDraft(draft);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddRecipeScreen()),
          );
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 16.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: isDarkMode ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  width: 72.w,
                  height: 72.w,
                  color: Colors.grey[300],
                  child: draft.images.isNotEmpty
                      ? (draft.images.first.startsWith('http')
                      ? Image.network(draft.images.first, fit: BoxFit.cover)
                      : Image.file(File(draft.images.first), fit: BoxFit.cover))
                      : Image.asset('image/empty.png', fit: BoxFit.cover),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      draft.title,
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        color: titleColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      tr(
                        "draft_info_line",
                        namedArgs: {
                          "timeAgo": draft.timeAgo,
                          "steps": draft.steps.length.toString(),
                          "ingredients": draft.ingredients.length.toString(),
                        },
                      ),
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: subtitleColor,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: iconColor),
            ],
          ),
        ),
      ),
    );
  }
}