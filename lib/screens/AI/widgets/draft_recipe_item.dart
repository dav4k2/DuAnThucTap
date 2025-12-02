// lib/screens/AI/widgets/draft_recipe_item.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../NewRecipes/add_recipe_screen.dart';
import '../../NewRecipes/logic/add_recipe_provider.dart';
import '../logic/draft_recipe.dart';

class DraftRecipeItem extends ConsumerWidget {
  final DraftRecipe draft;

  const DraftRecipeItem({Key? key, required this.draft}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: Offset(0, 4)),
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
                    ? Image.file(File(draft.images.first), fit: BoxFit.cover)
                    : Image.asset('assets/images/placeholder.jpg', fit: BoxFit.cover),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    draft.title,
                    style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Sửa ${draft.timeAgo} • ${draft.steps.length} bước • ${draft.ingredients.length} nguyên liệu',
                    style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}