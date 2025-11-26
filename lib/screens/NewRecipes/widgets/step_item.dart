// lib/features/add_recipe/widgets/step_item.dart
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../logic/add_recipe_provider.dart';

class StepItem extends ConsumerWidget {
  final int index;
  final String description;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onDelete;

  const StepItem({
    Key? key,
    required this.index,
    required this.description,
    this.onChanged,
    this.onDelete,
  }) : super(key: key);

  Future<void> _pickImage(BuildContext context, WidgetRef ref) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      ref.read(addRecipeProvider.notifier).updateStepImage(index, pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stepImagePath = ref.watch(
      addRecipeProvider.select((s) => s.stepImages.length > index ? s.stepImages[index] : null),
    );

    final errorText = ref.watch(
      addRecipeProvider.select((s) => s.stepErrors.length > index ? s.stepErrors[index] : null),
    );

    return Padding(
      padding: EdgeInsets.only(top: 30.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 15.w),
          Text('${index + 1}', style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
          SizedBox(width: 20.w),
          Container(width: 3.w, height: 46.h, color: const Color(0xFF21DB53)),
          SizedBox(width: 20.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ô NHẬP + LỖI ĐỎ KHÔNG BỊ CHỒNG
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBEBEB),
                    borderRadius: BorderRadius.circular(20.r),
                    border: errorText != null ? Border.all(color: Colors.red, width: 1.5) : null,
                  ),
                  child: TextField(
                    controller: TextEditingController(text: description)
                      ..selection = TextSelection.fromPosition(TextPosition(offset: description.length)),
                    style: TextStyle(fontSize: 15.sp, color: Colors.black87),
                    decoration: InputDecoration(
                      hintText: 'Mô tả chi tiết bước này...',
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),

                    ),
                    maxLines: null,
                    onChanged: onChanged,
                  ),
                ),


                 if (errorText != null)
                   Padding(
                    padding: EdgeInsets.only(top: 6.h),
                    child: Text(errorText, style: TextStyle(color: Colors.red, fontSize: 12.sp)),
                  ),

                SizedBox(height: 12.h),

                // Ô ẢNH BƯỚC
                GestureDetector(
                  onTap: () => _pickImage(context, ref),
                  child: DottedBorder(
                    color: const Color(0xFFFFB901),
                    strokeWidth: 2.5,
                    dashPattern: const [8, 5],
                    borderType: BorderType.RRect,
                    radius: Radius.circular(20.r),
                    child: Container(
                      width: 68.w,
                      height: 68.h,
                      decoration: BoxDecoration(
                        color: const Color(0x51D4D4D4),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: stepImagePath == null
                          ? Center(child: Icon(Icons.add, size: 28.sp, color: const Color(0xFFFFB901)))
                          : Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20.r),
                            child: Image.file(File(stepImagePath), width: 68.w, height: 68.h, fit: BoxFit.cover),
                          ),
                          Positioned(
                            top: 4, right: 4,
                            child: GestureDetector(
                              onTap: () => ref.read(addRecipeProvider.notifier).clearStepImage(index),
                              child: Container(
                                padding: EdgeInsets.all(4.w),
                                decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                                child: Icon(Icons.close, size: 14.sp, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (onDelete != null)
            IconButton(
              icon: Icon(Icons.close, size: 20.sp, color: Colors.grey.shade600),
              onPressed: onDelete,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          SizedBox(width: 20.w),
        ],
      ),
    );
  }
}