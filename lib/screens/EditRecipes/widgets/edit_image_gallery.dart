// lib/features/add_recipe/widgets/edit_image_gallery.dart
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Quan trọng
import '../logic/edit_recipe_provider.dart'; // Đảm bảo import đúng provider Edit

class EditImageGallery extends ConsumerWidget {
  const EditImageGallery({super.key});

  Future<void> _pickImage(WidgetRef ref, int index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      ref.read(editRecipeProvider.notifier).addImage(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Sửa provider thành editRecipeProvider
    final images = ref.watch(editRecipeProvider).images;
    final displayImages = List<String>.from(images);
    while (displayImages.length < 6) displayImages.add('');

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final boxBg = isDark ? Colors.grey[800] : const Color(0xFFEBEBEB);
    final dottedColor = const Color(0xFFFFB901);

    // ... (Giữ nguyên phần LayoutBuilder)
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 30.h),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final spacing = 15.w;
          final smallBoxSize = (constraints.maxWidth - spacing * 2) / 3;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageBox(
                    size: smallBoxSize * 2 + spacing,
                    imagePath: displayImages[0],
                    index: 0,
                    ref: ref,
                    onTap: () => _pickImage(ref, 0),
                    boxBg: boxBg,
                    dottedColor: dottedColor,
                  ),
                  SizedBox(width: spacing),
                  Column(
                    children: [
                      _buildImageBox(
                        size: smallBoxSize,
                        imagePath: displayImages[1],
                        index: 1,
                        ref: ref,
                        onTap: () => _pickImage(ref, 1),
                        boxBg: boxBg,
                        dottedColor: dottedColor,
                      ),
                      SizedBox(height: spacing),
                      _buildImageBox(
                        size: smallBoxSize,
                        imagePath: displayImages[2],
                        index: 2,
                        ref: ref,
                        onTap: () => _pickImage(ref, 2),
                        boxBg: boxBg,
                        dottedColor: dottedColor,
                      ),
                    ],
                  ),
                ],
              ),
              // ... (Giữ nguyên phần Row dưới)
              SizedBox(height: spacing),
              Row(
                children: [
                  _buildImageBox(
                    size: smallBoxSize,
                    imagePath: displayImages[3],
                    index: 3,
                    ref: ref,
                    onTap: () => _pickImage(ref, 3),
                    margin: EdgeInsets.only(right: spacing),
                    boxBg: boxBg,
                    dottedColor: dottedColor,
                  ),
                  _buildImageBox(
                    size: smallBoxSize,
                    imagePath: displayImages[4],
                    index: 4,
                    ref: ref,
                    onTap: () => _pickImage(ref, 4),
                    margin: EdgeInsets.only(right: spacing),
                    boxBg: boxBg,
                    dottedColor: dottedColor,
                  ),
                  _buildImageBox(
                    size: smallBoxSize,
                    imagePath: displayImages[5],
                    index: 5,
                    ref: ref,
                    onTap: () => _pickImage(ref, 5),
                    boxBg: boxBg,
                    dottedColor: dottedColor,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildImageBox({
    required double size,
    required String imagePath,
    required int index,
    required WidgetRef ref,
    required VoidCallback onTap,
    EdgeInsetsGeometry? margin,
    required Color? boxBg,
    required Color dottedColor,
  }) {
    final hasImage = imagePath.isNotEmpty;

    // --- SỬA LỖI ĐEN MÀN TẠI ĐÂY ---
    Widget imageWidget;
    if (hasImage) {
      if (imagePath.startsWith('http')) {
        // Nếu là Link Online -> Dùng Network
        imageWidget = Image.network(imagePath, fit: BoxFit.cover);
      } else {
        // Nếu là File máy -> Dùng File
        imageWidget = Image.file(File(imagePath), fit: BoxFit.cover);
      }
    } else {
      imageWidget = const SizedBox();
    }
    // -------------------------------

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        margin: margin ?? EdgeInsets.zero,
        child: hasImage
            ? Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: imageWidget, // Thay thế Image.file bằng biến đã check
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () {
                  ref.read(editRecipeProvider.notifier).removeImage(index);
                },
                child: Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close, size: 18.sp, color: Colors.white),
                ),
              ),
            ),
          ],
        )
            : DottedBorder(
          // ... (Giữ nguyên code cũ)
          color: dottedColor,
          strokeWidth: 2,
          dashPattern: const [12, 12],
          borderType: BorderType.RRect,
          radius: Radius.circular(20.r),
          child: Container(
            decoration: BoxDecoration(
              color: boxBg?.withOpacity(0.32),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Center(
              child: Container(
                width: 36.sp,
                height: 36.sp,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: dottedColor, width: 2),
                ),
                child: Icon(Icons.add, size: 20.sp, color: dottedColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}