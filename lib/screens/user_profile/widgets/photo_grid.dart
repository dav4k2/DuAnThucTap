// lib/screens/user_profile/widgets/photo_grid.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PhotoGrid extends StatelessWidget {
  const PhotoGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(43.w, 0.h, 43.w, 20.h),
      child: GridView.builder(
        shrinkWrap: true, // ← QUAN TRỌNG: cho phép GridView co lại
        physics: const NeverScrollableScrollPhysics(), // ← để SingleChildScrollView cuộn
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16.h,
          crossAxisSpacing: 16.w,
          childAspectRatio: 150 / 120,
        ),
        itemCount: 10, // giả lập 50 ảnh
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              image: DecorationImage(
                image: AssetImage("image/profile_bg.png"),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}