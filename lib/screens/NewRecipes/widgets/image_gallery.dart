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
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      // Dùng hàm có sẵn trong provider thay vì tự xử lý list
      ref.read(addRecipeProvider.notifier).addImage(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final images = ref.watch(addRecipeProvider).images;

    // Tạo danh sách 6 phần tử (có ảnh hoặc rỗng)
    final displayImages = List<String>.from(images);
    while (displayImages.length < 6) displayImages.add('');

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
                  _buildImageBox(
                    size: smallBoxSize * 2 + spacing,
                    imagePath: displayImages[0],
                    index: 0,
                    ref: ref,
                    onTap: () => _pickImage(ref, 0),
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
                      ),
                      SizedBox(height: spacing),
                      _buildImageBox(
                        size: smallBoxSize,
                        imagePath: displayImages[2],
                        index: 2,
                        ref: ref,
                        onTap: () => _pickImage(ref, 2),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: spacing),

              // HÀNG 2: 3 ô nhỏ
              Row(
                children: [
                  _buildImageBox(
                    size: smallBoxSize,
                    imagePath: displayImages[3],
                    index: 3,
                    ref: ref,
                    onTap: () => _pickImage(ref, 3),
                    margin: EdgeInsets.only(right: spacing),
                  ),
                  _buildImageBox(
                    size: smallBoxSize,
                    imagePath: displayImages[4],
                    index: 4,
                    ref: ref,
                    onTap: () => _pickImage(ref, 4),
                    margin: EdgeInsets.only(right: spacing),
                  ),
                  _buildImageBox(
                    size: smallBoxSize,
                    imagePath: displayImages[5],
                    index: 5,
                    ref: ref,
                    onTap: () => _pickImage(ref, 5),
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
  }) {
    final hasImage = imagePath.isNotEmpty;

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
              child: Image.file(File(imagePath), fit: BoxFit.cover),
            ),
            // NÚT XÓA ẢNH – ĐẸP NHƯ STEPITEM
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () {
                  ref.read(addRecipeProvider.notifier).removeImage(index);
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