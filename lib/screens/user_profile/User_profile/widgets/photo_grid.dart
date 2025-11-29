// lib/screens/user_profile/widgets/photo_grid.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PhotoGrid extends StatelessWidget {
  const PhotoGrid({super.key});

  // Ảnh test
  static final List<String> _localImages = [
    "image/profile_bg.png",
    "image/profile_bg.png",
    "image/profile_bg.png",
    "image/profile_bg.png",
    "image/profile_bg.png",
    "image/profile_bg.png",

  ];

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10.h,
            crossAxisSpacing: 10.w,
            childAspectRatio: 150 / 150,
          ),
          itemCount: _localImages.length,
          itemBuilder: (context, index) {
            final imagePath = _localImages[index];

            return ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, color: Colors.red),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}