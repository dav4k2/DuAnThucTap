// lib/features/add_recipe/widgets/ingredient_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../logic/add_recipe_provider.dart';

class IngredientItem extends ConsumerWidget {
  final String text;
  final int index;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onDelete;

  const IngredientItem({
    Key? key,
    required this.text,
    required this.index,
    this.onChanged,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final errorText = ref.watch(
      addRecipeProvider.select((s) => s.ingredientErrors.length > index ? s.ingredientErrors[index] : null),
    );

    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(width: 36.w),
              Container(
                width: 8.w,
                height: 8.h,
                decoration: const BoxDecoration(color: Color(0xFFFFB901), shape: BoxShape.circle),
              ),
              SizedBox(width: 20.w),
              Expanded(
                child: Container(
                  height: 48.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBEBEB),
                    borderRadius: BorderRadius.circular(20.r),
                    border: errorText != null
                        ? Border.all(color: Colors.red, width: 1.5)
                        : null,
                  ),
                  child: TextField(
                    controller: TextEditingController(text: text)
                      ..selection = TextSelection.fromPosition(TextPosition(offset: text.length)),
                    style: TextStyle(fontSize: 15.sp, color: Colors.black87),
                    decoration: InputDecoration(
                      hintText: 'VD: 200g bột mì, 2 quả trứng...',
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                      // BỎ errorText ở đây → KHÔNG CÒN CHỒNG NỮA!
                    ),
                    onChanged: onChanged,
                  ),
                ),
              ),
              if (onDelete != null)
                IconButton(
                  icon: Icon(Icons.close, size: 20.sp, color: Colors.grey.shade600),
                  onPressed: onDelete,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              SizedBox(width: 16.w),
            ],
          ),


          if (errorText != null)
            Padding(
              padding: EdgeInsets.only(left: 64.w, top: 6.h), // Căn đẹp với chấm vàng
              child: Text(
                errorText,
                style: TextStyle(color: Colors.red, fontSize: 12.sp, fontWeight: FontWeight.w500),
              ),
            ),
        ],
      ),
    );
  }
}