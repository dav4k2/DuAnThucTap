// lib/screens/survey/widgets/survey_avatar_picker.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SurveyAvatarPicker extends StatelessWidget {
  final String imageUrl;
  final File? imageFile;        // THÊM DÒNG NÀY
  final VoidCallback onTap;

  const SurveyAvatarPicker({
    super.key,
    required this.imageUrl,
    required this.onTap,
    this.imageFile,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none, // QUAN TRỌNG: để nút camera không bị cắt
      children: [
        // Viền trắng lớn
        Container(
          width: 130.w,
          height: 130.h,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        ),

        // Ảnh avatar
        Positioned(
          left: 5.w,
          top: 5.h,
          child: ClipOval(
            child: Image.network(
              imageUrl,
              width: 120.w,
              height: 120.h,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: 120.w,
                  height: 120.h,
                  color: Colors.grey[300],
                  child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 120.w,
                  height: 120.h,
                  color: Colors.grey[300],
                  child: Icon(Icons.person, size: 60.sp, color: Colors.grey[600]),
                );
              },
            ),
          ),
        ),

        // Nút camera nhỏ ở góc dưới phải – ĐẸP, ẤN MƯỢT, CÓ RIPPLE
        Positioned(
          right: -8.w,
          bottom: -8.h,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(25.r),
              onTap: onTap,
              child: Ink(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Container(
                  width: 44.w,
                  height: 44.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    size: 22.sp,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}