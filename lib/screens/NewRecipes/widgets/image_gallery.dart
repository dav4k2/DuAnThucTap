// lib/features/add_recipe/widgets/image_gallery.dart

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../logic/add_recipe_provider.dart';

class ImageGallery extends ConsumerWidget {
  const ImageGallery({super.key});

  Future<void> _pickImage(WidgetRef ref, int index) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final path = pickedFile.path;

        final currentImages = ref.read(addRecipeProvider).images;
        final List<String> newImages = List.from(currentImages);

        // Đảm bảo danh sách đủ dài
        while (newImages.length <= index) {
          newImages.add('');
        }

        newImages[index] = path;

        // Loại bỏ phần tử rỗng ở cuối nếu có
        while (newImages.isNotEmpty && newImages.last.isEmpty) {
          newImages.removeLast();
        }

        ref.read(addRecipeProvider.notifier).state =
            ref.read(addRecipeProvider.notifier).state.copyWith(images: newImages);
      }
    } catch (e) {
      debugPrint('Lỗi chọn ảnh: $e');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final images = ref.watch(addRecipeProvider).images.take(6).toList();
    // Đảm bảo luôn có 6 vị trí (dù rỗng)
    while (images.length < 6) images.add('');

    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 30.h),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final spacing = 15.w;
          final smallBoxSize = (constraints.maxWidth - spacing * 2) / 3;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HÀNG 1: Ảnh lớn + 2 ô nhỏ
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBox(
                    size: smallBoxSize * 2 + spacing,
                    imagePath: images[0],
                    onTap: () => _pickImage(ref, 0),
                  ),
                  SizedBox(width: spacing),
                  Column(
                    children: [
                      _buildBox(size: smallBoxSize, imagePath: images[1], onTap: () => _pickImage(ref, 1)),
                      SizedBox(height: spacing),
                      _buildBox(size: smallBoxSize, imagePath: images[2], onTap: () => _pickImage(ref, 2)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: spacing),
              // HÀNG 2: 3 ô nhỏ
              Row(
                children: [
                  _buildBox(size: smallBoxSize, imagePath: images[3], onTap: () => _pickImage(ref, 3), margin: EdgeInsets.only(right: spacing)),
                  _buildBox(size: smallBoxSize, imagePath: images[4], onTap: () => _pickImage(ref, 4), margin: EdgeInsets.only(right: spacing)),
                  _buildBox(size: smallBoxSize, imagePath: images[5], onTap: () => _pickImage(ref, 5)),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBox({
    required double size,
    required String imagePath,
    required VoidCallback onTap,
    EdgeInsetsGeometry? margin,
  }) {
    final hasImage = imagePath.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        margin: margin ?? EdgeInsets.zero,
        child: hasImage
            ? ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Image.file(File(imagePath), fit: BoxFit.cover),
        )
            : DottedBorder(
          color: const Color(0xFFFFB901),
          strokeWidth: 2,
          dashPattern: const [12, 12],
          borderType: BorderType.RRect,
          radius: Radius.circular(20.r),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0x51D4D4D4),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Center(
              child: Container(
                width: 36.sp,
                height: 36.sp,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFFFB901), width: 2),
                ),
                child: Icon(Icons.add, size: 20.sp, color: const Color(0xFFFFB901)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}